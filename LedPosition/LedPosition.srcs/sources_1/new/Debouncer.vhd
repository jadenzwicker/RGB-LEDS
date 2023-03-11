--=======================================================================================
--=
--=  Name: Debouncer
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      This generic component generates a one-cycle clock pulse whenever the input goes
--=      from not ACTIVE to ACTIVE. Another pulse cannot be generated until the following
--=      requirements have been satisfied:
--=      ~    The input has been set to not ACTIVE then ACTIVE once again. 
--=      ~    A defined amount of time has passed. 
--=      
--=      This functionality creates a debouncer for unstable inputs.
--=
--=      Holding the input signal ACTIVE for extended periods of time will not generate
--=      additional pulses regardless of the defined wait time due to the input having to
--=      be set to not ACTIVE before triggering another pulse.
--=      Hence outputs will not be spammed at clock speed.
--=
--=      Generic input definitions are described as follows:
--=          ACTIVE: a constant that is of type std_logic. Should only be defined as '1'
--=                  or '0' according to an active LOW or HIGH system.
--=
--=          TIME_BETWEEN_PULSES: a constant that is of type positive. It defines the 
--=                               delay between possible pulses being sent out.
--=                               This is described in real time Hz.
--=
--=          CLOCK_FREQUENCY: a constant that is of type positive defining the clock 
--=                           frequency of the system.
--=                           This is described in real time Hz.
--= 
--=======================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debouncer is
    generic (
        ACTIVE: std_logic := '1';
        TIME_BETWEEN_PULSES: positive := 12;       -- In Hz
        CLOCK_FREQUENCY:     positive := 100000000 -- In Hz
        );
    port (
    	reset:           in  std_logic;
        clock:           in  std_logic;
    	input:           in  std_logic;
        debouncedOutput: out std_logic
        );
end Debouncer;

architecture Debouncer_ARCH of Debouncer is
   
    signal pulse: std_logic;
    
  -- Calculating the count per clock cycle needed to achieve the desired pulse frequency.
    constant COUNT_BETWEEN_PULSES: natural := (CLOCK_FREQUENCY/TIME_BETWEEN_PULSES) - 1;
    
    -- Creating needed type and signals for state machine.
    type States_t is (WAIT_FOR_INPUT, OUTPUT, WAIT_FOR_CONDITIONS);
    signal currentState: States_t;
    signal nextState:    States_t;

begin

	--===================================================================================
    -- Pulse Generator                                                            PROCESS
    --===================================================================================
	PULSE_GENERATOR: process(reset, clock)
    variable count: natural range 0 to COUNT_BETWEEN_PULSES;
    begin
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            if (count = COUNT_BETWEEN_PULSES) then
                count := 0;
                pulse <= ACTIVE;
            else
                count := count + 1;
                pulse <= not ACTIVE; 
            end if;
        end if;
    end process PULSE_GENERATOR;
    
    --===================================================================================
    -- State Register                                                             PROCESS
    --===================================================================================
    STATE_REGISTER: process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentState <= WAIT_FOR_INPUT;
        elsif (rising_edge(clock)) then
            currentState <= nextState;
        end if;
    end process;
    
    --===================================================================================
    -- State Transitions                                                          PROCESS
    --===================================================================================
    STATE_TRANSITION: process(currentState, input, pulse)
    begin
        -- Defaults
        debouncedOutput <= not ACTIVE;
        nextState <= currentState;
        
        case currentState is
            when WAIT_FOR_INPUT =>
                if (input = ACTIVE) then
                    nextState <= OUTPUT;
                end if;
                
            when OUTPUT =>
                debouncedOutput <= ACTIVE;
                nextState <= WAIT_FOR_CONDITIONS; 
                  
            when WAIT_FOR_CONDITIONS => 
                if (input = not ACTIVE) and (pulse = ACTIVE) then
                    nextState <= WAIT_FOR_INPUT;
                end if;
            
        end case;
    end process;
end Debouncer_ARCH;