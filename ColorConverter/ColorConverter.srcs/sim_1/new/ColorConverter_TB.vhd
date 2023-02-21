-------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Module Name: ColorConverter - ColorConverter_ARCH
-- 
-- Course Name: CPE 3020/01
-- Lab 2
--
-- Description:
-- This test bench is to fully explore all possible input combinations of 
-- ColorConverter.vhd. 
--
-- Detailed variable naming explanations and overall function is explained
-- in ColorConverter.vhd file.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ColorConverter_TB is
end ColorConverter_TB;

architecture ColorConverter_TB_ARCH of ColorConverter_TB is
    --unit-under-test-------------------------------------COMPONENT
    component ColorConverter
        port (
            charPressed:  in   std_logic_vector(7 downto 0);
            color:        out  std_logic_vector(23 downto 0);
            sevenSegs:    out  std_logic_vector(6 downto 0)
        );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal charPressed:  std_logic_vector(7 downto 0);
    signal color:        std_logic_vector(23 downto 0);
    signal sevenSegs:    std_logic_vector(6 downto 0);
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: ColorConverter port map(
        charPressed => charPressed,
        color       => color,
        sevenSegs   => sevenSegs
    );
    
    --Switch and Button Driver----------------------------------------PROCESS
    CHAR_PRESSED_DRIVER: process
    begin
        -- Possible charCount combinations go from 0 to 255 decimal. 
        -- to_unsigned keyword converts the "i" which is an int into the
        -- 8 bit binary representation which is charPressed's data type.
        for i in 0 to (2 ** charPressed'length - 1) loop
            -- increment charPressed
            charPressed <= std_logic_vector(to_unsigned(i, charPressed'length));
            wait for 1 ns;
        end loop;
        -- Ends Simulation
        report "simulation finished successfully" severity FAILURE;
    end process;
end ColorConverter_TB_ARCH;
