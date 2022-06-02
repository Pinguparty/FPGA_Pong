----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2022 21:08:40
-- Design Name: 
-- Module Name: vga_test_tb - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_test_tb is
end vga_test_tb;

architecture Behavioral of vga_test_tb is

    signal clk100Mhz : std_logic := '0';
    signal nreset    : std_logic := '0'; -- Negative reset
    
    signal VGA_RED_VAL : STD_LOGIC_VECTOR (3 downto 0);
    signal VGA_BLUE_VAL : STD_LOGIC_VECTOR (3 downto 0);
    signal VGA_GREEN_VAL : STD_LOGIC_VECTOR (3 downto 0);
    signal HSync_Val     : std_logic := '0';
    signal VSync_Val     : std_logic := '0';
    signal ledValues     : std_logic_vector(4 downto 0);
 
  -- Clock period definitions (simulate a 100Mhz clock)
  constant clk_period : time := 10 ns;

begin

    uut : entity work.VGA_test(Behavioral)
        port map (VGA_HS_O => HSync_Val,
                  VGA_VS_O => VSync_Val,
                  VGA_RED_O => VGA_RED_VAL,
                  VGA_BLUE_O => VGA_BLUE_VAL,
                  VGA_GREEN_O => VGA_GREEN_VAL,
                  nreset => nreset,
                  clk100Mhz => clk100Mhz);
    
    clk_process : process
      begin
        clk100Mhz <= '0';
        wait for clk_period / 2;
        clk100Mhz <= '1';
        wait for clk_period / 2;
  end process;
  
  -- Stimulus process
  stim_proc : process
  begin
    wait;

  end process;


end Behavioral;
