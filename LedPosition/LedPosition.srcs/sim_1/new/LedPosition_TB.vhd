--==================================================================================
--=
--= Name: LedPosition_TB
--= University: Kennesaw State University
--= Designer: Jaden Zwicker
--=
--=     Test Bench for LedPosition component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LedPosition_TB is
end LedPosition_TB;

architecture LedPosition_TB_ARCH of LedPosition_TB is
    
    -- Creating Constant for the NUM_OF_LEDS being tested up to, used in signal
    -- definition and generic map definition.
    constant NUM_OF_LEDS: positive := 14;
    constant ACTIVE: std_logic := '1';
    
    --unit-under-test-------------------------------------COMPONENT
    component LedPosition
        generic(NUM_OF_LEDS: positive);
        port (
            reset:                              in  std_logic;
            clock:                              in  std_logic;
            incrementCurrentLedPositionEnable:  in  std_logic;
            decrementCurrentLedPositionEnable:  in  std_logic;
            editMode:                           in  std_logic;
            currentLedPosition:                 out std_logic_vector(NUM_OF_LEDS - 1 downto 0)
        );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:                               std_logic;
    signal clock:                               std_logic;
    signal incrementCurrentLedPositionEnable:   std_logic;
    signal decrementCurrentLedPositionEnable:   std_logic;
    signal editMode:                            std_logic;
    signal currentLedPosition:                  std_logic_vector(NUM_OF_LEDS -1 downto 0);
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: LedPosition
    generic map (NUM_OF_LEDS)
    port map(
        reset                             => reset,
        clock                             => clock,
        incrementCurrentLedPositionEnable => incrementCurrentLedPositionEnable,
        decrementCurrentLedPositionEnable => decrementCurrentLedPositionEnable,
        editMode                          => editMode,
        currentLedPosition                => currentLedPosition
    );
    
    --============================================================================
    --  Reset        "Allows for all possibilities to be tested during reset time"
    --============================================================================
    SYSTEM_RESET: process
    begin
        reset <= ACTIVE;
        wait for 100 ns;
        reset <= not ACTIVE;
        wait;
    end process SYSTEM_RESET;

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
    -- Testing During Reset
        -- editMode not ACTIVE
        editMode <= '0';
        wait for 10 ns;
        incrementCurrentLedPositionEnable <= '1';
        wait for 10 ns;
        decrementCurrentLedPositionEnable <= '1';
        wait for 10 ns;
        incrementCurrentLedPositionEnable <= '0';
        wait for 10 ns;
        decrementCurrentLedPositionEnable <= '0';
        wait for 10 ns;
        
        -- editMode ACTIVE
        editMode <= '1';
        wait for 10 ns;
        incrementCurrentLedPositionEnable <= '1';
        wait for 10 ns;
        decrementCurrentLedPositionEnable <= '1';
        wait for 10 ns;
        incrementCurrentLedPositionEnable <= '0';
        wait for 10 ns;
        decrementCurrentLedPositionEnable <= '0';
        wait for 10 ns;
        
    -- Testing Without Reset
        editMode <= '0';
        wait for 25 ns;
        
        -- editMode not ACTIVE
        editMode <= '0';
        wait for 10 ns;
        incrementCurrentLedPositionEnable <= '1';
        wait for 10 ns;
        decrementCurrentLedPositionEnable <= '1';
        wait for 10 ns;
        incrementCurrentLedPositionEnable <= '0';
        wait for 10 ns;
        decrementCurrentLedPositionEnable <= '0';
        wait for 10 ns;
        
        -- editMode ACTIVE
        editMode <= '1';
        wait for 25 ns;
        incrementCurrentLedPositionEnable <= '1';
        wait for 200 ns;
        decrementCurrentLedPositionEnable <= '1';
        wait for 50 ns;
        incrementCurrentLedPositionEnable <= '0';
        wait for 200 ns;
        decrementCurrentLedPositionEnable <= '0';
        wait for 25 ns;
        
        wait;
    end process;
end LedPosition_TB_ARCH;