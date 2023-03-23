--=======================================================================================
--=
--=  Name: BitEncoder
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      This generic component takes in a std_logic_vector of data and transmits a 3 
--=      pulse encoded waveform based on the data.
--=      
--=      The waveform encoding generated works as follows, with PULSE_TIME determining
--=      the time between the pulse changes:
--=          ie. PULSE_TIME - PULSE_TIME - PULSE_TIME
--=          0:  HIGH       - LOW        - LOW
--=          1:  HIGH       - HIGH       - LOW
--=      
--=      The waveform transmitted reads the input data LSB to MSB.
--=
--=      Generic input definitions are described as follows:
--=          ACTIVE: A constant that is of type std_logic. Should only be defined as '1'
--=                  or '0' according to an active LOW or HIGH system.
--=
--=          PULSE_TIME: A constant that is of type positive. It defines the time that
--=                      the transmitter should be sending a pulse. Using the 3 pulse
--=                      encoding, that this componet is designed for, the total 
--=                      transmission time of the waveform will be 3 times the 
--=                      PULSE_TIME. This is described in nanoseconds.
--=
--=          NUM_OF_DATA_BITS: A constant that is of type positive. It defines the time that
--=                       the transmitter should be sending a pulse. Using the 3 pulse
--=                       encoding, that this componet is designed for, the total 
--=                       transmission time of the waveform will be 3 times the 
--=
--=          CLOCK_FREQUENCY: A constant that is of type positive defining the clock 
--=                           frequency of the system.
--=                           This is described in real time Hz.
--= 
--=======================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitEncoder is
    generic (
        ACTIVE: std_logic := '1';
        PULSE_TIME:          positive := 400;      -- In ns
        NUM_OF_DATA_BITS:    positive := 24;
        CLOCK_FREQUENCY:     positive := 100000000 -- In Hz
        );
    port (
    	reset:    in  std_logic;
        clock:    in  std_logic;
    	txEn:     in  std_logic;
    	data:     in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
        waveform: out std_logic
        );
end BitEncoder;

architecture BitEncoder_ARCH of BitEncoder is
   
    signal goNextState: std_logic;
    signal start:       std_logic;
    signal txDone:      std_logic;
    signal dataBit:     std_logic;
    
  -- Converts given time in ns to Hz and find the count of clock cycles needed to wait
  -- the given time. '- 1' is due to count starting at 0.
    constant COUNT_TO_PULSE: natural := (CLOCK_FREQUENCY/(10**9/PULSE_TIME)) - 1;
    constant COUNT_TO_END:   natural := ((COUNT_TO_PULSE + 1) * 3) - 1;
    
    -- Creating needed type and signals for transmit state machine.
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
                if (count1 = COUNT_TO_PULSE) then
                    count1 := 0;
                    goNextState <= ACTIVE;
                else
                    count1 := count1 + 1;
                    goNextState <= not ACTIVE; 
                end if;
                
           -- the extra - 1 is to account for the delay in Bit Gen to change the selected bit
           -- MINUS 1 CAUSES ISSUE WHERE IT SKIPS A BIT AFTER AWHILE CAUSE COUNT IS TOO SMALL
           -- BUT NOT MINUS 1 HAS DELAY ISSUES WTFFFF
           -- No -1 first bit does not chnage
           -- Yes -1 you skip bits eventually over long time
                if (count2 = (COUNT_TO_END)) then
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
	variable doneCount: natural range 0 to NUM_OF_DATA_BITS - 1 := 0;
    begin
        dataBit <= data(doneCount);  -- Defaults
        if (reset = ACTIVE) then
            dataBit <= not ACTIVE;
            doneCount := 0;
        elsif (rising_edge(clock)) then
            if (doneCount = NUM_OF_DATA_BITS - 1) then        -- max value
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
                start <= ACTIVE;
                waveform <= ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= THIRD;
                end if;
                
            when SECOND_0 => 
                start <= ACTIVE;
                waveform <= not ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= THIRD;
                end if;    
                
            when THIRD => 
                start <= ACTIVE;
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