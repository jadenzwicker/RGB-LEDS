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
    signal txDone:      std_logic;
    signal dataBit:     std_logic;
    signal thirdNextState:     std_logic;
    signal start:   std_logic;
    signal startCountThird: std_logic;
    
  -- Converts given time in ns to Hz and find the count of clock cycles needed to wait
  -- the given time. '- 1' is due to count starting at 0.
    constant COUNT_TO_PULSE: natural := (CLOCK_FREQUENCY/(10**9/PULSE_TIME)) - 1;
    constant COUNT_TO_PULSE_THIRD:   natural := COUNT_TO_PULSE - 2;
    
    -- Creating needed type and signals for transmit state machine.
    type Tx_States_t is (WAIT_FOR_EN, FIRST, SECOND, THIRD, DONE);
    signal currentState: Tx_States_t;
    signal nextState:    Tx_States_t;

begin

    --===================================================================================
    -- Pulse Generator Encoder                                                    PROCESS
    --===================================================================================
    PULSE_GEN_ENCODER: process(reset, clock)
    variable count: natural range 0 to COUNT_TO_PULSE;
    begin
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            -- Manages goNextState Pulse
            if (nextState /= WAIT_FOR_EN) or (start = ACTIVE) then    
                if (count = COUNT_TO_PULSE) then
                    count := 0;
                    goNextState <= ACTIVE;
                else
                    count := count + 1;
                    goNextState <= not ACTIVE; 
                end if;
            else
                count := 0; 
            end if;         
        end if;
    end process PULSE_GEN_ENCODER;
    
    
    --===================================================================================
    -- Pulse Generator Encoder                                                    PROCESS
    --===================================================================================
    PULSE_GEN_THIRD: process(reset, clock)
    variable count: natural range 0 to COUNT_TO_PULSE_THIRD;
    begin
        if (reset = ACTIVE) then
            count := 0;
        elsif (rising_edge(clock)) then
            -- Manages thirdNextState Pulse
            if (nextState = THIRD) then    
                if (count = COUNT_TO_PULSE_THIRD) then
                    count := 0;
                    thirdNextState <= ACTIVE;
                else
                    count := count + 1;
                    thirdNextState <= not ACTIVE; 
                end if;  
            else
                count := 0; 
            end if;          
        end if;
    end process PULSE_GEN_THIRD;
    
    
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
    STATE_TRANSITION_TRANSMITTER: process(currentState, dataBit, goNextState, thirdNextState, txEn)
    begin
        -- Defaults
        waveform <= not ACTIVE;
        nextState <= currentState;
        start <= ACTIVE;
        
        case currentState is
            when WAIT_FOR_EN =>
                start <= not ACTIVE;
                if (txEn = ACTIVE) then
                    nextState <= FIRST;
                end if;
                
            when FIRST =>
                waveform <= ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= SECOND;
                end if;
                
            when SECOND => 
                if (dataBit = '1') then   -- should not be active constant
                    waveform <= ACTIVE; 
                elsif (dataBit = '0') then
                    waveform <= not ACTIVE;    
                end if;
                
                if (goNextState = ACTIVE) then
                    nextState <= THIRD;
                end if;
                
            when THIRD => 
                waveform <= not ACTIVE;
                startCountThird <= ACTIVE;
                if (thirdNextState = ACTIVE) then
                    nextState <= DONE;          
                end if;
                
            when DONE => 
                waveform <= not ACTIVE;
                txDone <= ACTIVE;
                if (txEn = ACTIVE) then
                    nextState <= FIRST;  
                else
                    nextState <= WAIT_FOR_EN;            
                end if;    
        end case;
    end process;
end BitEncoder_ARCH;