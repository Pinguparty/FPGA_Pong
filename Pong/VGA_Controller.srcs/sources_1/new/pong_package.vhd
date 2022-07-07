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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package pong_package is
-----------------
--- Constants ---
-----------------

--- Screen and Gameboard Sizes (the Screen includes the black porches and the Gameboard)
constant c_Board_Height : integer := 480;
constant c_Board_Width : integer := 640;
constant c_Board_BG_Color : std_logic_vector(11 downto 0) := "000000000000";
constant c_Screen_Height : integer := 525;
constant c_Screen_Width : integer := 800;
constant c_Game_Speed : INTEGER := 200000; --Ticks between updates ==> lower is faster

-- Paddle
constant c_Paddle_Height : integer := 100;
constant c_Paddle_Width : integer := 20;
constant c_Paddle_Speed : integer := 1;
constant c_Paddle_Wall_Dist : integer := 5;
constant c_Paddle_P1_Location : integer := 0 + c_Paddle_Wall_Dist;
constant c_Paddle_P2_Location : integer := ((c_Board_Width - c_Paddle_Wall_Dist) - c_Paddle_Width);
constant c_Paddle_P1_Color : std_logic_vector(11 downto 0) := "111100000000";
constant c_Paddle_P2_Color : std_logic_vector(11 downto 0) := "000000001111";

-- Ball
constant c_Ball_Radius : integer := 10;
constant c_Ball_Color : std_logic_vector(11 downto 0) := "111111111111";

constant c_Point_Color : std_logic_vector(11 downto 0) := "000011110000";

------------------
--- Components ---
------------------
component paddle_controller is
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


end component paddle_controller;
component ball_controller is
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
    o_Ball_X : out integer;
    
    -- Outputs the Point Values for each Player.
    o_P1_Points : out std_logic_vector(1 downto 0);
    o_P2_Points : out std_logic_vector(1 downto 0)
    );


end component ball_controller;
COMPONENT gamescreen_controller IS
    GENERIC (
        g_Point_Color : std_logic_vector(11 DOWNTO 0)
    );
    PORT (
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
        i_Resetgame : in std_logic;
        i_P1_lives : in std_logic_vector(1 downto 0);
        i_P2_lives : in std_logic_vector(1 downto 0)
    );
END COMPONENT gamescreen_controller;
end pong_package;
