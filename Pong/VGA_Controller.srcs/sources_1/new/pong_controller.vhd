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
use ieee.std_logic_unsigned.all;

library pong;
use pong.pong_package.all;

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
        rgb_pong : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
        
        o_P1_Points : OUT std_logic_vector(1 downto 0);
        o_P2_Points : OUT  std_logic_vector(1 downto 0);
        
        o_Ball_x : OUT INTEGER;

        x : IN UNSIGNED(9 DOWNTO 0);
        y : IN UNSIGNED(9 DOWNTO 0);

        nreset : IN STD_LOGIC;
        clock : IN STD_LOGIC;
        sw1 : IN STD_LOGIC;
        
        player_input_i : IN STD_LOGIC_VECTOR(1 DOWNTO 0);

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
    
    SIGNAL color_P1 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL color_P2 : STD_LOGIC_VECTOR (11 DOWNTO 0);

    SIGNAL color_Ball : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL color_UI : STD_LOGIC_VECTOR (11 DOWNTO 0);
    
    SIGNAL p1_points : std_logic_vector(1 downto 0);
    SIGNAL p2_points : std_logic_vector(1 downto 0);
    
    SIGNAL p1_input_up : std_logic;
    SIGNAL p1_input_dn : std_logic;
    SIGNAL p2_input_up : std_logic;
    SIGNAL p2_input_dn : std_logic;   
    
    SIGNAL counter : STD_LOGIC_VECTOR (22 DOWNTO 0);
    SIGNAL counter_n : STD_LOGIC_VECTOR (22 DOWNTO 0);

    SIGNAL int_counter : INTEGER := 0;
    
   
   BEGIN
        p1_input_up <= player_input_i(0) or BTNL;
        p1_input_dn <= '1';
        p2_input_up <= player_input_i(1) or BTNR;
        p2_input_dn <= '1';
        
        Pong_Paddle_P1 : paddle_controller 
        GENERIC MAP(
            g_Player_Paddle_X => c_Paddle_P1_Location,
            g_Player_Paddle_Color => c_Paddle_P1_Color
        )
        PORT MAP(
            i_Clk => clock,
            i_x => x,
            i_y => y,
            i_Paddle_Up => p1_input_up,
            i_Paddle_Dn => p1_input_dn,
    
            o_Draw_Paddle => color_P1,
            o_Paddle_Y => paddleL_Y
        );
        Pong_Paddle_P2 : paddle_controller 
        GENERIC MAP(
            g_Player_Paddle_X => c_Paddle_P2_Location,
            g_Player_Paddle_Color => c_Paddle_P2_Color
        )
        PORT MAP(
            i_Clk => clock,
            i_x => x,
            i_y => y,
            i_Paddle_Up => p2_input_up,
            i_Paddle_Dn => p2_input_dn,
            o_Draw_Paddle => color_P2,
            o_Paddle_Y => paddleR_Y
        );
        
        Pong_Ball : ball_controller
        GENERIC MAP (
            g_Ball_Color => c_Ball_Color
        )
        PORT MAP (
            i_Clk => clock,
            i_x => x,
            i_y => y,
            i_Paddle_Left_Y => paddleL_y,
            i_Paddle_Right_Y => paddleR_y,
            i_Start_Button => BTNC,
            o_Draw_Ball => color_Ball,
            o_Ball_X => ball_x,
            o_Ball_Y => ball_y,
            o_P1_Points => p1_points,
            o_P2_Points => p2_points
        );
        UI : gamescreen_controller
        GENERIC MAP (
            g_Point_Color => c_Point_Color
        )
        PORT MAP (
            -- global clock 
            i_Clk => clock,
            --output of the color of the lives
            o_draw_Point => color_UI,
            -- the pixel coordinates at every given clock-cycle.
            i_x => x,
            i_y => y,
            --X coordinate of the Ball
            i_Ball_x => ball_x,
            -- switch only for tests, will delete later
            sw1 => sw1,
            -- Button to restart the game after someone loses
            i_Resetgame => BTNC,
            
            i_P1_lives => p1_points,
            i_P2_lives => p2_points
        );
    PROCESS (clock, nreset)
    BEGIN        
        rgb_pong(11 DOWNTO 8) <= color_P1(11 DOWNTO 8) or color_P2(11 DOWNTO 8) or color_Ball(11 DOWNTO 8) or color_UI(11 DOWNTO 8);
        rgb_pong(7 DOWNTO 4) <= color_P1(7 DOWNTO 4) or color_P2(7 DOWNTO 4) or color_Ball(7 DOWNTO 4) or color_UI(7 DOWNTO 4);
        rgb_pong(3 DOWNTO 0) <= color_P1(3 DOWNTO 0) or color_P2(3 DOWNTO 0) or color_Ball(3 DOWNTO 0) or color_UI(3 DOWNTO 0);
        o_P1_Points <= p1_points;
        o_P2_Points <= p2_points;
    END PROCESS;
END Behavioral;