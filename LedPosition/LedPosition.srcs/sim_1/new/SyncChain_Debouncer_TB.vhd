--==================================================================================
--=
--= Name: SyncChain_Debouncer_TB
--= University: Kennesaw State University
--= Designer: Jaden Zwicker
--=
--=     Test Bench for SyncChain_Debouncer_TB component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SyncChain_Debouncer_TB is
end SyncChain_Debouncer_TB;

architecture SyncChain_Debouncer_TB_ARCH of SyncChain_Debouncer_TB is
    
    constant ACTIVE: std_logic := '1';
    
    --unit-under-test-------------------------------------COMPONENT
    component SyncChain_Debouncer
        port(
            reset:          in   std_logic;
            clock:          in   std_logic;
            btnR:           in   std_logic;
            debouncedInput: out  std_logic
            );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:          std_logic;
    signal clock:          std_logic;
    signal btnR:           std_logic;
    signal debouncedInput: std_logic;
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: SyncChain_Debouncer
    port map(
        reset          => reset,
        clock          => clock,
        btnR           => btnR,
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
        
        btnR <= '1';
        wait for 100 ns ;
        btnR <= '0';
        wait for 100 ns ;
        btnR <= '1';
        wait for 100 ns ;
        btnR <= '0';
        wait for 100 ns ;
        btnR <= '1';
        wait for 100 ns ;
        btnR <= '0';
        wait for 100 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        btnR <= '1';
        wait for 10 ns ;
        btnR <= '0';
        wait for 10 ns ;
        
        
        
        wait;
    end process;
end SyncChain_Debouncer_TB_ARCH;