--==================================================================================
--=
--= Name: LedPosition_BASYS3_TB
--= University: Kennesaw State University
--= Designer: Jaden Zwicker
--=
--=     Test Bench for LedPosition component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LedPosition_BASYS3_TB is
end LedPosition_BASYS3_TB;

architecture LedPosition_BASYS3_TB_ARCH of LedPosition_BASYS3_TB is
    
    -- Creating Constant for the NUM_OF_LEDS being tested up to, used in signal
    -- definition and generic map definition.
    constant ACTIVE: std_logic := '1';
    
    --unit-under-test-------------------------------------COMPONENT
    component LedPosition_BASYS3
        port(
            clk:   in   std_logic;
            btnC:  in   std_logic;
            btnR:  in   std_logic;
            btnL:  in   std_logic;
            sw:    in   std_logic_vector(15 downto 0);
            seg:   out  std_logic_vector(6 downto 0);
            led:    out  std_logic_vector(15 downto 0);
            an:    out  std_logic_vector(3 downto 0)
            );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal clk:    std_logic;
    signal btnC:   std_logic;
    signal btnR:   std_logic;
    signal btnL:   std_logic;
    signal sw:     std_logic_vector(15 downto 0);
    signal seg:    std_logic_vector(6 downto 0);
    signal an:     std_logic_vector(3 downto 0);
    signal led:     std_logic_vector(15 downto 0);
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: LedPosition_BASYS3
    port map(
        clk  => clk,
        btnC => btnC,
        btnR => btnR,
        btnL => btnL,
        sw   => sw,
        seg  => seg,
        an   => an,
        led  => led
    );
    
    --============================================================================
    --  Reset        "Allows for all possibilities to be tested during reset time"
    --============================================================================
    SYSTEM_RESET: process
    begin
        btnC <= ACTIVE;
        wait for 100 ns;
        btnC <= not ACTIVE;
        wait;
    end process SYSTEM_RESET;

    --============================================================================
    --  Clock
    --============================================================================
    SYSTEM_CLOCK: process
    begin
        clk <= not ACTIVE;
        wait for 5 ns;
        clk <= ACTIVE;
        wait for 5 ns;
    end process SYSTEM_CLOCK;
    
    --============================================================================
    --  Test Case Driver
    --============================================================================
    TEST_CASE_DRIVER: process
    begin
--    -- Testing During Reset
--        -- editMode not ACTIVE
--        sw(0) <= '0';
--        wait for 10 ns;
--        btnR <= '1';
--        wait for 10 ns;
--        btnL <= '1';
--        wait for 10 ns;
--        btnR <= '0';
--        wait for 10 ns;
--        btnL <= '0';
--        wait for 10 ns;
        
--        -- editMode ACTIVE
--        sw(0) <= '1';
--        wait for 10 ns;
--        btnR <= '1';
--        wait for 10 ns;
--        btnL <= '1';
--        wait for 10 ns;
--        btnR <= '0';
--        wait for 10 ns;
--        btnL <= '0';
--        wait for 10 ns;
        
--    -- Testing Without Reset
--        sw(0) <= '0';
--        wait for 25 ns;

--        -- editMode not ACTIVE
--        sw(0) <= '0';
--        wait for 10 ns;
--        btnR <= '1';
--        wait for 10 ns;
--        btnL <= '1';
--        wait for 10 ns;
--        btnR <= '0';
--        wait for 10 ns;
--        btnL <= '0';
--        wait for 10 ns;
        
        wait for 125 ns;
        -- editMode ACTIVE
        sw(0) <= '1';
        wait for 25 ns;
        btnR <= '1';
        wait for 200 ns;
        btnL <= '1';
        wait for 50 ns;
        btnR <= '0';
        wait for 200 ns;
        btnL <= '0';
        wait for 25 ns;
        
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        
        wait for 100 ns;
        
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        btnR <= '1';
        wait for 10 ns;
        btnR <= '0';
        wait for 10 ns;
        
        wait;
    end process;
end LedPosition_BASYS3_TB_ARCH;