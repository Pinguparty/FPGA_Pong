----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2022 19:31:08
-- Design Name: 
-- Module Name: beispiel_controller - Behavioral
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

ENTITY beispiel_controller IS
    PORT (
        red_bsp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        green_bsp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        blue_bsp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

        x : IN UNSIGNED(9 DOWNTO 0);
        y : IN UNSIGNED(9 DOWNTO 0);

        nreset : IN STD_LOGIC;
        clock : IN STD_LOGIC;
        sw1 : IN STD_LOGIC
    );
END beispiel_controller;

ARCHITECTURE Behavioral OF beispiel_controller IS
    SIGNAL counter : STD_LOGIC_VECTOR (32 DOWNTO 0);
    SIGNAL counter_n : STD_LOGIC_VECTOR (32 DOWNTO 0);

BEGIN

    PROCESS (clock, nreset)
    BEGIN
        IF (rising_edge(clock)) THEN
            IF (sw1 = '0') THEN
                red_bsp <= STD_LOGIC_VECTOR(x(7 DOWNTO 4));
                green_bsp <= counter(26 DOWNTO 23);
                blue_bsp <= STD_LOGIC_VECTOR(y(7 DOWNTO 4));
            ELSE -- :)
                red_bsp <= "0000";
                green_bsp <= "0000";
                blue_bsp <= "0000";
                IF (((x > 100) AND (y > 50) AND (x < 150) AND (y < 100)) OR
                    ((x > 250) AND (y > 50) AND (x < 300) AND (y < 100))) THEN
                    red_bsp <= "1111";
                    green_bsp <= "1111";
                    blue_bsp <= "1111";
                END IF;
                IF (((x > 25) AND (y > 125) AND (x < 75) AND (y < 175)) OR
                    ((x > 75) AND (y > 175) AND (x < 325) AND (y < 225)) OR
                    ((x > 325) AND (y > 125) AND (x < 375) AND (y < 175))) THEN
                    red_bsp <= "1111";
                    green_bsp <= "1111";
                    blue_bsp <= "1111";
                END IF;
            END IF;
            counter <= counter_n;

        END IF;
    END PROCESS;

    -- Next-state logic
    counter_n <= STD_LOGIC_VECTOR(unsigned(counter) + 1);
END Behavioral;