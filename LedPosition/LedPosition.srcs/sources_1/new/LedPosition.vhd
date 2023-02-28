----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2023 08:34:18 AM
-- Design Name: 
-- Module Name: LedPosition - LedPosition_ARCH
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
-------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Module Name: LedWave - LedWave_ARCH
-- 
-- Description:
-- LED wave pattern for BASYS3 board. To be set as new default.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LedWave is
    port(
        reset:           in  std_logic;
        clock:           in  std_logic;
        incrementLedEn:  in std_logic;
        decrementLedEn:  in std_logic;
        editMode:        in std_logic;
        selectedLed:     out std_logic_vector
    );
end LedWave;

architecture LedWave_ARCH of LedWave is

    -- Defining general constants
    constant ACTIVE: std_logic := '1';
--    constant COUNT_4HZ: integer := (100000000/4)-1;
    
    -- Defining Constants for led illumination values
    constant BLANK_LEDS: std_logic_vector(15 downto 0) := "0000000000000000";
    constant LEFT_LEDS:  std_logic_vector(15 downto 0) := "1000000000000000";
    constant POS1_LEDS:  std_logic_vector(15 downto 0) := "1100000000000000";
    constant POS2_LEDS:  std_logic_vector(15 downto 0) := "0110000000000000";
    constant POS3_LEDS:  std_logic_vector(15 downto 0) := "0011000000000000";
    constant POS4_LEDS:  std_logic_vector(15 downto 0) := "0001100000000000";
    constant POS5_LEDS:  std_logic_vector(15 downto 0) := "0000110000000000";
    constant POS6_LEDS:  std_logic_vector(15 downto 0) := "0000011000000000";
    constant POS7_LEDS:  std_logic_vector(15 downto 0) := "0000001100000000";
    constant POS8_LEDS:  std_logic_vector(15 downto 0) := "0000000110000000";
    constant POS9_LEDS:  std_logic_vector(15 downto 0) := "0000000011000000";
    constant POS10_LEDS: std_logic_vector(15 downto 0) := "0000000001100000";
    constant POS11_LEDS: std_logic_vector(15 downto 0) := "0000000000110000";
    constant POS12_LEDS: std_logic_vector(15 downto 0) := "0000000000011000";
    constant POS13_LEDS: std_logic_vector(15 downto 0) := "0000000000001100";
    constant POS14_LEDS: std_logic_vector(15 downto 0) := "0000000000000110";
    constant POS15_LEDS: std_logic_vector(15 downto 0) := "0000000000000011";
    constant RIGHT_LEDS: std_logic_vector(15 downto 0) := "0000000000000001";
    
    -- Right and left states contain one led lit at the left and rightmost postion.
    -- All other states contain 2 lit leds scrolling accross the panel from
    -- left to right.
    type States_t is (BLANK, LEFT, POS1, POS2, POS3, POS4, POS5, POS6, POS7, POS8,
                       POS9, POS10, POS11, POS12, POS13, POS14, POS15, RIGHT);
                       
    -- Creating signals for state machine, of type States_t which is all
    -- possible states. 
    signal currentState: States_t;
    signal nextState: States_t;
    
    -- Creating pulse signal to active state machine due to clock speed = 100MHz
    signal pulse: std_logic;
    
begin
    
    STATE_REGISTER: process(reset, clock)
    begin
        if (reset=ACTIVE) then
            currentState <= BLANK;
        elsif (rising_edge(clock)) then
            currentState <= nextState;
        end if;
    end process;
    
    STATE_TRANSITION: process(currentState, pulse)
    begin
        case CurrentState is
            -- BLANK
            when BLANK =>
            leds <= BLANK_LEDS;
            nextState <= LEFT;
            
            -- LEFT
            when LEFT =>
            leds <= LEFT_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS1;
            else
                nextState <= LEFT;
            end if;
            
            -- POS1
            when POS1 =>
            leds <= POS1_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS2;
            else
                nextState <= POS1;
            end if;
            
            -- POS2
            when POS2 =>
            leds <= POS2_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS3;
            else
                nextState <= POS2;
            end if;
            
            -- POS3
            when POS3 =>
            leds <= POS3_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS4;
            else
                nextState <= POS3;
            end if;
            
            -- POS4
            when POS4 =>
            leds <= POS4_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS5;
            else
                nextState <= POS4;
            end if;
            
            -- POS5
            when POS5 =>
            leds <= POS5_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS6;
            else
                nextState <= POS5;
            end if;
            
            -- POS6
            when POS6 =>
            leds <= POS6_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS7;
            else
                nextState <= POS6;
            end if;
            
            -- POS7
            when POS7 =>
            leds <= POS7_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS8;
            else
                nextState <= POS7;
            end if;
            
            -- POS8
            when POS8 =>
            leds <= POS8_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS9;
            else
                nextState <= POS8;
            end if;
            
            -- POS9
            when POS9 =>
            leds <= POS9_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS10;
            else
                nextState <= POS9;
            end if;
            
            -- POS10
            when POS10 =>
            leds <= POS10_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS11;
            else
                nextState <= POS10;
            end if;
            
            -- POS11
            when POS11 =>
            leds <= POS11_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS12;
            else
                nextState <= POS11;
            end if;
            
            -- POS12
            when POS12 =>
            leds <= POS12_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS13;
            else
                nextState <= POS12;
            end if;
            
            -- POS13
            when POS13 =>
            leds <= POS13_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS14;
            else
                nextState <= POS13;
            end if;
            
            -- POS14
            when POS14 =>
            leds <= POS14_LEDS;
            if (pulse = ACTIVE) then
                nextState <= POS15;
            else
                nextState <= POS14;
            end if;
            
            -- POS15
            when POS15 =>
            leds <= POS15_LEDS;
            if (pulse = ACTIVE) then
                nextState <= RIGHT;
            else
                nextState <= POS15;
            end if;
            
            -- RIGHT
            when RIGHT =>
            leds <= RIGHT_LEDS;
            if (pulse = ACTIVE) then
                nextState <= LEFT;
            else
                nextState <= RIGHT;
            end if;
        end case;
    end process;
    
    PULSE_GENERATOR: process(reset, clock)
    variable count: integer range 0 to COUNT_4HZ;
    begin
        -- Control count variables incrementation and reset
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            if (count = COUNT_4HZ) then
                count := 0;
            else
                count := count + 1;
            end if;
        end if;
        
        -- Update pulse depending on counts value
        pulse <= not ACTIVE;                                    -- default case
        if (count = COUNT_4HZ) then
            pulse <= ACTIVE;
        end if;
    end process PULSE_GENERATOR;
end LedWave_ARCH;

