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

entity Debouncer_LedPosition_TB is
end Debouncer_LedPosition_TB;

architecture Debouncer_LedPosition_TB_ARCH of Debouncer_LedPosition_TB is
    
    constant ACTIVE: std_logic := '1';
    
    --unit-under-test-------------------------------------COMPONENT
    component Debouncer_LedPosition
        port (
            reset:    in  std_logic;
            clock:    in  std_logic;
            input:  in  std_logic;
            decLed:  in  std_logic;
            edit:  in  std_logic;
            currentLedPosition:  out std_logic_vector(7 downto 0)
        );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:          std_logic;
    signal clock:          std_logic;
    signal input:           std_logic;
    signal decLed: std_logic;
    signal edit: std_logic;
    signal currentLedPosition: std_logic_vector(7 downto 0);
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: Debouncer_LedPosition
    port map(
        reset          => reset,
        clock          => clock,
        input           => input,
        decLed => decLed,
        edit => edit,
        currentLedPosition => currentLedPosition
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
        
        edit <= '1';
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
end Debouncer_LedPosition_TB_ARCH;