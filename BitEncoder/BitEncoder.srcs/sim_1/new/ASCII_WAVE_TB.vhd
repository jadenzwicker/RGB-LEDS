--==================================================================================
--=
--=  Name: ASCII_WAVE_TB
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      Test Bench for BitEncoder generic component
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ASCII_WAVE_TB is
end ASCII_WAVE_TB;

architecture ASCII_WAVE_TB_ARCH of ASCII_WAVE_TB is
    
    constant ACTIVE: std_logic := '1';
    
    --unit-under-test-------------------------------------COMPONENT
    component ASCII_WAVE
        port(
            clk:      in   std_logic;
            btnC:     in   std_logic;
            sw:       in   std_logic_vector(15 downto 0);
            seg:      out  std_logic_vector(6 downto 0);
            waveform: out  std_logic
            );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal clk:      std_logic;
    signal btnC:     std_logic;
    signal sw:       std_logic_vector(15 downto 0);
    signal seg:      std_logic_vector(6 downto 0);
    signal waveform: std_logic;
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: ASCII_WAVE
    port map(
        clk      => clk,
        btnC     => btnC,
        sw       => sw,
        seg      => seg,
        waveform => waveform
        );

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
        sw(7 downto 0) <= "01100101";    -- Green
        sw(15) <= ACTIVE;
        
        wait;
    end process;
end ASCII_WAVE_TB_ARCH;