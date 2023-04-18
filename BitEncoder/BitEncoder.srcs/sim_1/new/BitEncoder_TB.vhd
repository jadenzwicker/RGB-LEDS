--==================================================================================
--=
--=  Name: BitEncoder_TB
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      Test Bench for the BitEncoder generic component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitEncoder_TB is
end BitEncoder_TB;

architecture BitEncoder_TB_ARCH of BitEncoder_TB is
    
    constant ACTIVE: std_logic := '1';
    constant PULSE_TIME:       positive := 400;
    constant NUM_OF_DATA_BITS: positive := 24;
    constant CLOCK_FREQUENCY:  positive := 100000000;
    
    --unit-under-test-------------------------------------COMPONENT
    component BitEncoder
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
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:    std_logic;
    signal clock:    std_logic;
    signal txStart:     std_logic;
    signal data:     std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
    signal waveform: std_logic;
    signal readyForData: std_logic;
    signal txComplete: std_logic;
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: BitEncoder
    generic map (
        ACTIVE           => ACTIVE,
        PULSE_TIME       => PULSE_TIME,
        NUM_OF_DATA_BITS => NUM_OF_DATA_BITS,
        CLOCK_FREQUENCY  => CLOCK_FREQUENCY
        )
    port map(
        reset    => reset,
        clock    => clock,
        txStart     => txStart,
        data     => data,
        waveform => waveform,
        readyForData => readyForData,
        txComplete => txComplete
        );

    --============================================================================
    --  Clock
    --============================================================================
    SYSTEM_CLOCK: process
    begin
        clock <= not ACTIVE;
        wait for 5 ns;
        clock <= ACTIVE;
        wait for 5 ns;
    end process SYSTEM_CLOCK;
    
    --============================================================================
    --  Reset        
    --============================================================================
    SYSTEM_RESET: process
    begin
        reset <= ACTIVE;
        wait for 50 ns;
        reset <= not ACTIVE;
        wait;
    end process SYSTEM_RESET;
    
    --============================================================================
    --  Test Case Driver
    --============================================================================
    TEST_CASE_DRIVER: process
    begin
    
        txStart <= not ACTIVE;
        data <= (others => '0');
        
        wait until (reset = not ACTIVE);
        wait until rising_edge(clock);
        txStart <= ACTIVE;
        data <= "111010101010101010101111";

        wait until rising_edge(clock);
        txStart <= not ACTIVE;  -- only needs pulse at start 'enable signal'
        
        wait until readyForData = ACTIVE;
        wait until rising_edge(clock);
        data <= "101111111111111111111111";
        txStart <= ACTIVE;
        wait until rising_edge(clock);
        txStart <= not ACTIVE;
        
       
        wait;
    end process;
end BitEncoder_TB_ARCH;