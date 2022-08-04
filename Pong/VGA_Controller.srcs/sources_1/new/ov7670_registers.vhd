----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.08.2022 00:43:19
-- Design Name: 
-- Module Name: ov7670_registers - Behavioral
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
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ov7670_registers is
    Port (
        clk : IN STD_LOGIC;
		advance : IN STD_LOGIC;
		command : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		finished : OUT STD_LOGIC
     );
end ov7670_registers;

architecture Behavioral of ov7670_registers is
	SIGNAL sreg : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL address : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
BEGIN
	command <= sreg;
	WITH sreg SELECT finished <= '1' WHEN x"FFFF", '0' WHEN OTHERS;

	PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF advance = '1' THEN
				address <= STD_LOGIC_VECTOR(unsigned(address) + 1);
			END IF;

			CASE address IS
				WHEN x"00" => sreg <= x"1280"; -- COM7   Reset
				WHEN x"01" => sreg <= x"1280"; -- COM7   Reset
				WHEN x"02" => sreg <= x"1204"; -- COM7   Size & RGB output
				WHEN x"03" => sreg <= x"1100"; -- CLKRC  Prescaler - Fin/(1+1)
				WHEN x"04" => sreg <= x"0C00"; -- COM3   Lots of stuff, enable scaling, all others off
				WHEN x"05" => sreg <= x"3E00"; -- COM14  PCLK scaling off

				WHEN x"06" => sreg <= x"8C00"; -- RGB444 Set RGB format
				WHEN x"07" => sreg <= x"0400"; -- COM1   no CCIR601
				
				WHEN x"08" => sreg <= x"4010"; -- COM15  Full 0-255 output, RGB 565
--                WHEN x"08" => sreg <= x"8c02"; -- RGB444 mit Format xR GB

				WHEN x"09" => sreg <= x"3a04"; -- TSLB   Set UV ordering,  do not auto-reset window
				WHEN x"0A" => sreg <= x"1438"; -- COM9  - AGC Celling
				WHEN x"0B" => sreg <= x"4fb3"; -- MTX1  - colour conversion matrix
				WHEN x"0C" => sreg <= x"50b3"; -- MTX2  - colour conversion matrix
				WHEN x"0D" => sreg <= x"5100"; -- MTX3  - colour conversion matrix
				WHEN x"0E" => sreg <= x"523d"; -- MTX4  - colour conversion matrix
				WHEN x"0F" => sreg <= x"53a7"; -- MTX5  - colour conversion matrix
				WHEN x"10" => sreg <= x"54e4"; -- MTX6  - colour conversion matrix
				WHEN x"11" => sreg <= x"589e"; -- MTXS  - Matrix sign and auto contrast
				WHEN x"12" => sreg <= x"3dc0"; -- COM13 - Turn on GAMMA and UV Auto adjust
				WHEN x"13" => sreg <= x"1100"; -- CLKRC  Prescaler - Fin/(1+1)

				WHEN x"14" => sreg <= x"1711"; -- HSTART HREF start (high 8 bits)
				WHEN x"15" => sreg <= x"1861"; -- HSTOP  HREF stop (high 8 bits)
				WHEN x"16" => sreg <= x"32A4"; -- HREF   Edge offset and low 3 bits of HSTART and HSTOP

				WHEN x"17" => sreg <= x"1903"; -- VSTART VSYNC start (high 8 bits)
				WHEN x"18" => sreg <= x"1A7b"; -- VSTOP  VSYNC stop (high 8 bits) 
				WHEN x"19" => sreg <= x"030a"; -- VREF   VSYNC low two bits

				WHEN x"1A" => sreg <= x"0e61"; -- COM5(0x0E) 0x61
				WHEN x"1B" => sreg <= x"0f4b"; -- COM6(0x0F) 0x4B 

				WHEN x"1C" => sreg <= x"1602"; --
				WHEN x"1D" => sreg <= x"1e37"; -- MVFP (0x1E) 0x07  -- FLIP AND MIRROR IMAGE 0x3x

				WHEN x"1E" => sreg <= x"2102";
				WHEN x"1F" => sreg <= x"2291";

				WHEN x"20" => sreg <= x"2907";
				WHEN x"21" => sreg <= x"330b";

				WHEN x"22" => sreg <= x"350b"; 
				WHEN x"23" => sreg <= x"371d";

				WHEN x"24" => sreg <= x"3871";
				WHEN x"25" => sreg <= x"392a";

				WHEN x"26" => sreg <= x"3c78"; -- COM12 (0x3C) 0x78
				WHEN x"27" => sreg <= x"4d40";

				WHEN x"28" => sreg <= x"4e20";
				WHEN x"29" => sreg <= x"6905"; -- GFIX (0x69) 0x00 -- gain r and b to 1.25x

				WHEN x"2A" => sreg <= x"6b4a";
				WHEN x"2B" => sreg <= x"7410";

				WHEN x"2C" => sreg <= x"8d4f";
				WHEN x"2D" => sreg <= x"8e00";

				WHEN x"2E" => sreg <= x"8f00";
				WHEN x"2F" => sreg <= x"9000";

				WHEN x"30" => sreg <= x"9100";
				WHEN x"31" => sreg <= x"9600";

				WHEN x"32" => sreg <= x"9a00";
				WHEN x"33" => sreg <= x"b084";

				WHEN x"34" => sreg <= x"b10c";
				WHEN x"35" => sreg <= x"b20e";

				WHEN x"36" => sreg <= x"b382";
				WHEN x"37" => sreg <= x"b80a";
				
				
				
				-- Testbild
--				WHEN x"38" => sreg <= x"708a";
--				WHEN x"39" => sreg <= x"718a";
				
				
				
				
				WHEN OTHERS => sreg <= x"ffff";
			END CASE;
		END IF;
	END PROCESS;
END Behavioral;