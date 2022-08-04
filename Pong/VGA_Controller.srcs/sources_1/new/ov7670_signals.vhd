----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.08.2022 21:55:52
-- Design Name: 
-- Module Name: ov7670_signals - Behavioral
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

entity ov7670_signals is
    Port ( 
        clk   : in    STD_LOGIC;
        sioc  : out   STD_LOGIC;
        siod  : inout STD_LOGIC;
        reset : out   STD_LOGIC;
        pwdn  : out   STD_LOGIC;
		xclk  : out   STD_LOGIC
    );
end ov7670_signals;

architecture Behavioral of ov7670_signals is
    constant camera_address : std_logic_vector(7 downto 0) := x"42"; -- 42"; -- Device write ID - see top of page 11 of data sheet
    
    SIGNAL advance : std_logic := '0'; -- gibt an, dass der nächste command gesendet werden kann
    signal command : std_logic_vector(15 downto 0);
    signal finished : std_logic  := '0';
    signal send : std_logic; -- low, wenn finished high ist. gibt an, ob i2c_sender senden soll
    signal not_clk : std_logic; -- immer das gegenteil von clk
    
    
    COMPONENT ov7670_registers IS
        PORT(
            clk : IN STD_LOGIC;
		    advance : IN STD_LOGIC;
		    command : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		    finished : OUT STD_LOGIC
        );
    END COMPONENT ov7670_registers;
    
    component i2c_sender is
        port(
            clk : in STD_LOGIC;	 
            siod : inout STD_LOGIC;
            sioc : out STD_LOGIC;
			advance : out STD_LOGIC;
			send : in STD_LOGIC;
            id : in STD_LOGIC_VECTOR (7 downto 0);
            reg : in STD_LOGIC_VECTOR (7 downto 0);
            value : in STD_LOGIC_VECTOR (7 downto 0)
        );
    end component i2c_sender;

begin
    send <= not finished;
    reset <= '1'; 						-- Normal mode
	pwdn  <= '0'; 						-- Power device up
	xclk  <= not_clk;                   -- immer das gegenteil von clk
    
    ov7670_rgstrs : ov7670_registers PORT MAP(
        clk => clk,
        advance => advance,
        command => command,
        finished => finished
    );
    
    i2c_sndr : i2c_sender port map(
        clk => clk,
        siod => siod,
        sioc => sioc,
        advance => advance,
        send => send,
        id => camera_address,
        reg => command(15 downto 8),
        value => command(7 downto 0)
    );
    
    process(clk)
	begin
		if rising_edge(clk) then
			not_clk <= not not_clk;
		end if;
	end process;

end Behavioral;
