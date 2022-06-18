library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

library pong;
use pong.pong_package.all;

entity ball_controller is
generic (
    -- The color of the Paddle. Gets set at instantiation.
    g_Ball_Color : std_logic_vector(11 downto 0)
);
port(
    -- global clock.
    i_Clk : in std_logic;

    -- the pixel coordinates at every given clock-cycle.
    i_x : in unsigned(9 downto 0);
    i_y : in unsigned(9 downto 0);
    
    -- the Y-Position of the paddles 0-point (= the upper left corner of the paddle)
    i_Paddle_Left_Y : in integer;
    i_Paddle_Right_Y : in integer;
    
    -- Gets bound to a button on the board that is used to start the game-round.
    i_Start_Button : in std_logic;
   
   -- Outputs the color of the ball or the background-color to the VGA-Controller, in order to draw the ball.
    o_Draw_Ball : out std_logic_vector(11 downto 0);
    
    -- Ouputs X and Y Position of the Center of the ball, which could be useful in the future.
    o_Ball_Y : out integer;
    o_Ball_X : out integer
    );


end ball_controller;

architecture Behavioral of ball_controller is
    -- Counts clock cycles in order to activate our code only after a given amount of cycles have passed, based on c_Game_Speed.
    SIGNAL clock_counter : INTEGER := 0;
    
    -- The position of the Ball is limited to a boundary with the size of Ball_Radius from the actuall board-edges.
    -- its initialized to be in the middle of the screen.
    SIGNAL ball_x : integer RANGE 0+c_Ball_Radius TO c_Board_Width-c_Ball_Radius := c_Board_Width /2;
    SIGNAL ball_y : integer RANGE 0+c_Ball_Radius TO c_Board_Height-c_Ball_Radius := c_Board_Height /2;
    
    -- Represents the difference to the next position.
    -- e.g. if ball_dx == -1 --> the ball moves 1px left; ball_dx == 0 --> the ball doesnt move; ball_dx == 1 --> the ball moves 1px right.
    SIGNAL ball_dx : integer RANGE -1 TO 1 := 0;
    SIGNAL ball_dy : integer RANGE -1 TO 1 := 0;
begin
    PROCESS(i_Clk)
    begin
        if(rising_edge(i_Clk)) then
            -- advance clock-counter.
            clock_counter <= clock_counter + 1;
            
            ---------------------
            --- Draw the Ball ---
            ---------------------
            -- initialise color output to background-color.
            o_Draw_Ball <= c_Board_BG_Color;
            -- If x and y are in range of the ball (= ball-position +- ball-radius, where bal position is the center of the ball)...
            IF (((i_x > (ball_x - c_Ball_Radius)) AND (i_y > ball_y - c_Ball_Radius) AND (i_x < ball_x + c_Ball_Radius) AND (i_y < ball_y + c_Ball_Radius))) THEN
                -- ...return the color of the ball to the output.
                o_Draw_Ball <= g_Ball_Color;
            END IF;
            
            ----------------
            --- Controls ---
            ----------------
            -- If the Start_Button (defined at instantiation of ball_controller in pong_controller) is pressed...
            IF(i_Start_Button = '1') THEN
                -- ..set the position of the ball to the center of the screen...
                ball_x <= c_Board_Width /2;
                ball_y <= c_Board_Height /2;
                -- and give it speed.
                ball_dx <= 1;
                ball_dy <= 1;
            END IF;
            
            -- if the clock-counter reaches the game_speed threshold...
            IF (clock_counter = c_Game_Speed) THEN
                -- ...reset it to 0...
                clock_counter <= 0;
                
                ----------------------------------------
                --- Calculate X-Position of the Ball ---
                ----------------------------------------
                -- if the ball is moving right...
                IF (ball_dx > 0) THEN
                    -- if it reaches the x-location of the right paddle..
                    IF(ball_x + 1 >= c_Paddle_P2_Location) THEN
                        -- .. and it is actually on the correct height...
                        IF (ball_y >= i_Paddle_Right_Y AND ball_y <= i_Paddle_Right_Y + c_Paddle_Height) THEN
                            -- ...make it bounce.
                            ball_dx <= -1;
                        END IF;
                    END IF;
                    -- otherwise
                    -- if the ball would run into the wall in the next frame... 
                    IF (ball_x + 1 >= (c_Board_Width - (c_Ball_Radius + 1))) THEN
                        -- let it stick to the wall by setting its speed to (0|0)
                        ball_dx <= 0;
                        ball_dy <= 0;
                    END IF;
                    -- advance the ball one pixel to the right.
                    ball_x <= ball_x +1;
                -- if the ball is moving left...
                ELSIF(ball_dx < 0) THEN
                    -- if it reaches the x-location of the left paddle...
                    IF(ball_x - 1 <= c_Paddle_P1_Location + c_Paddle_Width) THEN
                        -- .. and it is actually on the correct height...
                        IF (ball_y >= i_Paddle_Left_Y AND ball_y <= i_Paddle_Left_Y + c_Paddle_Height) THEN
                            -- ..make it bounce.
                            ball_dx <= 1;
                        END IF;
                    END IF;
                    -- if the ball would run into the wall in the next frame... 
                    IF (ball_x - 1 <= c_Ball_Radius + 1) THEN
                        -- let it stick to the wall by setting its speed to (0|0)
                        ball_dx <= 0;
                        ball_dy <= 0;
                    END IF;
                    -- advance the ball one pixel to the left.
                    ball_x <= ball_x -1;
                END IF;
                
                ----------------------------------------
                --- Calculate Y-Position of the Ball ---
                ----------------------------------------
                -- if the ball is moving down...
                IF (ball_dy > 0) THEN
                    -- if the ball would hit the floor at the next tick...
                    IF (ball_y >= (c_Board_Height - c_Ball_Radius)) THEN
                        -- ...let it move up instead.
                        ball_dy <= -1;
                    END IF;    
                    -- otherwise advance the ball one pixel down.             
                    ball_y <= ball_y +1;
                -- if the ball is moving up...
                ELSIF(ball_dy < 0) THEN
                    -- if the ball would hit the ceiling at the next tick...
                    IF (ball_y <= (c_Ball_Radius + 1)) THEN
                        -- ..let it move down instead.
                        ball_dy <= 1;
                    END IF;
                    -- otherwise advance the ball one pixel up.
                    ball_y <= ball_y -1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
end Behavioral;
