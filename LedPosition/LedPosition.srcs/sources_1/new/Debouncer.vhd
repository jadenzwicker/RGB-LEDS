--==================================================================================
--=
--=  Name: Debouncer
--=  Designer: Jaden Zwicker
--=
--=      This component generates a one-cycle clock pulse whenever the input goes
--=      from a LOW to a HIGH level. Holding the input signal ACTIVE for extended
--=      periods of time will not generate additional pulses. The trigger signal
--=      must fall low prior to generating another pulse.
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debouncer is
    port (
    	reset:          in  std_logic;
        clock:          in  std_logic;
    	input:          in  std_logic;
        debouncedInput: out std_logic
    );
end Debouncer;

architecture Debouncer_ARCH of Debouncer is

    -- Active High constant implemented for readability.
	constant ACTIVE:  std_logic := '1';
    
    constant TIME_BEFORE_ACTIVE: integer := 12;
    signal count: integer range 0 to TIME_BEFORE_ACTIVE := 0;
    signal enable: std_logic;
    constant COUNT_4HZ: integer := (100000000/12)-1;   -- Used to slow down clock
    
    -- Creating State Machine needed type and signals
    type States_t is (WAIT_FOR_PRESS, PULSE, WAIT_FOR_RELEASE);
    signal currentState: States_t;
    signal nextState:    States_t;

begin
	
	PULSE_GENERATOR: process(reset, clock)
    variable count: integer range 0 to COUNT_4HZ;
    begin
        -- Control count variables incrementation and reset
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            if (count = COUNT_4HZ) then
                count := 0;
                enable <= ACTIVE;
            else
                count := count + 1;
                enable <= not ACTIVE; 
            end if;
        end if;
    end process PULSE_GENERATOR;
    
    --=============================================================PROCESS
    -- State register
    --====================================================================
    STATE_REGISTER: process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentState <= WAIT_FOR_PRESS;
        elsif (rising_edge(clock)) then
            currentState <= nextState;
        end if;
    end process;
    
    --=============================================================PROCESS
    -- State transitions
    --====================================================================
    STATE_TRANSITION: process(currentState, input, enable) -- Needs to have all used signals for a async process, "all" keyword does this better.
    begin
        debouncedInput <= not ACTIVE;
        nextState <= currentState;
        
        case currentState is
            when WAIT_FOR_PRESS =>
                if (input = '1') then
                    nextState <= PULSE;
                else
                    nextState <= WAIT_FOR_PRESS;
                end if;
                
            when PULSE =>
                debouncedInput <= ACTIVE;
                nextState <= WAIT_FOR_RELEASE; 
                  
            when WAIT_FOR_RELEASE => 
                if (input = not ACTIVE) and (enable = ACTIVE) then
                    nextState <= WAIT_FOR_PRESS;
                else
                    nextState <= WAIT_FOR_RELEASE;
                end if;
            
        end case;
    end process;
end Debouncer_ARCH;