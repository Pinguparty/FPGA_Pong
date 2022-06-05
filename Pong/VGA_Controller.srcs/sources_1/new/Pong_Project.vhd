----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.06.2022 23:53:08
-- Design Name: 
-- Module Name: Pong_Project - Behavioral
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

-- Oberdatei um alle Components hier einzubinden und zu verbinden. Logik hier eher vermeiden
-- (Quasi wie die Hauptplatine, auf der alles drauf installiert und verbunden wird)

ENTITY Pong_Project IS
    PORT (
        VGA_HS_O : OUT STD_LOGIC;
        VGA_VS_O : OUT STD_LOGIC;
        VGA_RED_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_BLUE_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_GREEN_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

        nreset : IN STD_LOGIC;
        clk100Mhz : IN STD_LOGIC;
        sw1 : IN STD_LOGIC
    );
END Pong_Project;

ARCHITECTURE Behavioral OF Pong_Project IS
    SIGNAL clk25Mhz : STD_LOGIC;
    SIGNAL locked : STD_LOGIC;

    SIGNAL x : unsigned(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y : unsigned(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL active : STD_LOGIC;

    SIGNAL red_bsp : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL blue_bsp : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL green_bsp : STD_LOGIC_VECTOR (3 DOWNTO 0);

    COMPONENT clk_wiz_0
        PORT (
            clk_out1 : OUT STD_LOGIC;
            resetn : IN STD_LOGIC;
            locked : OUT STD_LOGIC;
            clk_in1 : IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT vga_controller IS
        PORT (
            x_out : OUT UNSIGNED(9 DOWNTO 0);
            y_out : OUT UNSIGNED(9 DOWNTO 0);

            VGA_HS_O : OUT STD_LOGIC;
            VGA_VS_O : OUT STD_LOGIC;
            VGA_RED_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            VGA_BLUE_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            VGA_GREEN_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

            red_bsp : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_bsp : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_bsp : IN STD_LOGIC_VECTOR (3 DOWNTO 0);

            Clock_VGA : IN STD_LOGIC;
            n_reset : IN STD_LOGIC
        );
    END COMPONENT vga_controller;

    COMPONENT beispiel_controller IS
        PORT (
            red_bsp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            green_bsp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            blue_bsp : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

            x : IN UNSIGNED(9 DOWNTO 0);
            y : IN UNSIGNED(9 DOWNTO 0);

            nreset : IN STD_LOGIC;
            clock : IN STD_LOGIC;
            sw1 : IN STD_LOGIC
        );
    END COMPONENT beispiel_controller;
    BEGIN

        Clock_25MHz : clk_wiz_0 PORT MAP(
            clk_out1 => clk25Mhz,
            resetn => nreset,
            locked => locked,
            clk_in1 => clk100Mhz);

        VGA_Ctrl : vga_controller PORT MAP(
            x_out => x,
            y_out => y,

            VGA_HS_O => VGA_HS_O,
            VGA_VS_O => VGA_VS_O,
            VGA_RED_O => VGA_RED_O,
            VGA_BLUE_O => VGA_BLUE_O,
            VGA_GREEN_O => VGA_GREEN_O,

            red_bsp => red_bsp,
            blue_bsp => blue_bsp,
            green_bsp => green_bsp,

            Clock_VGA => clk25Mhz,
            n_reset => nreset
        );

        beispiel_cntr : beispiel_controller PORT MAP(
            red_bsp => red_bsp,
            green_bsp => blue_bsp,
            blue_bsp => green_bsp,

            x => x,
            y => y,

            nreset => nreset,
            clock => clk25Mhz,
            sw1 => sw1
        );

    END Behavioral;