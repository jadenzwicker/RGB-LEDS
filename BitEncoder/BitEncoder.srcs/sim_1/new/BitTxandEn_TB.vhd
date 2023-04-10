--==================================================================================
--=
--=  Name: BitTxandEn_TB
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      Test Bench for BitTransmitter generic component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitTxandEn_TB is
end BitTxandEn_TB;

architecture BitTxandEn_TB_ARCH of BitTxandEn_TB is
    
    constant ACTIVE: std_logic := '1';

    
    --unit-under-test-------------------------------------COMPONENT
    component BitTxandEn
        port(
            clock:      in   std_logic;
            reset:      in   std_logic;
            txStart:    in   std_logic;
            color:      in   std_logic_vector(23 downto 0);
            waveform:   out  std_logic
            );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal reset:      std_logic;
    signal clock:      std_logic;
    signal txStart:    std_logic;
    signal waveform:   std_logic;
    signal color:      std_logic_vector(23 downto 0);

    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: BitTxandEn
    port map(
        reset      => reset,
        clock      => clock,
        txStart    => txStart,
        color      => color,
        waveform   => waveform
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
        txStart <= not ACTIVE;
        color <= (others => '0');
        
        wait until (reset = not ACTIVE);
        wait until rising_edge(clock);
        txStart <= ACTIVE;
        color <= "111010101010101010101111";

        wait until rising_edge(clock);
        txStart <= not ACTIVE;  -- only needs pulse at start 'enable signal'
        
--        for i in 0 to NUM_OF_DATA_BITS + 5 loop    -- +5 to test that output is 0 when transmission complete
--            wait for 400 ns;
--            wait until rising_edge(clock);
--            txBitDone <= ACTIVE;
--            wait until rising_edge(clock);
--            txBitDone <= not ACTIVE;
--        end loop;
        
--        wait for 200 ns;
--        wait until rising_edge(clock);
--        data <= "111111111111111111111111";
--        txStart <= ACTIVE;
--        wait until rising_edge(clock);
--        txStart <= not ACTIVE;
        
--        for i in 0 to NUM_OF_DATA_BITS + 5 loop
--            wait for 400 ns;
--            wait until rising_edge(clock);
--            txBitDone <= ACTIVE;
--            wait until rising_edge(clock);
--            txBitDone <= not ACTIVE;
--        end loop;

        wait;
    end process;
end BitTxandEn_TB_ARCH;