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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY vga_controller IS
    PORT (
        x_out : OUT UNSIGNED(9 DOWNTO 0);
        y_out : OUT UNSIGNED(9 DOWNTO 0);

        VGA_HS_O : OUT STD_LOGIC;
        VGA_VS_O : OUT STD_LOGIC;
        VGA_RED_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_GREEN_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_BLUE_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        
        rgb_pong : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
        rgb_ov7670 : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
        active_ov7670_i : IN STD_LOGIC;
        
        active_o : OUT STD_LOGIC;

        Clock_VGA : IN STD_LOGIC;
        n_reset : IN STD_LOGIC
    );

END vga_controller;

ARCHITECTURE Behavioral OF vga_controller IS
    SIGNAL Pixel_Counter : INTEGER := 0;
    SIGNAL Line_Counter : INTEGER := 0;
    SIGNAL x : INTEGER := 0;
    SIGNAL y : INTEGER := 0;
    SIGNAL active : STD_LOGIC;

BEGIN
    active_o <= active;
    x_out <= to_unsigned(x, x_out'length);
    y_out <= to_unsigned(y, y_out'length);

    -- Erzeugen der Pixel- und Line-Counter sowie active signal
    PROCESS (Clock_VGA)
    BEGIN
        IF (rising_edge(Clock_VGA)) THEN
            Pixel_Counter <= Pixel_Counter + 1;

            IF (Pixel_Counter = 799) THEN
                Pixel_Counter <= 0;
                Line_Counter <= Line_Counter + 1;
            END IF;
            IF (Line_Counter = 525) THEN
                Line_Counter <= 0;
            END IF;
            IF (Pixel_Counter = 703) THEN
                VGA_HS_O <= '0';
            END IF;
            IF (Pixel_Counter = 791) THEN
                VGA_HS_O <= '1';
            END IF;
            IF (Line_Counter = 523) THEN
                VGA_VS_O <= '0';
            END IF;
            IF (Line_Counter = 525) THEN
                VGA_VS_O <= '1';
            END IF;

            IF ((Pixel_Counter > 47) AND (Pixel_Counter < 688) AND
                (Line_Counter > 32) AND (Line_Counter < 513)) THEN
                active <= '1';
            ELSE
                active <= '0';
            END IF;
        END IF;
    END PROCESS;

    -- x Pixel signal erzeugen
    PROCESS (Clock_VGA)
    BEGIN
        IF (rising_edge(Clock_VGA)) THEN
            IF ((Pixel_Counter > 47) AND (Pixel_Counter < 688)) THEN
                x <= x + 1;
            ELSIF (Pixel_Counter = 47) THEN
                x <= 0;
            END IF;
        END IF;
    END PROCESS;

    -- y Pixel signal erzeugen
    PROCESS (Clock_VGA)
    BEGIN
        IF rising_edge(Clock_VGA) THEN
            IF (Pixel_Counter = 799) THEN
                IF ((Line_Counter > 32) AND (Line_Counter < 513)) THEN
                    y <= y + 1;
                ELSIF (Line_Counter = 32) THEN
                    y <= 0;
                END IF;
            END IF;
        END IF;
    END PROCESS;

    -- RGB Muxing
    PROCESS (Clock_VGA)
    BEGIN
        IF rising_edge(Clock_VGA) THEN
            IF (active = '1' and active_ov7670_i = '1') THEN
                -- Auswahl des RGB Inputs hier treffen
                VGA_RED_O <= rgb_ov7670(11 DOWNTO 8);
                VGA_GREEN_O <= rgb_ov7670(7 DOWNTO 4);
                VGA_BLUE_O <= rgb_ov7670(3 DOWNTO 0);
                
            ELSIF (active = '1' and active_ov7670_i = '0') THEN
                VGA_RED_O <= rgb_pong(11 DOWNTO 8);
                VGA_GREEN_O <= rgb_pong(7 DOWNTO 4);
                VGA_BLUE_O <= rgb_pong(3 DOWNTO 0);
            ELSE
                VGA_RED_O <= "0000";
                VGA_GREEN_O <= "0000";
                VGA_BLUE_O <= "0000";
            END IF;
        END IF;
    END PROCESS;
END Behavioral;