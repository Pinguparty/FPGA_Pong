----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.08.2022 21:54:09
-- Design Name: 
-- Module Name: ov7670_controller - Behavioral
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
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

library pong;
use pong.pong_package.all;


entity ov7670_controller is
    PORT(
        clk : in STD_LOGIC;
        
        pclk  : in  STD_LOGIC; -- pixelclock
        xclk  : out STD_LOGIC; -- clock für die Kamera
        vsync_ov7670 : in  STD_LOGIC;
        href  : in  STD_LOGIC; -- gibt an, wann Daten kommen
        data  : in  STD_LOGIC_vector(7 downto 0);
        sioc  : out STD_LOGIC; -- i2c clock
        siod  : inout STD_LOGIC; -- i2c Daten
        pwdn  : out STD_LOGIC; -- power mode
        reset : out STD_LOGIC; -- immer high
        
        SW : in STD_LOGIC_VECTOR(3 downto 0); -- Sensitivity of paddels
        
        player_input_o : out STD_LOGIC_VECTOR(1 DOWNTO 0);
        
        x : IN UNSIGNED(9 DOWNTO 0);
        y : IN UNSIGNED(9 DOWNTO 0);
        
        vsync_vga : IN STD_LOGIC;
        active_vga_i : IN STD_LOGIC;
        
        active_ov7670_o : OUT STD_LOGIC;
        rgb_ov7670_o : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
    );
end ov7670_controller;

architecture Behavioral of ov7670_controller is
    SIGNAL addra : std_logic_vector(16 downto 0); -- input adress of camera output
    SIGNAL data_usable : std_logic_vector(11 downto 0); -- input of frame_buffer
    signal wren : std_logic_vector(0 downto 0); -- write enable buffer
    SIGNAL addrb : std_logic_vector(16 downto 0); --adress of requested output
    signal val : INTEGER RANGE 0 TO 307200 := 0; --requested Pixel
    signal active_ov7670 : std_logic;
    signal rgb_ov7670 : std_logic_vector(11 downto 0);
    SIGNAL input1_delay_timer : integer := 0; -- extends the time the player_input is high
    SIGNAL input2_delay_timer : integer := 0;
    signal sensitivity_lower_p1 : std_logic_vector(3 downto 0); -- lowest accepted value of green and blue for p1 input
    signal sensitivity_upper_p1 : std_logic_vector(3 downto 0); -- lowest accepted value of red for p1 input
    signal sensitivity_lower_p2 : std_logic_vector(3 downto 0); -- lowest accepted value of red and green for p2 input
    signal sensitivity_upper_p2 : std_logic_vector(3 downto 0); -- lowest accepted value of blue for p2 input
    

    COMPONENT ov7670_signals IS
        PORT(
            clk   : in    STD_LOGIC;
            sioc  : out   STD_LOGIC;
            siod  : inout STD_LOGIC;
            reset : out   STD_LOGIC;
            pwdn  : out   STD_LOGIC;
			xclk  : out   STD_LOGIC
        );
    END COMPONENT ov7670_signals;
    
    COMPONENT ov7670_capture IS
        PORT(
            pclk  : in   STD_LOGIC;
            vsync : in   STD_LOGIC;
            href  : in   STD_LOGIC;
            d     : in   STD_LOGIC_VECTOR (7 downto 0);
            addr  : out  STD_LOGIC_VECTOR (16 downto 0);
            dout  : out  STD_LOGIC_VECTOR (11 downto 0);
            we    : out  STD_LOGIC
        );
    END COMPONENT ov7670_capture;
     
    COMPONENT frame_buffer
        PORT (
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            clkb : IN STD_LOGIC;
            addrb : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
            doutb : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) 
        );
    END COMPONENT;
        
begin
    addrb <= std_logic_vector(to_unsigned(val, addrb'length));
    active_ov7670_o <= active_ov7670;
    rgb_ov7670_o <= rgb_ov7670;
    
    ov7670_sngl : ov7670_signals PORT MAP(
        clk => clk,
        sioc => sioc,
        siod => siod,
        reset => reset,
        pwdn => pwdn,
        xclk => xclk
    );
    
    ov7670_cptr : ov7670_capture PORT MAP(
        pclk => pclk,
        vsync => vsync_ov7670,
        href => href,
        d => data,
        addr => addra,
        dout => data_usable,
        we => wren(0)
    );

    frame_bffr : frame_buffer PORT MAP (
        clka => pclk,
        wea => wren,
        addra => addra,
        dina => data_usable,
        clkb => clk,
        addrb => addrb,
        doutb => rgb_ov7670
        );

    process(clk)
		begin	  
         if rising_edge(clk) then
                
                -- set sensitivity
                case SW(1 downto 0) is
                    when "00" =>
                        sensitivity_lower_p1 <= "1000";
                        sensitivity_upper_p1 <= "1000";
                    when "01" =>
                        sensitivity_lower_p1 <= "0100";
                        sensitivity_upper_p1 <= "1000";
                    when "10" =>
                        sensitivity_lower_p1 <= "1000";
                        sensitivity_upper_p1 <= "1100";
                    when "11" =>
                        sensitivity_lower_p1 <= "0100";
                        sensitivity_upper_p1 <= "1100";
                    when others =>
                        sensitivity_lower_p1 <= "0100";
                        sensitivity_upper_p1 <= "1000";
                end case;
                case SW(3 downto 2) is
                    when "00" =>
                        sensitivity_lower_p2 <= "1000";
                        sensitivity_upper_p2 <= "1000";
                    when "01" =>
                        sensitivity_lower_p2 <= "0100";
                        sensitivity_upper_p2 <= "1000";
                    when "10" =>
                        sensitivity_lower_p2 <= "1000";
                        sensitivity_upper_p2 <= "1100";
                    when "11" =>
                        sensitivity_lower_p2 <= "0100";
                        sensitivity_upper_p2 <= "1100";
                    when others =>
                        sensitivity_lower_p2 <= "0100";
                        sensitivity_upper_p2 <= "1000";
                end case;
            
            -- detect correct colors at the corner and send a player_input signal
            if(x > c_camera_x + 3 and x < c_camera_x + 8 and y > c_camera_y + 3 and y < c_camera_y + 8)
            and (rgb_ov7670(11 downto 8) > sensitivity_upper_p1)
            and (rgb_ov7670(7  downto 4) < sensitivity_lower_p1) --checks if colors are accepted
            and (rgb_ov7670(3  downto 0) < sensitivity_lower_p1)
            then
                player_input_o(0) <= '1';
                input1_delay_timer <= c_holding_time; -- reset input delay timer 
            else
                if input1_delay_timer > 0 then -- holding the input high
                    player_input_o(0) <= '1';
                    input1_delay_timer <= input1_delay_timer - 1;
                else
                    player_input_o(0) <= '0'; 
                end if;
            end if;
            if(x > c_camera_x + 160 - 8 and x < c_camera_x + 160 - 3 and y > c_camera_y + 3 and y < c_camera_y + 8)
            and (rgb_ov7670(11 downto 8) < sensitivity_lower_p2)
            and (rgb_ov7670(7  downto 4) < sensitivity_lower_p2) --checks if colors are accepted
            and (rgb_ov7670(3  downto 0) > sensitivity_upper_p2)
            then
                player_input_o(1) <= '1';
                input2_delay_timer <= c_holding_time; -- reset input delay timer 
            else
                if input2_delay_timer > 0 then
                    player_input_o(1) <= '1';
                    input2_delay_timer <= input2_delay_timer - 1; -- holding the input high
                else
                    player_input_o(1) <= '0'; 
                end if;
            end if;
            
            -- draw camera output on bottom of screen
            if active_vga_i='1' 
            and (x > c_camera_x and x < c_camera_x + 160) 
            and (y > c_camera_y and y < c_camera_y + 120) 
            and (val < 640*480) 
            then
                val <= ((to_integer(y - c_camera_y) * 640) + to_integer(x - c_camera_x));
                active_ov7670 <= '1';
            else
                active_ov7670 <= '0';
			end if;
            if vsync_vga = '0' then 
                val <= 0;
            end if;
		end if;	
	end process;

end Behavioral;
