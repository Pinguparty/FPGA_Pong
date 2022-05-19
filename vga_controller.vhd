----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.05.2022 16:55:35
-- Design Name: 
-- Module Name: vga_controller - Behavioral
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


entity vga_controller is
Port (  HSync       : out STD_LOGIC := '1';         -- Ausgang fr das H-Sync Signal
        VSync       : out STD_LOGIC := '1';         -- Ausgang fr das V-Sync Signal
        Clock_VGA   : in STD_LOGIC;                 -- Takteingang fr Sync-Logic (z.B. 25.175MHz)                     
        n_reset      : in STD_LOGIC;                 -- Reset fr Sync-Logik                   
        x_out       : out UNSIGNED(9 downto 0);     -- Counter fr die sichtbaren Pixel in x-Richtung              
        y_out       : out UNSIGNED(9 downto 0)      -- Counter fr die sichtbaren Pixel in y-Richtung
        );

end vga_controller;

architecture Behavioral of vga_controller is
    

    signal Pixel_Counter : INTEGER := 0;
    signal Line_Counter : INTEGER := 0;
    signal x : INTEGER := 0;
    signal y : INTEGER := 0;
    
    
begin
    process(Clock_VGA)
        begin
            if(rising_edge(Clock_VGA)) then
                if(n_reset = '1') then
                    HSync <= '1';
                    VSync <= '1';
                    Pixel_Counter <= 0;
                    Line_Counter <= 0;
            else
                Pixel_Counter <= Pixel_Counter + 1;
                if(Pixel_Counter = 799) then
                    Pixel_Counter <= 0;
                    Line_Counter <= Line_Counter + 1;
                end if;   
                if(Line_Counter = 525) then
                    Line_Counter <= 0; 
                 end if;        
                if(Pixel_Counter = 703) then
                    HSync <= '0';
                end if; 
                if(Pixel_Counter = 791) then 
                    HSync <= '1'; 
                end if;
                if(Line_Counter = 523) then
                    VSync <= '0';
                end if;
                if(Line_Counter = 525) then 
                    VSync <= '1'; 
                end if;                
            end if;
        end if;
    end process;

    process(Clock_VGA)
    begin
        if(rising_edge(Clock_VGA)) then
            if((Pixel_Counter > 47) and (Pixel_Counter < 688)) then    
                x <= x + 1;  
            elsif (Pixel_Counter = 47) then
                x <= 0;
            end if;
        end if;        
    end process;
    
    process(Clock_VGA)
    begin
        if rising_edge(Clock_VGA) then
            if(Pixel_Counter = 799) then
                if((Line_Counter > 32) and (Line_Counter < 513))  then    
                    y <= y + 1; 
                elsif(Line_Counter = 32) then
                    y <= 0;
                end if;
            end if;
        end if;        
    end process;
end Behavioral;
