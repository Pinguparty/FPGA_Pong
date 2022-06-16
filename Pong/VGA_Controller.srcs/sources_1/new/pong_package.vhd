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
constant c_Game_Speed : INTEGER := 100000; --Ticks between updates ==> lower is faster

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

------------------
--- Components ---
------------------
component paddle_controller is
generic (
    g_Player_Paddle_X: integer -- defines X-Location for the 
);
port (
      i_Clk : in std_logic;

      i_Col_Count_Div : in std_logic_vector(5 downto 0);
      i_Row_Count_Div : in std_logic_vector(5 downto 0);

      -- Player Paddle Control
      i_Paddle_Up : in std_logic;
      i_Paddle_Dn : in std_logic;

      o_Draw_Paddle : out std_logic;
      o_Paddle_Y    : out std_logic_vector(5 downto 0)
      );
end component paddle_controller;

component ball_controller is
port (
    i_Clk           : in  std_logic;
    i_Game_Active   : in  std_logic;
    i_Col_Count_Div : in  std_logic_vector(5 downto 0);
    i_Row_Count_Div : in  std_logic_vector(5 downto 0);
    --
    o_Draw_Ball     : out std_logic;
    o_Ball_X        : out std_logic_vector(5 downto 0);
    o_Ball_Y        : out std_logic_vector(5 downto 0)
);
end component ball_controller;
end pong_package;
