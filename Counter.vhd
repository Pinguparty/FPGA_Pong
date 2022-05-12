----------------------------------------------------------------------------------
-- Company: Hochschule RheinMain
-- Engineer: Steffen Reith <Steffen.Reith@hs-rm.de>
-- 
-- Create Date: Mon May 2 20:23:33 CEST 2022
-- Design Name: Counter
-- Module Name: Counter - Behavioral
-- Project Name: CounterDemo
-- Target Devices: Artix7-100 auf Digilent Nexys4 DDR
-- Tool Versions: Vivado 19.0
-- Description: Kleines Demo eines Zählers
-- 
-- Dependencies: none
-- 
-- Revision: 1
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Counter IS
    PORT (
        clk100Mhz : IN STD_LOGIC;
        nreset : IN std_logic;
        sw1 : IN STD_LOGIC;
        leds : OUT STD_LOGIC_VECTOR (6 DOWNTO 0));
END Counter;

ARCHITECTURE Behavioral OF Counter IS

    SIGNAL counter : STD_LOGIC_VECTOR (28 DOWNTO 0);
    SIGNAL counter_n : STD_LOGIC_VECTOR (28 DOWNTO 0);
    signal clk25mhz : std_logic;
    signal locked_in : std_logic;

    
    component clk_wiz_0
        port (  clk_25mhz          : out    std_logic;
                resetn           : in     std_logic;
                locked            : out    std_logic;
                clk_in1           : in     std_logic
        );
    end component;

BEGIN
    
    clk1 : clk_wiz_0 port map (clk_25mhz => clk25mhz, resetn => nreset, locked => locked_in, clk_in1 => clk100Mhz);
    
    -- Sensibilitätliste
    cnt : PROCESS (nreset, clk25mhz)
    
    BEGIN
        
        
        
        
        -- Asynchron Reset
        IF (nreset = '0') THEN

            -- Reset value
            counter <= (OTHERS => '0');

        ELSE

            -- Update value on rising edge
            IF (rising_edge(clk25mhz)) THEN

                counter <= counter_n;

            END IF;

        END IF;

        if (sw1 = '0') then
            -- Output logic
            leds <= counter(28 DOWNTO 22);

        else
            leds <= counter(26 DOWNTO 20);
        end if;

    END PROCESS;

    -- Next-state logic
    counter_n <= STD_LOGIC_VECTOR(unsigned(counter) + 1);


END Behavioral;