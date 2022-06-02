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
    Port ( VGA_HS_O : out STD_LOGIC;
           VGA_VS_O : out STD_LOGIC;
           VGA_RED_O : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_BLUE_O : out STD_LOGIC_VECTOR (3 downto 0);
           VGA_GREEN_O : out STD_LOGIC_VECTOR (3 downto 0);
           nreset : in STD_LOGIC;
           clk100Mhz : in STD_LOGIC;
           sw1 : in STD_LOGIC
           );
end VGA_test;

architecture Behavioral of VGA_test is
    
    signal clk25Mhz : std_logic;
    signal locked_in : std_logic;
    signal HSync_sign : std_logic := '0';
    signal VSync_sign : std_logic := '0';
    signal Pixel_x : unsigned(9 downto 0) := (others => '0');
    signal Pixel_y : unsigned(9 downto 0) := (others => '0');
    signal active_sig : std_logic;
    signal bg_red : std_logic_vector(3 downto 0);
    signal bg_blue : std_logic_vector(3 downto 0);
    signal bg_green : std_logic_vector(3 downto 0);
    
    SIGNAL counter : STD_LOGIC_VECTOR (32 DOWNTO 0);
    SIGNAL counter_n : STD_LOGIC_VECTOR (32 DOWNTO 0);
    
    component clk_wiz_0
        port ( clk_out1     : out    std_logic;
               resetn       : in     std_logic;
               locked       : out    std_logic;
               clk_in1      : in     std_logic);
    end component;
    
    component vga_controller is
        Port (  HSync : out STD_LOGIC;
                VSync : out STD_LOGIC;
                Clock_VGA   : in STD_LOGIC;
                n_reset       : in STD_LOGIC;
                x_out       : out UNSIGNED(9 downto 0);
                y_out       : out UNSIGNED(9 downto 0);
                active      : out STD_LOGIC);
    end component vga_controller;

begin
    
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
            y_out => Pixel_y,
            active => active_sig);
    
    VGA_HS_O <= HSync_sign;
    VGA_VS_O <= VSync_sign;
    
    process(clk25Mhz, nreset)
    begin
        if(rising_edge(clk25Mhz)) then
            if(active_sig = '1') then
                if(sw1 = '1') then
                    VGA_RED_O <= counter(26 downto 23);
                    VGA_GREEN_O <= counter(27 downto 24);
                    VGA_BLUE_O <= counter(28 downto 25);
                else
                    VGA_RED_O <= std_logic_vector(Pixel_x(7 downto 4));
                    VGA_GREEN_O <= std_logic_vector(Pixel_y(7 downto 4));
                    VGA_BLUE_O <= counter(26 downto 23);
                end if;
            else
            -- Ohne das gehts nicht
                VGA_RED_O <= "0000";
                VGA_GREEN_O <= "0000";
                VGA_BLUE_O <= "0000";
            end if;
            counter <= counter_n;
            
        end if;
    end process;
    
    -- Next-state logic
    counter_n <= STD_LOGIC_VECTOR(unsigned(counter) + 1);
    

end Behavioral;
