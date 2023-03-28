--==================================================================================
--=
--=  Name: BitEncoder_TB
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      Test Bench for BitEncoder generic component
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
--    SYSTEM_RESET: process
--    begin
--        reset <= ACTIVE;
--        wait for 20 ns;
--        reset <= not ACTIVE;
--        wait;
--    end process SYSTEM_RESET;
    
    --============================================================================
    --  Test Case Driver
    --============================================================================
    TEST_CASE_DRIVER: process
    begin
        data <= "111111111111111111111111";
        txEn <= ACTIVE;
--        wait for 2875 ns;   -- time to transmit 24 bits at slowed down rate
--        txEn <= not ACTIVE;
      
        wait;
    end process;
end BitEncoder_TB_ARCH;