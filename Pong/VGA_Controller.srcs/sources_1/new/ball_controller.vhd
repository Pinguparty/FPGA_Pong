---- Ich habe es versucht bin mir aber nicht sicher ob es richtig ist
---- ball_controller 
---- | | | | | | | |
---- | | | | | | | |
---- v v v v v v v v
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--USE IEEE.NUMERIC_STD.ALL;

--library pong;
--use pong.pong_package.all;


--entity ball_controller is
--generic (
--    g_Ball_X: integer;
--    g_Ball_Y: integer;
--    g_Ball_Color: std_logic_vector(11 downto 0)
--);

--port(
--    i_Clk : in std_logic;
    
--    i_x: in unsigned(9 downto 0);
--    i_y: in unsigned(9 downto 0);
    
--    i_Game_Active : in std_logic;
    
--    o_Draw_Ball : out std_logic_vector(11 downto 0);
--    o_Ball_Y : out integer;
--    o_Ball_X : out integer;
--    o_ball_dx : out INTEGER := 1;
--    o_ball_dy : out INTEGER := 1
--    );
    
--end ball_controller;

--architecture Behavioral of ball_controller is
--    SIGNAL int_counter : INTEGER := 0;
--    SIGNAL ball_Y : integer RANGE 0 TO c_Board_Height := (c_Board_Height/2);
--    SIGNAL ball_X : integer RANGE 0 TO c_Board_Width  := (c_Board_Width/2);
--begin
--    PROCESS(i_Clk)
--    begin
--        IF(rising_edge(i_Clk)) THEN 
        
--            int_counter <= int_counter +1;
--            o_Draw_Ball <= c_Board_BG_Color;
        
--            IF((( i_x > g_Ball_X - c_Ball_Radius) AND ( i_y > g_Ball_Y - c_Ball_Radius) AND ( i_x <  g_Ball_X + c_Ball_Radius) AND ( i_y < g_Ball_Y + c_Ball_Radius))) THEN
--                o_Draw_Ball <= g_Ball_Color;
--            END IF;
                
--            IF( i_Game_Active = '1') THEN
--                o_ball_dx <= 1;
--                o_ball_dy <= -1;
--            END IF;
                    
--            IF ( o_Ball_X < c_Ball_Radius + c_Paddle_Width + c_Paddle_Wall_Dist) THEN
--                IF ( o_Ball_Y > ( c_Paddle_P1_Location + c_Ball_Radius) AND o_Ball_Y < ( c_Paddle_P1_Location - c_Ball_Radius + c_Paddle_Height)) THEN
--                    o_ball_dx <= 1;
--                    o_Ball_X <= o_Ball_X + o_ball_dx;
--                    o_Ball_Y <= o_Ball_Y + o_ball_dy;
--                ELSE 
--                    o_Ball_X <= 640/2;
--                    o_Ball_Y <= 480/2;
--                END IF;
                
--            ELSE IF (  o_Ball_X > ( c_Board_Width - c_Ball_Radius - c_Paddle_Width - c_Paddle_Wall_Dist)) THEN 
--                IF( o_Ball_Y > ( c_Paddle_P2_Location + c_Ball_Radius) AND o_Ball_Y < ( c_Paddle_P2_Location - c_Ball_Radius + c_Paddle_Height)) THEN
--                    o_ball_dx <= -1;
--                    o_Ball_X <= o_Ball_X + o_ball_dx;
--                    o_Ball_Y <= o_Ball_Y + o_ball_dy;
--                ELSE 
--                    o_Ball_X <= 640/2;
--                    o_Ball_Y <= 480/2;
--                END IF;
--            ELSE 
--                o_Ball_X <= o_Ball_X + o_ball_dx;
--                o_Ball_Y <= o_Ball_Y + o_ball_dy;
--            END IF;
            

--            IF( o_Ball_Y < c_Ball_Radius) THEN 
--                o_ball_dy <= 1;
--                o_Ball_X <= o_Ball_X + o_ball_dx;
--                o_Ball_Y <= o_Ball_Y + o_ball_dy;
--            END IF;
                    
--            IF ( o_Ball_Y > ( c_Board_Height - c_Ball_Radius - c_Board_Width - c_Paddle_Wall_Dist)) THEN
--                o_ball_dy <= -1;
--                o_Ball_X <= o_Ball_X + o_ball_dx;
--                o_Ball_Y <= o_Ball_Y + o_ball_dy;
--            END IF;
                    
--        END IF;
--    END IF;
--    END PROCESS;
--END Behavioral;                    





--- Syntax Error File als Notiz


--IF (((x > ball_x - BALL_RADIUS) AND (y > ball_y - BALL_RADIUS) AND (x < ball_x + BALL_RADIUS) AND (y < ball_y + BALL_RADIUS))) THEN
--                red_pong <= "1111";
--                green_pong <= "1111";
--                blue_pong <= "1111";
--            END IF;

--                --IF (BTNC = '1') THEN
--                --    ball_dx <= 1;
--                --    ball_dy <= -1;
--                --END IF;
                
--                -- Collision Detection. Noch sehr simplifiziert, da mir keine bessere bugfreie idee gekommen ist.
--                -- Kollision wird nur auf der Ebene der inneren Paddelkante überprüft. Der Ball kann somit nicht von oben oder unten mit dem Paddel kollidieren.

--                -- ELSIF hier benötigt, um die Test in Sequentiellem ablauf durchzugehen. Wir wollen den Ball entweder bewegen oder zurücksetzen.

--                -- Abfrage ob Wand Links berühr wird
--                IF (ball_x < BALL_RADIUS + PADDLE_WIDTH + PADDLE_WALL_DIST) THEN
--                    -- Abfrage ob Wand an der Stelle des Paddels berührt wird
--                    IF (ball_y > (paddleL_y + BALL_RADIUS) AND ball_y < (paddleL_y - BALL_RADIUS + PADDLE_HEIGHT)) THEN
--                        ball_dx <= 1;
--                        ball_x <= ball_x + ball_dx;
--                        ball_y <= ball_y + ball_dy;
--                    ELSE
--                        ball_x <= 640/2;
--                        ball_y <= 480/2;
--                    END IF;

--                -- Abfrage ob Wand Rechts berührt wird
--                ELSIF (ball_x > (640 - BALL_RADIUS - PADDLE_WIDTH - PADDLE_WALL_DIST)) THEN
--                    -- Abfrage ob Wand an der Stelle des Paddels berührt wird
--                    IF (ball_y > (paddleR_y + BALL_RADIUS) AND ball_y < (paddleR_y - BALL_RADIUS + PADDLE_HEIGHT)) THEN
--                        ball_dx <= - 1;
--                        ball_x <= ball_x + ball_dx;
--                        ball_y <= ball_y + ball_dy;
--                    ELSE
--                        ball_x <= 640/2;
--                        ball_y <= 480/2;
--                    END IF;
--                ELSE
--                    ball_x <= ball_x + ball_dx;
--                    ball_y <= ball_y + ball_dy;
--                END IF;

--                -- Umdrehung der y Bewegung, wenn wir mit Boden oder Decke Kollidieren
--                IF (ball_y < BALL_RADIUS) THEN
--                    ball_dy <= 1;
--                    ball_x <= ball_x + ball_dx;
--                    ball_y <= ball_y + ball_dy;
--                END IF;
--                IF (ball_y > (480 - BALL_RADIUS - PADDLE_WIDTH - PADDLE_WALL_DIST)) THEN
--                    ball_dy <= - 1;
--                    ball_x <= ball_x + ball_dx;
--                    ball_y <= ball_y + ball_dy;
--                END IF;

--            END IF;
--        END IF;
