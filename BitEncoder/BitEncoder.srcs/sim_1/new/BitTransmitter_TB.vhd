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
            NUM_OF_DATA_BITS: positive := 24
            );
        port (
            reset:         in  std_logic;
            clock:         in  std_logic;
            txStart:       in  std_logic;
            txBitDone:     in  std_logic;
            data:          in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
            currentBit:    out std_logic;
            txEn:          out std_logic;
            bitTxComplete: out std_logic
            );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:      std_logic;
    signal clock:      std_logic;
    signal txStart:    std_logic;
    signal txBitDone:     std_logic;
    signal data:       std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
    signal currentBit: std_logic;
    signal txEn: std_logic;
    signal bitTxComplete: std_logic;
    
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
        txBitDone     => txBitDone,
        data       => data,
        currentBit => currentBit,
        txEn => txEn,
        bitTxComplete => bitTxComplete
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
        txBitDone <= not ACTIVE;
        txStart <= not ACTIVE;
        data <= (others => '0');
        
        wait until (reset = not ACTIVE);
        wait until rising_edge(clock);
        txStart <= ACTIVE;
        data <= "111010101010101010101111";

        wait until rising_edge(clock);
        txStart <= not ACTIVE;  -- only needs pulse at start 'enable signal'
        
        for i in 0 to NUM_OF_DATA_BITS + 5 loop    -- +5 to test that output is 0 when transmission complete
            wait for 400 ns;
            wait until rising_edge(clock);
            txBitDone <= ACTIVE;
            wait until rising_edge(clock);
            txBitDone <= not ACTIVE;
        end loop;
        
        wait for 200 ns;
        wait until rising_edge(clock);
        data <= "111111111111111111111111";
        txStart <= ACTIVE;
        wait until rising_edge(clock);
        txStart <= not ACTIVE;
        
        for i in 0 to NUM_OF_DATA_BITS + 5 loop
            wait for 400 ns;
            wait until rising_edge(clock);
            txBitDone <= ACTIVE;
            wait until rising_edge(clock);
            txBitDone <= not ACTIVE;
        end loop;

        wait;
    end process;
end BitTransmitter_TB_ARCH;