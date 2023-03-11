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

entity Debouncer_TB is
end Debouncer_TB;

architecture Debouncer_TB_ARCH of Debouncer_TB is
    
    constant ACTIVE: std_logic := '1';
    constant TIME_BETWEEN_PULSES: positive := 10000000;   -- Fast for testing purposes
    constant CLOCK_FREQUENCY:     positive := 100000000;
    
    
    --unit-under-test-------------------------------------COMPONENT
    component Debouncer
        generic (
            ACTIVE: std_logic := '1';
            TIME_BETWEEN_PULSES: positive := 12;       -- In Hz
            CLOCK_FREQUENCY:     positive := 100000000 -- In Hz
            );
        port (
            reset:          in  std_logic;
            clock:          in  std_logic;
            input:          in  std_logic;
            debouncedOutput: out std_logic
            );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:          std_logic;
    signal clock:          std_logic;
    signal input:          std_logic;
    signal debouncedOutput: std_logic;
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: Debouncer
    generic map (
        ACTIVE              => ACTIVE,
        TIME_BETWEEN_PULSES => TIME_BETWEEN_PULSES,
        CLOCK_FREQUENCY     => CLOCK_FREQUENCY
        )
    port map(
        reset          => reset,
        clock          => clock,
        input          => input,
        debouncedOutput => debouncedOutput
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
    --  Reset        "Allows for all possibilities to be tested during reset time"
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
        
        for i in 100 downto 0 loop
            input <= '1';
            wait for 10 ns ;
            input <= '0';
            wait for 10 ns ;
        end loop;
        
        wait;
    end process;
end Debouncer_TB_ARCH;