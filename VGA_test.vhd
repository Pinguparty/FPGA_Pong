----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2022 19:31:08
-- Design Name: 
-- Module Name: VGA_test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_test is     
    Port ( RGB : out STD_LOGIC_VECTOR(11 downto 0);
           HSync : out STD_LOGIC;
           VSync : out STD_LOGIC;
           nreset : in STD_LOGIC;
           clk100Mhz : in STD_LOGIC;
           led : out std_logic_vector (4 downto 0)
           );
end VGA_test;

architecture Behavioral of VGA_test is
    
    signal clk25Mhz : std_logic;
    signal locked_in : std_logic;
    signal HSync_sign : std_logic := '0';
    signal VSync_sign : std_logic := '0';
    signal Pixel_x : unsigned(9 downto 0) := (others => '0');
    signal Pixel_y : unsigned(9 downto 0) := (others => '0');
    
    SIGNAL counter : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL counter_n : STD_LOGIC_VECTOR (11 DOWNTO 0);
    
    component clk_wiz_0
        port ( clk_out1     : out    std_logic;
               resetn       : in     std_logic;
               locked       : out    std_logic;
               clk_in1      : in     std_logic);
    end component;
    
    component vga_controller is
        Port (  HSync       : out STD_LOGIC;
                VSync       : out STD_LOGIC;
                Clock_VGA   : in STD_LOGIC;
                n_reset       : in STD_LOGIC;
                x_out       : out UNSIGNED(9 downto 0);
                y_out       : out UNSIGNED(9 downto 0));
    end component vga_controller;

begin

    HSync <= HSync_sign;
    VSync <= VSync_sign;
    
    Clock_25MHz : clk_wiz_0 port 
        map ( clk_out1 => clk25Mhz,     
              resetn => nreset,
              locked => locked_in,
              clk_in1 => clk100Mhz);
              
    VGA_Ctrl    : vga_controller port
        map(HSync => HSync_sign, 
            VSync => VSync_sign, 
            Clock_VGA => clk25Mhz, 
            n_reset => nreset, 
            x_out => Pixel_x, 
            y_out => Pixel_y);

    process(clk25Mhz)
    begin
        if(rising_edge(clk25Mhz)) then
            counter <= counter_n;
            RGB <= counter (11 downto 0);
            led <= counter (11 downto 7);
        end if;
    end process;
    
    -- Next-state logic
    counter_n <= STD_LOGIC_VECTOR(unsigned(counter) + 1);
    

end Behavioral;
