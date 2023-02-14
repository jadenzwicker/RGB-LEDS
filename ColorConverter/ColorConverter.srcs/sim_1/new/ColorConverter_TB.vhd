----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2023 12:41:08 PM
-- Design Name: 
-- Module Name: ColorConverter_TB - ColorConverter_TB_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ColorConverter_TB is
--  Port ( );
end ColorConverter_TB;

architecture ColorConverter_TB_ARCH of ColorConverter_TB is

begin


end ColorConverter_TB_ARCH;


-------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Create Date: 01/31/2023 10:35:19 AM
-- Module Name: SwitchLeds - SwitchLeds_ARCH
-- 
-- Course Name: CPE 3020/01
-- Lab 2
--
-- Description:
-- This test bench is to fully explore all possible input combinations of 
-- SwitchLeds.vhd. 4 for loops are used to go through the possible combinations
-- of switches while outside of the loops the button inputs are changed.
-- An extra outside loop could be implemented to change the button variables
-- however, that was not chosen for the sake of readability.
--
-- Detailed variable naming explanations and overall function is explanation
-- is in SwitchLeds.vhd file.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SwitchLeds_TB is
end SwitchLeds_TB;

architecture SwitchLeds_TB_ARCH of SwitchLeds_TB is
    --unit-under-test-------------------------------------COMPONENT
    component SwitchLeds
        port (
            ledCount:    in  std_logic_vector(2 downto 0);
            leftButton:  in  std_logic;
            rightButton: in  std_logic;
            leds:        out std_logic_vector(15 downto 0)  
        );
    end component;
    
    --uut-signals-------------------------------------------SIGNALS
    signal ledCount :    std_logic_vector(2 downto 0);
    signal leftButton :  std_logic;
    signal rightButton : std_logic;
    signal leds :        std_logic_vector(15 downto 0);
    
    -- Creating constant for pressed button
    constant PRESSED: std_logic := '1';
    
begin
    --Unit-Under-Test-------------------------------------------UUT
    UUT: SwitchLeds port map(
        ledCount => ledCount,
        leftButton => leftButton,
        rightButton => rightButton,
        leds => leds
    );
    --Switch and Button Driver----------------------------------------PROCESS
    SWITCHS_AND_BUTTONS_DRIVER: process
    begin
        -- Here we set both buttons to 0 and loop through all possible 
        -- combinations for ledCount.
        leftButton  <=  not PRESSED;
        rightButton <=  not PRESSED;
        -- Possible ledCount combinations go from 0 to 7. 
        -- to_unsigned keyword converts the "i" which is an int into the
        -- 3 bit binary representation which is ledCount's data type.
        for i in 0 to 7 loop
            ledCount <= std_logic_vector(to_unsigned(i, ledCount'length));
            wait for 10 ns;
        end loop;
        wait for 10 ns;
        
        -- Here leftButton is set to 1 with rightButton set to 0.
        -- The loop goes through all possible combinations of ledCount.
        leftButton  <=  PRESSED;
        rightButton <=  not PRESSED;
        -- Possible ledCount combinations go from 0 to 7. 
        -- to_unsigned keyword converts the "i" which is an int into the
        -- 3 bit binary representation which is ledCount's data type.
        for i in 0 to 7 loop
            ledCount <= std_logic_vector(to_unsigned(i, ledCount'length));
            wait for 10 ns;
        end loop;
        wait for 10 ns;
        
        -- Here leftButton is set to 0 with rightButton set to 1.
        -- The loop goes through all possible combinations of ledCount.
        leftButton  <=  not PRESSED;
        rightButton <=  PRESSED;
        -- Possible ledCount combinations go from 0 to 7. 
        -- to_unsigned keyword converts the "i" which is an int into the
        -- 3 bit binary representation which is ledCount's data type.
        for i in 0 to 7 loop
            ledCount <= std_logic_vector(to_unsigned(i, ledCount'length));
            wait for 10 ns;
        end loop;
        wait for 10 ns;
        
        -- Here leftButton is set to 1 with rightButton set to 1.
        -- The loop goes through all possible combinations of ledCount.
        leftButton  <=  PRESSED;
        rightButton <=  PRESSED;
        -- Possible ledCount combinations go from 0 to 7. 
        -- to_unsigned keyword converts the "i" which is an int into the
        -- 3 bit binary representation which is ledCount's data type.
        for i in 0 to 7 loop
            ledCount <= std_logic_vector(to_unsigned(i, ledCount'length));
            wait for 10 ns;
        end loop;
        wait;
    end process;
end SwitchLeds_TB_ARCH;