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
        VGA_GREEN_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        VGA_BLUE_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        
        CA : OUT STD_LOGIC;
        CB : OUT STD_LOGIC;
        CC : OUT STD_LOGIC;
        CD : OUT STD_LOGIC;
        CE : OUT STD_LOGIC;
        CF : OUT STD_LOGIC;
        CG : OUT STD_LOGIC;
        AN : out STD_LOGIC_VECTOR (7 downto 0);-- 8 Anode signals

        nreset : IN STD_LOGIC;
        clk100Mhz : IN STD_LOGIC;
        sw1 : IN STD_LOGIC;
        
        BTNC : IN STD_LOGIC;
        BTNU : IN STD_LOGIC;
        BTNL : IN STD_LOGIC;
        BTNR : IN STD_LOGIC;
        BTND : IN STD_LOGIC;
        
        SW : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        
        
        ov7670_pclk  : in  STD_LOGIC;
        ov7670_xclk  : out STD_LOGIC;
        ov7670_vsync : in  STD_LOGIC;
        ov7670_href  : in  STD_LOGIC;
        ov7670_data  : in  STD_LOGIC_vector(7 downto 0);
        ov7670_sioc  : out STD_LOGIC;
        ov7670_siod  : inout STD_LOGIC;
        ov7670_pwdn  : out STD_LOGIC;
        ov7670_reset : out STD_LOGIC
        

    );
END Pong_Project;

ARCHITECTURE Behavioral OF Pong_Project IS
    SIGNAL clk25Mhz : STD_LOGIC;
    SIGNAL locked : STD_LOGIC;

    SIGNAL x : unsigned(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL y : unsigned(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL active_vga : STD_LOGIC;
    SIGNAL vsync_vga :STD_LOGIC;

    SIGNAL rgb_pong : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL rgb_ov7670 : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL active_ov7670 : STD_LOGIC;
    
    SIGNAL P1_points : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL P2_points : STD_LOGIC_VECTOR (1 DOWNTO 0);
    
    SIGNAL player_input : STD_LOGIC_VECTOR (1 DOWNTO 0);
    
    SIGNAL ball_x : integer;

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
            VGA_GREEN_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            VGA_BLUE_O : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);

            rgb_pong : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
            rgb_ov7670 : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
            active_ov7670_i : IN STD_LOGIC;
            
            active_o : OUT STD_LOGIC;

            Clock_VGA : IN STD_LOGIC;
            n_reset : IN STD_LOGIC
        );
    END COMPONENT vga_controller;

    COMPONENT pong_controller IS
        PORT (
            rgb_pong : OUT STD_LOGIC_VECTOR (11 DOWNTO 0);
            
            o_P1_Points : OUT std_logic_vector(1 downto 0);
            o_P2_Points : OUT std_logic_vector(1 downto 0);
            
            o_Ball_x : out integer;

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
    END COMPONENT pong_controller;
    COMPONENT seven_segment_controller IS
        PORT (
            i_Clk        : in  std_logic;
            i_Binary_Num_P1 : in  std_logic_vector(1 downto 0);
            i_Binary_Num_P2 : in  std_logic_vector(1 downto 0);
    
            o_Segment_A  : out std_logic;
            o_Segment_B  : out std_logic;
            o_Segment_C  : out std_logic;
            o_Segment_D  : out std_logic;
            o_Segment_E  : out std_logic;
            o_Segment_F  : out std_logic;
            o_Segment_G  : out std_logic;
            
            o_Anode_Activate : out STD_LOGIC_VECTOR (7 downto 0) -- 8 Anode signals
        );
    END COMPONENT seven_segment_controller;
    COMPONENT ov7670_controller IS
        PORT (
            clk : in STD_LOGIC;
        
            pclk  : in  STD_LOGIC;
            xclk  : out STD_LOGIC;
            vsync_ov7670 : in  STD_LOGIC;
            href  : in  STD_LOGIC;
            data  : in  STD_LOGIC_vector(7 downto 0);
            sioc  : out STD_LOGIC;
            siod  : inout STD_LOGIC;
            pwdn  : out STD_LOGIC;
            reset : out STD_LOGIC;
            
            player_input_o : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            
            x : IN UNSIGNED(9 DOWNTO 0);
            y : IN UNSIGNED(9 DOWNTO 0);
            
            vsync_vga : IN STD_LOGIC;
            active_vga_i : IN STD_LOGIC;
            
            active_ov7670_o : OUT STD_LOGIC;
            rgb_ov7670_o : out STD_LOGIC_VECTOR (11 DOWNTO 0)
        );
    END COMPONENT ov7670_controller;
    BEGIN
        VGA_VS_O <= vsync_vga;
        
        Clock_25MHz : clk_wiz_0 PORT MAP(
            clk_out1 => clk25Mhz,
            resetn => nreset,
            locked => locked,
            clk_in1 => clk100Mhz);

        VGA_Ctrl : vga_controller PORT MAP(
            x_out => x,
            y_out => y,

            VGA_HS_O => VGA_HS_O,
            VGA_VS_O => vsync_vga,
            VGA_RED_O => VGA_RED_O,
            VGA_GREEN_O => VGA_GREEN_O,
            VGA_BLUE_O => VGA_BLUE_O,

            rgb_pong => rgb_pong,
            rgb_ov7670 => rgb_ov7670, 
            active_ov7670_i => active_ov7670,
            
            active_o => active_vga,

            Clock_VGA => clk25Mhz,
            n_reset => nreset
        );

        pong_ctrl : pong_controller PORT MAP(
            rgb_pong => rgb_pong,
            
            o_P1_Points => P1_points,
            o_P2_Points => P2_points,
            
            o_Ball_x => ball_x,

            x => x,
            y => y,

            nreset => nreset,
            clock => clk25Mhz,
            sw1 => sw1,
            
            player_input_i => player_input,
            
            BTNC => BTNC,
            BTNU => BTNU,
            BTNL => BTNL,
            BTNR => BTNR,
            BTND => BTND
        );
        
        seven_segment_ctrl : seven_segment_controller
        PORT MAP(
            i_Clk => clk25Mhz,
            i_Binary_Num_P1 => P1_points,
            i_Binary_Num_P2 => P2_points,
            o_Segment_A  => CA,
            o_Segment_B  => CB,
            o_Segment_C  => CC,
            o_Segment_D  => CD,
            o_Segment_E  => CE,
            o_Segment_F  => CF,
            o_Segment_G  => CG,
            o_Anode_Activate => AN
        );
        
        ov7670_ctrl : ov7670_controller
        PORT MAP(
            clk => clk25Mhz,
        
            pclk => ov7670_pclk,
            xclk => ov7670_xclk,
            vsync_ov7670 => ov7670_vsync,
            href => ov7670_href,
            data => ov7670_data,
            sioc => ov7670_sioc,
            siod => ov7670_siod,
            pwdn => ov7670_pwdn,
            reset => ov7670_reset,
            
            player_input_o => player_input,
            
            x => x,
            y => y,
            
            vsync_vga => vsync_vga,
            active_vga_i => active_vga, 
            
            active_ov7670_o => active_ov7670,
            rgb_ov7670_o => rgb_ov7670
        );
    END Behavioral;