----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Module Name: ColorConverter_BASYS3 - ColorConverter_BASYS3_ARCH
-- 
-- Course Name: CPE 3020/01
-- Lab 3
-- 
--      Wrapper file for ColorConverter component using the basys3 board.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ColorConverter_BASYS3 is
    -- Here we define the ports from the default basys3 config file.
    -- Names must match config file names since we are porting from there.
    port (  
           sw :    in  std_logic_vector (7 downto 0);
           btnC :  in std_logic;
           seg :   out std_logic_vector (6 downto 0);
           led :   out std_logic_vector (15 downto 0)
    );
end ColorConverter_BASYS3;

architecture ColorConverter_BASYS3_ARCH of ColorConverter_BASYS3 is
    -- This component is used to pull in the ports from the ColorConverter design.
    component ColorConverter
        port (
             charPressed:  in   std_logic_vector(7 downto 0);
             color:        out  std_logic_vector(23 downto 0);
             sevenSegs:    out  std_logic_vector(6 downto 0)  
        );
    end component;
    
    signal lowerColorBits : std_logic_vector(15 downto 0);
    signal upperColorBits : std_logic_vector(15 downto 0);
    signal color :          std_logic_vector(23 downto 0);
    
    constant ACTIVE:        std_logic := '1';
begin
    -- Mapping the config file pins to the ports in ColorConverter design.
    MY_DESIGN: ColorConverter port map (
        charPressed => sw,
        -- Bits need to be reversed to work with boards 7segment
        sevenSegs(6) => seg(0),
        sevenSegs(5) => seg(1),
        sevenSegs(4) => seg(2),
        sevenSegs(3) => seg(3),
        sevenSegs(2) => seg(4),
        sevenSegs(1) => seg(5),
        sevenSegs(0) => seg(6),
        
        color => color
    );
    
    upperColorBits(15 downto 8) <= (others => '0');
    upperColorBits(7 downto 0)  <= color(23 downto 16);
    
    lowerColorBits <= color(15 downto 0);
    
    COLOR_LEDS_MULTIPLEXER: with btnC select
        led <= upperColorBits    when ACTIVE,
               lowerColorBits    when others;
    
end ColorConverter_BASYS3_ARCH;