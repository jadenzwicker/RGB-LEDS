--=======================================================================================
--=
--=  Name: BitEncoder
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
--          **OUTPUTS BITS LSB TO MSB**
--=======================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitEncoder is
    generic (
        ACTIVE: std_logic := '1';
        PULSE_TIME:          positive := 400;      -- In ns
        CLOCK_FREQUENCY:     positive := 100000000 -- In Hz
        );
    port (
    	reset:    in  std_logic;
        clock:    in  std_logic;
    	txEn:     in  std_logic;
    	data:     in  std_logic_vector(7 downto 0);
        waveform: out std_logic
        );
end BitEncoder;

architecture BitEncoder_ARCH of BitEncoder is
   
    signal goNextState: std_logic;
    signal start: std_logic;
    signal txDone: std_logic;
    signal dataBit: std_logic;
    
  -- Converts given time in ns to Hz and find the count of clock cycles needed to wait
  -- the given time. '- 1' is due to count starting at 0.
    constant COUNT_TO_PULSE: natural := (CLOCK_FREQUENCY/(10**9/PULSE_TIME)) - 1;
    constant COUNT_TO_END: natural := ((COUNT_TO_PULSE + 1) * 3) - 1;
    
    -- Creating needed type and signals for state machine.
    type Tx_States_t is (WAIT_FOR_EN, FIRST_1, FIRST_0, SECOND_1, SECOND_0, THIRD);
    signal currentState: Tx_States_t;
    signal nextState:    Tx_States_t;

begin

    --===================================================================================
    -- Pulse Generator Encoder                                                    PROCESS
    --===================================================================================
    PULSE_GEN_ENCODER: process(reset, clock)
    variable count1: natural range 0 to COUNT_TO_PULSE;
    variable count2: natural range 0 to COUNT_TO_END;
    begin
        if (reset = ACTIVE) then
            count1 := 0;
            count2 := 0;
        elsif (rising_edge(clock)) then
            -- Eliminates register delay in start signal being sent
            if (nextState = FIRST_1) or (nextState = FIRST_0) or (start = ACTIVE) then    
                if (count1 = COUNT_TO_PULSE ) then
                    count1 := 0;
                    goNextState <= ACTIVE;
                else
                    count1 := count1 + 1;
                    goNextState <= not ACTIVE; 
                end if;
                
           -- the extra - 1 is to account for the delay in Bit Gen to change the selected bit
                if (count2 = COUNT_TO_END - 1) then  
                    count2 := 0;
                    txDone <= ACTIVE;
                else
                    count2 := count2 + 1;
                    txDone <= not ACTIVE; 
                end if;
            else
                count1 := 0;
                count2 := 0;   
            end if;         
        end if;
    end process PULSE_GEN_ENCODER;
    
    
    --===================================================================================
    -- Bit Generator                                                              PROCESS
    --===================================================================================
	BIT_GEN: process(reset, clock)
	variable doneCount: natural range 0 to 7 := 0;
    begin
        dataBit <= data(doneCount);  -- Defaults
        if (reset = ACTIVE) then
            dataBit <= not ACTIVE;
            doneCount := 0;
        elsif (rising_edge(clock)) then
            if (doneCount = 7) then        -- max value
                dataBit <= dataBit;
            else   
                if (txDone = ACTIVE) then
                    doneCount := doneCount + 1;
                end if;
            end if;
        end if;
    end process BIT_GEN;
    
    
    --===================================================================================
    -- State Register for Transmitter                                             PROCESS
    --===================================================================================
    STATE_REGISTER_TRANSMITTER: process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentState <= WAIT_FOR_EN;
        elsif (rising_edge(clock)) then
            currentState <= nextState;
        end if;
    end process;
    
    --===================================================================================
    -- State Transition for Transmitter                                           PROCESS
    --===================================================================================
    STATE_TRANSITION_TRANSMITTER: process(currentState, dataBit, goNextState)
    begin
        -- Defaults
        waveform <= not ACTIVE;
        nextState <= currentState;
        
        case currentState is
            when WAIT_FOR_EN =>
                start <= not ACTIVE;
                if (txEn = ACTIVE) and (dataBit = ACTIVE) then
                    nextState <= FIRST_1;
                elsif (txEn = ACTIVE) and (dataBit = not ACTIVE) then
                    nextState <= FIRST_0;
                end if;
                
            when FIRST_1 =>
                start <= ACTIVE;
                waveform <= ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= SECOND_1;
                end if;
                
            when FIRST_0 =>
                start <= ACTIVE;
                waveform <= ACTIVE;     
                if (goNextState = ACTIVE) then
                    nextState <= SECOND_0;
                end if;  
                  
            when SECOND_1 => 
                waveform <= ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= THIRD;
                end if;
                
            when SECOND_0 => 
                waveform <= not ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= THIRD;
                end if;    
                
            when THIRD => 
                waveform <= not ACTIVE;
                if (txEn = not ACTIVE) and (goNextState = ACTIVE) then
                    nextState <= WAIT_FOR_EN;
                elsif (txEn = ACTIVE) and (goNextState = ACTIVE) and (dataBit = ACTIVE) then
                    nextState <= FIRST_1;
                elsif (txEn = ACTIVE) and (goNextState = ACTIVE) and (dataBit = not ACTIVE) then
                    nextState <= FIRST_0;    
                end if;
        end case;
    end process;
end BitEncoder_ARCH;