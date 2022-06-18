----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.06.2022 11:42:43
-- Design Name: 
-- Module Name: paddle_controller - Behavioral
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

library pong;
use pong.pong_package.all;

entity paddle_controller is
generic (
    -- the generics are used to differentiate the 2 Paddles ingame by position and color.

    -- The X-Location of the Paddle (this value always refers to the left edge) gets set at instantiation.
    g_Player_Paddle_X : integer;
    -- The color of the Paddle. Gets set at instantiation.
    g_Player_Paddle_Color : std_logic_vector(11 downto 0)
);
port(
    -- global clock
    i_Clk : in std_logic;

    -- the pixel coordinates at every given clock-cycle.
    i_x : in unsigned(9 downto 0);
    i_y : in unsigned(9 downto 0);

    -- inputs for the paddle-controls.
    i_Paddle_Up : in std_logic;
    i_Paddle_Dn : in std_logic;
   
   -- Outputs the color of the paddle (or the background-color) to the VGA-Controller, in order to draw the paddle.
    o_Draw_Paddle : out std_logic_vector(11 downto 0);
    -- Output of the Paddles Y-Position. Used by the ball_controller to handle collions.
    o_Paddle_Y    : out integer
    );


end paddle_controller;

architecture Behavioral of paddle_controller is
    -- Counts clock cycles in order to activate our code only after a given amount of cycles have passed, based on c_Game_Speed.
    SIGNAL clock_counter : INTEGER := 0;
    -- The Y-Position of the Paddle, is exactly the upper-left corner.
    SIGNAL paddle_Y : integer RANGE 0 TO c_Board_Height-c_Paddle_Height := (c_Board_Height /2 ) - (c_Paddle_Height / 2);
begin
    PROCESS(i_Clk)
    begin
        if(rising_edge(i_Clk)) then
            -- advance clock counter
            clock_counter <= clock_counter + 1;
            
            -----------------------
            --- Draw the Paddle ---
            -----------------------
            -- initialise color output to background-color
            o_Draw_Paddle <= c_Board_BG_Color;
            IF (((i_x > g_Player_Paddle_X) AND (i_y > paddle_Y) AND (i_x < g_Player_Paddle_X + c_Paddle_Width) AND (i_y < paddle_Y + c_Paddle_Height))) THEN
                o_Draw_Paddle <= g_Player_Paddle_Color;
            END IF;
            
            -- if the clock-counter reaches the game_speed threshold...
            IF (clock_counter = c_Game_Speed) THEN
                -- ...reset it to 0...
                clock_counter <= 0;
                ----------------
                --- Controls ---
                ----------------
                -- If Up-Button is pressed and the paddle is not already at the top..
                -- BUGGY: aus irgendeinem Grund, kann man die maximale Top-Position auf keinen sensiblen Wert stellen, nur halb in der mitte vom screen geht...
                IF (i_Paddle_Up = '1' AND paddle_Y > 0) THEN
                    -- ...move it one pixel up.
                    paddle_Y <= paddle_Y - 1;
                END IF;
                -- If Down-Button is pressed and the paddle is not already at the bottom..
                IF (i_Paddle_Dn = '1' AND paddle_Y + c_Paddle_Height < c_Board_Height) THEN
                    -- .. move it one pixel down.
                    paddle_Y <= paddle_Y + 1;
                END IF;
            END IF;
            -- set the value of the output, in order to be able to use the paddles position in other components.
            o_Paddle_Y <= paddle_Y;
        END IF;
    END PROCESS;
end Behavioral;
