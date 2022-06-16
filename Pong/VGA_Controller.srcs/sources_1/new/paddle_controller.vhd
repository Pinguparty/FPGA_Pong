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
    g_Player_Paddle_X : integer;
    g_Player_Paddle_Color : std_logic_vector(11 downto 0)
);
port(
    i_Clk : in std_logic;

    i_x : in unsigned(9 downto 0);
    i_y : in unsigned(9 downto 0);

    -- Player Paddle Control
    i_Paddle_Up : in std_logic;
    i_Paddle_Dn : in std_logic;
   
    o_Draw_Paddle : out std_logic_vector(11 downto 0);
    o_Paddle_Y    : out integer
    );


end paddle_controller;

architecture Behavioral of paddle_controller is
    SIGNAL int_counter : INTEGER := 0;
    SIGNAL paddle_Y : integer RANGE 0 TO c_Board_Height := (c_Board_Height /2 ) - (c_Paddle_Height / 2);
begin
    PROCESS(i_Clk)
    begin
        if(rising_edge(i_Clk)) then
        int_counter <= int_counter + 1;
        -- initialise color output to background-color
        o_Draw_Paddle <= c_Board_BG_Color;
        IF (((i_x > g_Player_Paddle_X) AND (i_y > paddle_Y) AND (i_x < g_Player_Paddle_X + c_Paddle_Width) AND (i_y < paddle_Y + c_Paddle_Height))) THEN
            o_Draw_Paddle <= g_Player_Paddle_Color;
        END IF;
    
        IF (int_counter = c_Game_Speed AND i_Paddle_Up = '0' AND i_Paddle_Dn = '0') THEN
                int_counter <= 0;
            END IF;
            IF (int_counter = c_Game_Speed AND i_Paddle_Up = '1') THEN
                paddle_Y <= paddle_Y - 1;
                int_counter <= 0;
            END IF;
            IF (int_counter = c_Game_Speed AND i_Paddle_Dn = '1') THEN
                paddle_Y <= paddle_Y + 1;
                int_counter <= 0;
            END IF;
        END IF;
    END PROCESS;
end Behavioral;
