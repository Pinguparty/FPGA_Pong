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
    
    COMPONENT paddle_controller
        generic (
            g_Player_Paddle_X : integer
        );
        PORT(
            i_Clk : in std_logic;

            i_x : in unsigned(9 downto 0);
            i_y : in unsigned(9 downto 0);

            -- Player Paddle Control
            i_Paddle_Up : in std_logic;
            i_Paddle_Dn : in std_logic;

            o_Draw_Paddle : out std_logic_vector(11 downto 0);
            o_Paddle_Y    : out integer
        );
    END COMPONENT paddle_controller;
    BEGIN
        Pong_Paddle_P1 : paddle_controller 
        GENERIC MAP(
            g_Player_Paddle_X => c_Paddle_Wall_Dist
        )
        PORT MAP(
            i_Clk => clock,
            i_x => x,
            i_y => y,
            i_Paddle_Up => BTNL,
            i_Paddle_Dn => BTND
        );
        Pong_Paddle_P2 : paddle_controller 
        GENERIC MAP(
            g_Player_Paddle_X => ((c_Screen_Width - c_Paddle_Wall_Dist) - c_Paddle_Width)
        )
        PORT MAP(
            i_Clk => clock,
            i_x => x,
            i_y => y,
            i_Paddle_Up => BTNU,
            i_Paddle_Dn => BTNR
        );
    PROCESS (clock, nreset)
    BEGIN
    END PROCESS;
END Behavioral;