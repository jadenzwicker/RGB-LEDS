--==================================================================================
--=
--=  Name: Debouncer_TB
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      Test Bench for Debouncer generic component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitEncoder_TB is
end BitEncoder_TB;

architecture BitEncoder_TB_ARCH of BitEncoder_TB is
    
    constant ACTIVE: std_logic := '1';
    constant PULSE_TIME:      positive := 40;
    constant CLOCK_FREQUENCY: positive := 100000000;
    
    
    --unit-under-test-------------------------------------COMPONENT
    component BitEncoder
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
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:    std_logic;
    signal clock:    std_logic;
    signal txEn:     std_logic;
    signal data:     std_logic_vector(7 downto 0);
    signal waveform: std_logic;
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: BitEncoder
    generic map (
        ACTIVE          => ACTIVE,
        PULSE_TIME      => PULSE_TIME,
        CLOCK_FREQUENCY => CLOCK_FREQUENCY
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
        
        data <= "00001010";
        txEn <= ACTIVE;
        wait for 955 ns;   -- time to transmit 8 bits at slowed down rate
        txEn <= not ACTIVE;
        wait for 100 ns;
        data <= "11111111";
        txEn <= ACTIVE;
        wait for 955 ns;
        txEn <= not ACTIVE;
         
--        -- During reset testing
--        for i in 5 downto 0 loop
--            input <= '1';
--            wait for 10 ns ;
--            input <= '0';
--            wait for 10 ns ;
--        end loop;
--        ;
        
        wait;
    end process;
end BitEncoder_TB_ARCH;