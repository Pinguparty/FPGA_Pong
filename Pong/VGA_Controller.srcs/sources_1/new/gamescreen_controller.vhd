----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/19/2022 05:11:14 PM
-- Design Name: 
-- Module Name: gamescreen_controller - Behavioral
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
use ieee.std_logic_unsigned.all;

library pong;
use pong.pong_package.all;

entity gamescreen_controller is
generic(
        -- color of the lives
        g_Point_Color : std_logic_vector(11 downto 0)
        );
PORT(
    -- global clock 
    i_Clk : in std_logic;
    --output of the color of the lives
    o_draw_Point : out std_logic_vector(11 downto 0);
    -- the pixel coordinates at every given clock-cycle.
    i_x: in unsigned(9 downto 0);
    i_y: in unsigned(9 downto 0);
    --X coordinate of the Ball
    i_Ball_x : in INTEGER;
    -- switch only for tests, will delete later
    sw1 : IN STD_LOGIC;
    -- Button to restart the game after someone loses
    i_Resetgame : in std_logic
    );
        
end gamescreen_controller;

architecture Behavioral of gamescreen_controller is

    SIGNAL clock_counter : INTEGER := 0;
    --lives of the players
    SIGNAL P1_lives : unsigned(1 downto 0) := "00";
    SIGNAL P2_lives : unsigned(1 downto 0) := "00";

begin
    process(i_Clk)
    begin
        if(rising_edge(i_Clk)) then
                -- advance clock-counter.                        
                clock_counter <= clock_counter + 1;
                -- draw lives to the bg color
                o_draw_Point <= c_Board_BG_Color;
                
                IF sw1 = '1'   then
                P2_lives <= "11";
                End if;
                
                -- if someone won and button is pressed, reset lives
                IF ( i_Resetgame = '1' AND ( P1_lives = "11" OR P2_lives = "11" ) ) THEN
                    P1_lives <= "00";
                    P2_lives <= "00";  
                END IF;   
 
 
----------------------------------------------------------------------------------------
----------------WINNING SCREENS---------------------------------------------------------                

                IF ( (( P1_lives = "11") OR (P2_lives = "11")) AND
                   ( (( i_x > 150) AND (i_y > 150) AND (i_x < 250) AND (i_y < 250)) OR --PLAYER COLORED SQUARE
                     (( i_x > 150) AND (i_y > 280) AND (i_x < 170) AND (i_y < 360)) OR -- W
                     (( i_x > 170) AND (i_y > 360) AND (i_x < 190) AND (i_y < 380)) OR -- W
                     (( i_x > 190) AND (i_y > 320) AND (i_x < 210) AND (i_y < 360)) OR -- W
                     (( i_x > 210) AND (i_y > 360) AND (i_x < 230) AND (i_y < 380)) OR -- W
                     (( i_x > 230) AND (i_y > 280) AND (i_x < 250) AND (i_y < 360)) OR -- W
                     (( i_x > 270) AND (i_y > 280) AND (i_x < 290) AND (i_y < 380)) OR -- I
                     (( i_x > 310) AND (i_y > 280) AND (i_x < 330) AND (i_y < 380)) OR -- N 
                     (( i_x > 330) AND (i_y > 300) AND (i_x < 350) AND (i_y < 320)) OR -- N 
                     (( i_x > 350) AND (i_y > 320) AND (i_x < 370) AND (i_y < 340)) OR -- N 
                     (( i_x > 370) AND (i_y > 280) AND (i_x < 390) AND (i_y < 380)) OR -- N 
                     (( i_x > 410) AND (i_y > 280) AND (i_x < 470) AND (i_y < 300)) OR -- S 
                     (( i_x > 410) AND (i_y > 300) AND (i_x < 430) AND (i_y < 320)) OR -- S 
                     (( i_x > 410) AND (i_y > 320) AND (i_x < 470) AND (i_y < 340)) OR -- S 
                     (( i_x > 450) AND (i_y > 340) AND (i_x < 470) AND (i_y < 360)) OR -- S
                     (( i_x > 410) AND (i_y > 360) AND (i_x < 470) AND (i_y < 380)) )) THEN  --S
                    -- IF P2 WINS                   
                    IF P1_lives = "11" THEN o_draw_Point <= c_Paddle_P2_Color;
                    -- IF P1 WINS 
                    ELSIF P2_lives = "11" THEN o_draw_Point <= c_Paddle_P1_Color;     
                    END IF;  
                END IF; 
----------------------------------------------------------------------------------------
---------- ALL CASES FOR REMAINING LIVES------------------------------------------------             
                 
                 -- P1 with 3 lives 
                 IF  ( (P1_lives = "00") AND
                      ((( i_x > 10) AND (i_y > 5) AND (i_x < 15) AND (i_y < 10)) OR     -- 1st life
                      (( i_x > 20) AND (i_y > 5) AND (i_x < 25) AND (i_y < 10)) OR     -- 2nd life
                      (( i_x > 30) AND (i_y > 5) AND (i_x < 35) AND (i_y < 10)))) THEN  -- 3rd life
                    o_draw_Point <= c_Paddle_P1_Color;
                END IF;
                -- P1 with 2 lives 
                IF  ( (P1_lives = "01") AND
                      ((( i_x > 10) AND (i_y > 5) AND (i_x < 15) AND (i_y < 10)) OR     -- 1st life
                      (( i_x > 20) AND (i_y > 5) AND (i_x < 25) AND (i_y < 10)) )) THEN  -- 2nd life
                    o_draw_Point <= c_Paddle_P1_Color;
                END IF;
                -- P1 with 1 life
                IF  ( (P1_lives = "10") AND
                     ((( i_x > 10) AND (i_y > 5) AND (i_x < 15) AND (i_y < 10)) )) THEN  -- 1st life
                    o_draw_Point <= c_Paddle_P1_Color;
                END IF;                                                        
                -- P2 with 3 lives                         
                IF  ( (P2_lives = "00") AND
                     ((( i_x > 625) AND (i_y > 5) AND (i_x < 630) AND (i_y < 10)) OR     -- 1st life
                      (( i_x > 615) AND (i_y > 5) AND (i_x < 620) AND (i_y < 10)) OR     -- 2nd life
                      (( i_x > 605) AND (i_y > 5) AND (i_x < 610) AND (i_y < 10)))) THEN  -- 3rd life
                    o_draw_Point <= c_Paddle_P2_Color;
                END IF;                              
                -- P2 with 2 lives                         
                IF  ( (P2_lives = "01") AND
                     ((( i_x > 625) AND (i_y > 5) AND (i_x < 630) AND (i_y < 10)) OR     -- 1st life
                      (( i_x > 615) AND (i_y > 5) AND (i_x < 620) AND (i_y < 10)) )) THEN  -- 2nd life
                    o_draw_Point <= c_Paddle_P2_Color;
                END IF; 
                -- P2 with 1 life                         
                IF  ( (P2_lives = "10") AND
                     ((( i_x > 625) AND (i_y > 5) AND (i_x < 630) AND (i_y < 10)) )) THEN  -- 1st life
                    o_draw_Point <= c_Paddle_P2_Color;
                END IF;    
                
---------------------------------------------------------------------------------------------
                
                -- if the clock-counter reaches the game_speed threshold       
                IF (clock_counter = c_Game_Speed) THEN
                -- reset it to 0
                    clock_counter <= 0;
                 -- if ball hits left walll             
                    IF (i_ball_x - 1 <= c_Ball_Radius + 1) THEN
                        P1_lives <= P1_lives + 1;
                -- if ball hits right wall        
                    ELSIF (i_ball_x + 1 >= (c_Board_Width - (c_Ball_Radius + 1))) THEN
                        P2_lives <= P2_lives + 1;    
                    END IF;                  
                END IF;    
        end if;        
    end process;
end Behavioral;
