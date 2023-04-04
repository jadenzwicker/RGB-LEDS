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
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:    std_logic;
    signal clock:    std_logic;
    signal txEn:     std_logic;
    signal data:     std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
    signal waveform: std_logic;
    
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
        txEn     => txEn,
        data     => data,
        waveform => waveform
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
        wait until reset = not ACTIVE;
        wait until rising_edge(clock);
        txEn <= ACTIVE;
        data <= "111111111111000000000000";
        
        -- Turns txEn off after all data has been transmitted
       -- data'length - 1 becasue txEn must be off before clock starts transmission again
        for i in 0 to data'length - 1 loop
            wait until waveform = '1';
        end loop;
        txEn <= not ACTIVE;
        
--        wait for 1000 ns;
--        wait until rising_edge(clock);
--        txEn <= ACTIVE;
--        data <= "101010101010101010101001";
        
--        -- Turns txEn off after all data has been transmitted
--       -- data'length - 1 becasue txEn must be off before clock starts transmission again
--        for i in 0 to data'length - 1 loop
--            wait until waveform = '1';
--        end loop;
--        txEn <= not ACTIVE;
        
        
--        --data <= "000000000000000000000000";
--        --data <= "111111111111111111111111";
--        --data <= "100000000000000000000001";
        wait;
    end process;
end BitEncoder_TB_ARCH;