----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.06.2022 17:07:51
-- Design Name: 
-- Module Name: seven_segment_controller - Behavioral
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

entity seven_segment_controller is
  Port (
    i_Clk        : in  std_logic;
    i_Binary_Num_P1 : in  std_logic_vector(1 downto 0);
    i_Binary_Num_P2 : in  std_logic_vector(1 downto 0);
    
    o_Segment_A  : out std_logic;
    o_Segment_B  : out std_logic;
    o_Segment_C  : out std_logic;
    o_Segment_D  : out std_logic;
    o_Segment_E  : out std_logic;
    o_Segment_F  : out std_logic;
    o_Segment_G  : out std_logic;
    
    o_Anode_Activate : out STD_LOGIC_VECTOR (7 downto 0) -- 8 Anode signals
    
  );
end entity seven_segment_controller;
   
architecture Behavioral of seven_segment_controller is
    signal r_Hex_Encoding : std_logic_vector(6 downto 0) := (others => '0');
    signal clock_counter : integer Range 0 To 4999 := 0;
begin
-- Purpose: Creates a case statement for all possible input binary numbers.
  -- Drives r_Hex_Encoding appropriately for each input combination.
  process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
    clock_counter <= clock_counter + 1;
      if(clock_counter < 2499) then
          o_Anode_Activate <= "11101111";
          case i_Binary_Num_P1 is
            when "11" => r_Hex_Encoding <= "0000001"; -- 0
            when "10" => r_Hex_Encoding <= "1001111"; -- 1
            when "01" => r_Hex_Encoding <= "0010010"; -- 2
            when "00" => r_Hex_Encoding <= "0000110"; -- 3
--            when "0000" => r_Hex_Encoding <= "0000001"; -- 0
--            when "0001" => r_Hex_Encoding <= "1001111"; -- 1
--            when "0010" => r_Hex_Encoding <= "0010010"; -- 2
--            when "0011" => r_Hex_Encoding <= "0000110"; -- 3
--            when "0100" => r_Hex_Encoding <= "1001100"; -- 4
--            when "0101" => r_Hex_Encoding <= "0100100"; -- 5
--            when "0110" => r_Hex_Encoding <= "0100000"; -- 6
--            when "0111" => r_Hex_Encoding <= "0001111"; -- 7
--            when "1000" => r_Hex_Encoding <= "0000000"; -- 8
--            when "1001" => r_Hex_Encoding <= "0000100"; -- 9
--            when "1010" => r_Hex_Encoding <= "0000010"; -- a
--            when "1011" => r_Hex_Encoding <= "1100000"; -- b
--            when "1100" => r_Hex_Encoding <= "0110001"; -- c
--            when "1101" => r_Hex_Encoding <= "1000010"; -- d
--            when "1110" => r_Hex_Encoding <= "0110000"; -- e
--            when "1111" => r_Hex_Encoding <= "0111000"; -- f
          end case;
      else 
          o_Anode_Activate <= "11111110";
          case i_Binary_Num_P2 is
            when "11" => r_Hex_Encoding <= "0000001"; -- 0
            when "10" => r_Hex_Encoding <= "1001111"; -- 1
            when "01" => r_Hex_Encoding <= "0010010"; -- 2
            when "00" => r_Hex_Encoding <= "0000110"; -- 3
--            when "0000" => r_Hex_Encoding <= "0000001"; -- 0
--            when "0001" => r_Hex_Encoding <= "1001111"; -- 1
--            when "0010" => r_Hex_Encoding <= "0010010"; -- 2
--            when "0011" => r_Hex_Encoding <= "0000110"; -- 3
--            when "0100" => r_Hex_Encoding <= "1001100"; -- 4
--            when "0101" => r_Hex_Encoding <= "0100100"; -- 5
--            when "0110" => r_Hex_Encoding <= "0100000"; -- 6
--            when "0111" => r_Hex_Encoding <= "0001111"; -- 7
--            when "1000" => r_Hex_Encoding <= "0000000"; -- 8
--            when "1001" => r_Hex_Encoding <= "0000100"; -- 9
--            when "1010" => r_Hex_Encoding <= "0000010"; -- a
--            when "1011" => r_Hex_Encoding <= "1100000"; -- b
--            when "1100" => r_Hex_Encoding <= "0110001"; -- c
--            when "1101" => r_Hex_Encoding <= "1000010"; -- d
--            when "1110" => r_Hex_Encoding <= "0110000"; -- e
--            when "1111" => r_Hex_Encoding <= "0111000"; -- f
          end case;
      end if;
    end if;
  end process;
 
  -- r_Hex_Encoding(7) is unused
  o_Segment_A <= r_Hex_Encoding(6);
  o_Segment_B <= r_Hex_Encoding(5);
  o_Segment_C <= r_Hex_Encoding(4);
  o_Segment_D <= r_Hex_Encoding(3);
  o_Segment_E <= r_Hex_Encoding(2);
  o_Segment_F <= r_Hex_Encoding(1);
  o_Segment_G <= r_Hex_Encoding(0);
  
end Behavioral;
