-------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Module Name: ColorConverter - ColorConverter_ARCH
-- 
-- Course Name: CPE 3020/01
-- Lab 3
--
-- Description:
-- Creating a component to convert ASCII char code into a defined 24 bit color.
-- Upon color choice 7 segment dispaly with show the char input.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ColorConverter is
    port (
        -- ASCII Code value relating to the char that user input
        charPressed:  in   std_logic_vector(7 downto 0);
        -- 24 bit color code relating to char pressed
        color:        out  std_logic_vector(23 downto 0);
        -- seven segment display output that displays color selected
        sevenSegs:    out  std_logic_vector(6 downto 0)  
     );
end ColorConverter;

architecture ColorConverter_ARCH of ColorConverter is
    
    -- Creating constants for ASCII char values
    constant r:    std_logic_vector(7 downto 0) := "01110010";
    constant o:    std_logic_vector(7 downto 0) := "01101111";
    constant y:    std_logic_vector(7 downto 0) := "01111001";
    constant g:    std_logic_vector(7 downto 0) := "01100101";
    constant b:    std_logic_vector(7 downto 0) := "01100010";
    constant i:    std_logic_vector(7 downto 0) := "01101001";
    constant v:    std_logic_vector(7 downto 0) := "01110100";
    constant h:    std_logic_vector(7 downto 0) := "01100111";
    constant k:    std_logic_vector(7 downto 0) := "01101011";
        
    -- Creating Constants for 24 Bit color code (hex color code in binary)
    constant RED:     std_logic_vector(23 downto 0) := "111111110000000000000000";
    constant ORANGE:  std_logic_vector(23 downto 0) := "111111111010010100000000";
    constant YELLOW:  std_logic_vector(23 downto 0) := "111111111111111100000000";
    constant GREEN:   std_logic_vector(23 downto 0) := "000000001111111100000000";
    constant BLUE:    std_logic_vector(23 downto 0) := "000000000000000011111111";
    constant INDIGO:  std_logic_vector(23 downto 0) := "010010110000000010000010";
    constant VIOLET:  std_logic_vector(23 downto 0) := "100011110000000011111111";
    constant WHITE:   std_logic_vector(23 downto 0) := "111111111111111111111111";
    constant BLACK:   std_logic_vector(23 downto 0) := "000000000000000000000000";
        
    -- Creating Constants for 7segment char displays
    -- Bits go in the order "abcdefg"
    -- Active Low
    constant RED_7SEG:      std_logic_vector(6 downto 0) := not "0000101";
    constant ORANGE_7SEG:   std_logic_vector(6 downto 0) := not "0011101";
    constant YELLOW_7SEG:   std_logic_vector(6 downto 0) := not "0111011";
    constant GREEN_7SEG:    std_logic_vector(6 downto 0) := not "1011110";
    constant BLUE_7SEG:     std_logic_vector(6 downto 0) := not "0011111";
    constant INDIGO_7SEG:   std_logic_vector(6 downto 0) := not "0000110";
    constant VIOLET_7SEG:   std_logic_vector(6 downto 0) := not "0011100";
    constant WHITE_7SEG:    std_logic_vector(6 downto 0) := not "0010111";
    constant BLACK_7SEG:    std_logic_vector(6 downto 0) := not "0110111";
    constant BLANK_7SEG:    std_logic_vector(6 downto 0) := not "0000000";
        
begin

    ASCII_TO_24BIT: with charPressed select
        color <= RED     when r,         
                 ORANGE  when o,
                 YELLOW  when y,
                 GREEN   when g,
                 BLUE    when b,
                 INDIGO  when i,
                 VIOLET  when v,
                 WHITE   when h,
                 BLACK   when k,        -- not needed but added for readability
                 BLACK   when others;                           -- default case
                 
    ASCII_TO_7SEG: with charPressed select
        sevenSegs <= RED_7SEG      when r,
                     ORANGE_7SEG   when o,
                     YELLOW_7SEG   when y,
                     GREEN_7SEG    when g,
                     BLUE_7SEG     when b,
                     INDIGO_7SEG   when i,
                     VIOLET_7SEG   when v,
                     WHITE_7SEG    when h,
                     BLACK_7SEG    when k,
                     BLANK_7SEG    when others;  -- 7seg will not show anything
                                                           -- for unknown input
end ColorConverter_ARCH;
