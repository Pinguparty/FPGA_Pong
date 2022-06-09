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

        BALL_RADIUS : INTEGER := 10;
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
    SIGNAL paddleL_y : INTEGER RANGE 0 TO 480 := ((480/2) - (PADDLE_HEIGHT / 2));
    SIGNAL paddleR_y : INTEGER RANGE 0 TO 480 := ((480/2) - (PADDLE_HEIGHT / 2));

    SIGNAL ball_x : INTEGER RANGE 0 TO 640 := 640/2;
    SIGNAL ball_y : INTEGER RANGE 0 TO 480 := 480/2;
    SIGNAL ball_dx : INTEGER := 1;
    SIGNAL ball_dy : INTEGER := 1;

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

            IF (((x > ball_x - BALL_RADIUS) AND (y > ball_y - BALL_RADIUS) AND (x < ball_x + BALL_RADIUS) AND (y < ball_y + BALL_RADIUS))) THEN
                red_pong <= "1111";
                green_pong <= "1111";
                blue_pong <= "1111";
            END IF;

            IF (int_counter = GAME_SPEED) THEN
                IF (BTNL = '0' AND BTND = '0' AND BTNU = '0' AND BTNR = '0' AND BTNC = '0') THEN
                    int_counter <= 0;
                END IF;
                IF (BTNL = '1') THEN
                    paddleL_y <= paddleL_y - 1;
                    int_counter <= 0;
                END IF;
                IF (BTND = '1') THEN
                    paddleL_y <= paddleL_y + 1;
                    int_counter <= 0;
                END IF;
                IF (BTNU = '1') THEN
                    paddleR_y <= paddleR_y - 1;
                    int_counter <= 0;
                END IF;
                IF (BTNR = '1') THEN
                    paddleR_y <= paddleR_y + 1;
                    int_counter <= 0;
                END IF;

                --IF (BTNC = '1') THEN
                --    ball_dx <= 1;
                --    ball_dy <= -1;
                --END IF;
                
                -- Collision Detection. Noch sehr simplifiziert, da mir keine bessere bugfreie idee gekommen ist.
                -- Kollision wird nur auf der Ebene der inneren Paddelkante überprüft. Der Ball kann somit nicht von oben oder unten mit dem Paddel kollidieren.

                -- ELSIF hier benötigt, um die Test in Sequentiellem ablauf durchzugehen. Wir wollen den Ball entweder bewegen oder zurücksetzen.

                -- Abfrage ob Wand Links berühr wird
                IF (ball_x < BALL_RADIUS + PADDLE_WIDTH + PADDLE_WALL_DIST) THEN
                    -- Abfrage ob Wand an der Stelle des Paddels berührt wird
                    IF (ball_y > (paddleL_y + BALL_RADIUS) AND ball_y < (paddleL_y - BALL_RADIUS + PADDLE_HEIGHT)) THEN
                        ball_dx <= 1;
                        ball_x <= ball_x + ball_dx;
                        ball_y <= ball_y + ball_dy;
                    ELSE
                        ball_x <= 640/2;
                        ball_y <= 480/2;
                    END IF;

                -- Abfrage ob Wand Rechts berührt wird
                ELSIF (ball_x > (640 - BALL_RADIUS - PADDLE_WIDTH - PADDLE_WALL_DIST)) THEN
                    -- Abfrage ob Wand an der Stelle des Paddels berührt wird
                    IF (ball_y > (paddleR_y + BALL_RADIUS) AND ball_y < (paddleR_y - BALL_RADIUS + PADDLE_HEIGHT)) THEN
                        ball_dx <= - 1;
                        ball_x <= ball_x + ball_dx;
                        ball_y <= ball_y + ball_dy;
                    ELSE
                        ball_x <= 640/2;
                        ball_y <= 480/2;
                    END IF;
                ELSE
                    ball_x <= ball_x + ball_dx;
                    ball_y <= ball_y + ball_dy;
                END IF;

                -- Umdrehung der y Bewegung, wenn wir mit Boden oder Decke Kollidieren
                IF (ball_y < BALL_RADIUS) THEN
                    ball_dy <= 1;
                    ball_x <= ball_x + ball_dx;
                    ball_y <= ball_y + ball_dy;
                END IF;
                IF (ball_y > (480 - BALL_RADIUS - PADDLE_WIDTH - PADDLE_WALL_DIST)) THEN
                    ball_dy <= - 1;
                    ball_x <= ball_x + ball_dx;
                    ball_y <= ball_y + ball_dy;
                END IF;

            END IF;
        END IF;
    END PROCESS;
END Behavioral;