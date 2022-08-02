----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.08.2022 21:57:09
-- Design Name: 
-- Module Name: ov7670_capture - Behavioral
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
USE IEEE.NUMERIC_STD.ALL;

entity ov7670_capture is
    Port ( 
        pclk  : in   STD_LOGIC;
        vsync : in   STD_LOGIC;
        href  : in   STD_LOGIC;
        d     : in   STD_LOGIC_VECTOR (7 downto 0);
        addr  : out  STD_LOGIC_VECTOR (16 downto 0);
        dout  : out  STD_LOGIC_VECTOR (11 downto 0);
        we    : out  STD_LOGIC -- write enable
    );
end ov7670_capture;

architecture Behavioral of ov7670_capture is
   signal d_latch      : std_logic_vector(15 downto 0) := (others => '0');
   signal address      : STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
   signal line         : std_logic_vector(1 downto 0)  := (others => '0');
   signal href_last    : std_logic_vector(6 downto 0)  := (others => '0');
   signal we_reg       : std_logic := '0';
   signal href_hold    : std_logic := '0';
   signal latched_vsync : STD_LOGIC := '0';
   signal latched_href  : STD_LOGIC := '0';
   signal latched_d     : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin
   addr <= address(18 downto 2);
   we <= we_reg;
   dout    <= d_latch(15 downto 12) & d_latch(10 downto 7) & d_latch(4 downto 1); 
   
capture_process: process(pclk)
   begin
      if rising_edge(pclk) then
         if we_reg = '1' then
            address <= std_logic_vector(unsigned(address)+1);
         end if;

         -- This is a bit tricky href starts a pixel transfer that takes 3 cycles
         --        Input   | state after clock tick   
         --         href   | wr_hold    d_latch           dout                we address  address_next
         -- cycle -1  x    |    xx      xxxxxxxxxxxxxxxx  xxxxxxxxxxxx  x   xxxx     xxxx
         -- cycle 0   1    |    x1      xxxxxxxxRRRRRGGG  xxxxxxxxxxxx  x   xxxx     addr
         -- cycle 1   0    |    10      RRRRRGGGGGGBBBBB  xxxxxxxxxxxx  x   addr     addr
         -- cycle 2   x    |    0x      GGGBBBBBxxxxxxxx  RRRRGGGGBBBB  1   addr     addr+1
         
         -- input:  5R,  6G,  5B
         -- output: 4R,  4G,  4B

         -- detect the rising edge on href - the start of the scan line
         if href_hold = '0' and latched_href = '1' then
            case line is
               when "00"   => line <= "01";
               when "01"   => line <= "10";
               when "10"   => line <= "11";
               when others => line <= "00";
            end case;
         end if;
         href_hold <= latched_href;
         
         -- capturing the data from the camera, 12-bit RGB
         if latched_href = '1' then
            d_latch <= d_latch( 7 downto 0) & latched_d; -- alte daten nach vorne schieben. Neue Daten hinten dranh�ngen
         end if;
         we_reg  <= '0';

         -- Is a new screen about to start (i.e. we have to restart capturing
         if latched_vsync = '1' then 
            address      <= (others => '0');
            href_last    <= (others => '0');
            line         <= (others => '0');
         else
            -- If not, set the write enable whenever we need to capture a pixel
            if (href_last(0) = '1') then
               we_reg <= '1';
               href_last <= (others => '0');
            else
               href_last <= href_last(href_last'high-1 downto 0) & latched_href;
            end if;
         end if;
      end if;
      if falling_edge(pclk) then
         latched_d     <= d;
         latched_href  <= href;
         latched_vsync <= vsync;
      end if;
   end process;
end Behavioral;
