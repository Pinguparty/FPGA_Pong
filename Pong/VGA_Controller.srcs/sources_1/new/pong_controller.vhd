----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.06.2022 22:36:09
-- Design Name: 
-- Module Name: pong_controller - Behavioral
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
ENTITY pong_controller IS
    GENERIC (
        PADDLE_HEIGHT : INTEGER := 100;
        PADDLE_WIDTH : INTEGER := 20;
        PADDLE_SPEED : INTEGER := 1;
        PADDLE_WALL_DIST : INTEGER := 5;
        GAME_SPEED : INTEGER := 100000 --Ticks between updates ==> lower is faster
    );
    PORT (
        red_pong : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        green_pong : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        blue_pong : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

        x : IN UNSIGNED(9 DOWNTO 0);
        y : IN UNSIGNED(9 DOWNTO 0);

        nreset : IN STD_LOGIC;
        clock : IN STD_LOGIC;
        sw1 : IN STD_LOGIC;
        
        BTNC : IN STD_LOGIC;
        BTNU : IN STD_LOGIC;
        BTNL : IN STD_LOGIC;
        BTNR : IN STD_LOGIC;
        BTND : IN STD_LOGIC
    );
END pong_controller;

ARCHITECTURE Behavioral OF pong_controller IS
    SIGNAL paddleL_y : INTEGER RANGE 0 TO 512 := ((480/2) - (PADDLE_HEIGHT / 2));
    SIGNAL paddleR_y : INTEGER RANGE 0 TO 512 := ((480/2) - (PADDLE_HEIGHT / 2));

    SIGNAL counter : STD_LOGIC_VECTOR (22 DOWNTO 0);
    SIGNAL counter_n : STD_LOGIC_VECTOR (22 DOWNTO 0);

    SIGNAL int_counter : INTEGER := 0;
BEGIN

    PROCESS (clock, nreset)
    BEGIN
        IF (rising_edge(clock)) THEN
            int_counter <= int_counter + 1;

            -- creating the paddles
            red_pong <= "0000";
            green_pong <= "0000";
            blue_pong <= "0000";
            IF (((x > PADDLE_WALL_DIST) AND (y > paddleL_y) AND (x < PADDLE_WALL_DIST + PADDLE_WIDTH) AND (y < paddleL_y + PADDLE_HEIGHT))) THEN
                red_pong <= "1111";
            END IF;
            IF (((x > 640 - (PADDLE_WALL_DIST + PADDLE_WIDTH)) AND (y > paddleR_y) AND (x < 640 - PADDLE_WALL_DIST) AND (y < paddleR_y + PADDLE_HEIGHT))) THEN
                blue_pong <= "1111";
            END IF;

            --IF (counter(22) = '1') THEN
            --    paddleL_y <= paddleL_y + 1;
            --END IF;

            IF (int_counter = GAME_SPEED AND BTNL = '0' AND BTND = '0' AND BTNU = '0' AND BTNR = '0') THEN
                int_counter <= 0;
            END IF;
            IF (int_counter = GAME_SPEED AND BTNL = '1') THEN
                paddleL_y <= paddleL_y - 1;
                int_counter <= 0;
            END IF;
            IF (int_counter = GAME_SPEED AND BTND = '1') THEN
                paddleL_y <= paddleL_y + 1;
                int_counter <= 0;
            END IF;
            IF (int_counter = GAME_SPEED AND BTNU = '1') THEN
                paddleR_y <= paddleR_y - 1;
                int_counter <= 0;
            END IF;
            IF (int_counter = GAME_SPEED AND BTNR = '1') THEN
                paddleR_y <= paddleR_y + 1;
                int_counter <= 0;
            END IF;
            counter <= counter_n;
        END IF;
    END PROCESS;

    -- Next-state logic
    counter_n <= STD_LOGIC_VECTOR(unsigned(counter) + 1);
END Behavioral;