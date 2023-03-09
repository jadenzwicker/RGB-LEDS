--==================================================================================
--=
--= Name: Debouncer_TB
--= University: Kennesaw State University
--= Designer: Jaden Zwicker
--=
--=     Test Bench for Debouncer component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debouncer_TB is
end Debouncer_TB;

architecture Debouncer_TB_ARCH of Debouncer_TB is
    
    constant ACTIVE: std_logic := '1';
    
    --unit-under-test-------------------------------------COMPONENT
    component Debouncer
        port (
            reset:          in  std_logic;
            clock:          in  std_logic;
            input:          in  std_logic;
            debouncedInput: out std_logic
        );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:          std_logic;
    signal clock:          std_logic;
    signal input:          std_logic;
    signal debouncedInput: std_logic;
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: Debouncer
    port map(
        reset          => reset,
        clock          => clock,
        input          => input,
        debouncedInput => debouncedInput
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
    --  Test Case Driver
    --============================================================================
    TEST_CASE_DRIVER: process
    begin
        
        reset <= '1';
        wait for 30 ns;
        reset <= '0';
        wait for 10 ns;
        
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        input <= '1';
        wait for 10 ns ;
        input <= '0';
        wait for 10 ns ;
        
        wait;
    end process;
end Debouncer_TB_ARCH;