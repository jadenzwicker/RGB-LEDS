--==================================================================================
--=
--=  Name: BitTransmitter_TB
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      Test Bench for BitTransmitter generic component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitTransmitter_TB is
end BitTransmitter_TB;

architecture BitTransmitter_TB_ARCH of BitTransmitter_TB is
    
    constant ACTIVE: std_logic := '1';
    constant NUM_OF_DATA_BITS: positive := 24;

    
    --unit-under-test-------------------------------------COMPONENT
    component BitTransmitter
        generic (
            ACTIVE: std_logic := '1';
            NUM_OF_DATA_BITS:    positive := 24
            );
        port (
            reset:      in  std_logic;
            clock:      in  std_logic;
            txStart:    in  std_logic;
            txDone:     in  std_logic;
            data:       in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
            currentBit: out std_logic
            );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:      std_logic;
    signal clock:      std_logic;
    signal txStart:    std_logic;
    signal txDone:     std_logic;
    signal data:       std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
    signal currentBit: std_logic;
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: BitTransmitter
    generic map (
        ACTIVE           => ACTIVE,
        NUM_OF_DATA_BITS => NUM_OF_DATA_BITS
        )
    port map(
        reset      => reset,
        clock      => clock,
        txStart    => txStart,
        txDone     => txDone,
        data       => data,
        currentBit => currentBit
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
        wait for 20 ns;
        reset <= not ACTIVE;
        wait;
    end process SYSTEM_RESET;
    
    --============================================================================
    --  Test Case Driver
    --============================================================================
    TEST_CASE_DRIVER: process
    begin
    
        --wait until (reset = not ACTIVE);
        --data <= "000000000000000000000000";
        data <= "111100001111000011110000";
        --data <= "111111111111111111111111";
        txStart <= ACTIVE;
        wait for 40 ns;
        txStart <= not ACTIVE;
        
        for i in 0 to 30 loop
            wait for 30 ns;
            wait until rising_edge(clock);
            txDone <= ACTIVE;
            wait until rising_edge(clock);
            txDone <= not ACTIVE;
        end loop;
        
        --data <= "100000000000000000000001";
        
      
        wait;
    end process;
end BitTransmitter_TB_ARCH;