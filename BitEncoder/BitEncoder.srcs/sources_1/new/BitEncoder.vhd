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
--=      The waveform transmitted reads the input data MSB to LSB.
--=
--=      Generic input definitions are described as follows:
--=          ACTIVE: A constant that is of type std_logic. Should only be defined as '1'
--=                  or '0' according to an active LOW or HIGH system.
--=
--=          PULSE_TIME: A constant that is of type positive. It defines the time that
--=                      the transmitter should be sending a pulse. In this component the
--=                      default time a pulse should last is 1200 ns which defines either
--=                      a '1' or '0' bit. This is described in nanoseconds.
--=
--=          NUM_OF_DATA_BITS: A constant that is of type positive. It defines the number
--=                            of bits of the data input. This allows for a variable 
--=                            number of bits to be queded for transmission.
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
        ACTIVE:           std_logic := '1';
        PULSE_TIME:       positive := 400;      -- In ns
        CLOCK_FREQUENCY:  positive := 100000000; -- In Hz
        NUM_OF_DATA_BITS: positive := 24
        );
    port (
    	clock:      in  std_logic;
    	reset:      in  std_logic;
    	txStart:    in  std_logic;    -- begins transmission, when set active the state of 'data' port will be latched in a register. do not activate transmission without correct data waiting at 'data' port..
    	data:       in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);       -- generic sized port to hold the data that is to be transmitted. one txStarted is triggered the data will be held in a register so this port does not need to be held constant throughout transmission
        waveform:   out std_logic;                -- output pulse encoded waveform of the input data
        readyForData: out std_logic;                 -- output which notifies a conrtroller system that the data's transmission has been completed.
        txComplete: out std_logic
        );
end BitEncoder;

architecture BitEncoder_ARCH of BitEncoder is
   
    -- pulse that triggers state transition after x amount of clock cycles   
    signal goNextState: std_logic;
    -- same as goNextState signal but for the third state in the state machine, has 
    -- different timing
    signal thirdNextState:     std_logic;
    
  -- Converts given time in ns to Hz and find the count of clock cycles needed to wait
  -- the given time. '- 1' is due to count starting at 0.
    constant COUNT_TO_PULSE:       natural := (CLOCK_FREQUENCY/(10**9/PULSE_TIME)) - 1;
    constant COUNT_TO_PULSE_THIRD: natural := COUNT_TO_PULSE - 2;
    
    -- Creating needed type and signals for transmit state machine.
    type Tx_States_t is (WAIT_FOR_EN, FIRST_0, SECOND_0, FIRST_1, SECOND_1, THIRD, DONE, DONE2);
    signal currentState: Tx_States_t;
    signal nextState:    Tx_States_t;
    
    -- internal signals
    signal txEn:     std_logic;
    signal pulseDone:     std_logic;
    signal txStarted : boolean := false;
    signal pulseCounter : integer range 0 to NUM_OF_DATA_BITS - 1 := 0;
    signal currentBit: std_logic;   -- not type bit due to data's indexes not being of type bit
    signal dataReg : std_logic_vector(data'length -1 downto 0);
    signal lastBit: std_logic;  -- ready for next bit signal
    signal txCompleteSignal: std_logic;

begin

    -- manages notifing user of when the system can recive new data to transmit.
    DATA_READY: process(reset, clock)
    begin
        if (reset = ACTIVE) then
            readyForData <= not ACTIVE;
        elsif (rising_edge(clock)) then
            if (txStarted = false) then
                readyForData <= ACTIVE;
            else 
                readyForData <= not ACTIVE;
            end if;
        end if;
    end process;
   

    --===================================================================================
    -- Pulse Generator Next                                                       PROCESS
    --   Manages goNextState Pulse
    --===================================================================================
    PULSE_GEN_NEXT: process(reset, clock)
    variable count: natural range 0 to COUNT_TO_PULSE;
    begin
        if (reset = ACTIVE) then
            count := 0;
            goNextState <= not ACTIVE;
        elsif (rising_edge(clock)) then
            if (nextState /= WAIT_FOR_EN) then
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
    end process;
    
    
    --===================================================================================
    -- Pulse Generator Third                                                      PROCESS
    --   Manages thirdNextState Pulse
    --===================================================================================
    PULSE_GEN_THIRD: process(reset, clock)
    variable count: natural range 0 to COUNT_TO_PULSE_THIRD;
    begin
        if (reset = ACTIVE) then
            count := 0;
            thirdNextState <= not ACTIVE;
        elsif (rising_edge(clock)) then
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
    end process;
    
    --===================================================================================
    -- Bit Transmitter                                                            PROCESS
    --   Handles sending each bit from the input data vector (MSB to LSB)
    --   data is held in a register so port is not required to be constant.
    --===================================================================================
    BIT_TRANS: process (clock, reset)
    begin
        --lastBit <= not ACTIVE;
        if (reset = ACTIVE) then
            pulseCounter <= 0;
            txStarted   <= false;
            currentBit  <= '0';
            dataReg     <= (others => '0');
            lastBit <= not ACTIVE;
            txEn <= not ACTIVE;
        elsif (rising_edge(clock)) then
            if (txStart = ACTIVE) and (txStarted = false) then
                dataReg <= data;
                txStarted <= true;
                currentBit <= data(NUM_OF_DATA_BITS - 1);          -- no need for register since data should be constant at time of storage anyways
                pulseCounter <= 1;
                txEn <= ACTIVE;
            elsif (pulseDone = ACTIVE and txStarted and lastBit = not ACTIVE) then
                if (pulseCounter < NUM_OF_DATA_BITS) then
                    currentBit <= dataReg(NUM_OF_DATA_BITS - pulseCounter - 1);
                    pulseCounter <= pulseCounter + 1;
                end if;
            elsif (pulseDone = ACTIVE and lastBit = ACTIVE) then
                lastBit <= not ACTIVE;
            end if;
            
            if (pulseCounter = NUM_OF_DATA_BITS) then
                lastBit  <= ACTIVE;
                txStarted <= false;
                pulseCounter <= 0;
                currentBit <= '0';   -- after transmission is completed
                txEn <= not ACTIVE;
            end if;
            
        end if;
    end process BIT_TRANS;

    
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
    STATE_TRANSITION_TRANSMITTER: process(currentState, currentBit, goNextState, 
                                          thirdNextState, txEn)
    begin
        -- Defaults
        waveform <= not ACTIVE;
        nextState <= currentState;
        pulseDone <= not ACTIVE;
        txComplete <= not ACTIVE;
        case currentState is
            when WAIT_FOR_EN =>
                if (txEn = ACTIVE) and (currentBit = '0') then
                    nextState <= FIRST_0;
                elsif (txEn = ACTIVE) and (currentBit = '1') then
                    nextState <= FIRST_1;
                end if;
                
            when FIRST_0 =>
                waveform <= ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= SECOND_0;
                end if;
                
            when SECOND_0 => 
                waveform <= not ACTIVE;
                if (goNextState = ACTIVE) then
                    nextState <= THIRD;
                end if;
                
            when FIRST_1 =>
                waveform <= ACTIVE; 
                if (goNextState = ACTIVE) then
                    nextState <= SECOND_1;
                end if;
                
            when SECOND_1 => 
                waveform <= ACTIVE;
                if (goNextState = ACTIVE) then
                    nextState <= THIRD;
                end if;    
                
            when THIRD => 
                waveform <= not ACTIVE;
                if (thirdNextState = ACTIVE) then
                    nextState <= DONE;          
                end if;
                
            when DONE => 
                waveform <= not ACTIVE;
                pulseDone <= ACTIVE;
                nextState <= DONE2; 
                
                -- manages total transmission complete signal
                if (lastBit = ACTIVE) then
                    txCompleteSignal <= ACTIVE;
                else
                    txCompleteSignal <= not ACTIVE;
                end if;  
                
            when DONE2 => 
                waveform <= not ACTIVE;
                if (txEn = ACTIVE) and (currentBit = '0') then
                    nextState <= FIRST_0;
                elsif (txEn = ACTIVE) and (currentBit = '1')then      
                    nextState <= FIRST_1;
                else
                    nextState <= WAIT_FOR_EN;            
                end if;
                
                
                -- manages total transmission complete signal
                if (txCompleteSignal = ACTIVE) then
                    txComplete <= ACTIVE;
                end if;
                txCompleteSignal <= not ACTIVE;       
        end case;
    end process;
end BitEncoder_ARCH;