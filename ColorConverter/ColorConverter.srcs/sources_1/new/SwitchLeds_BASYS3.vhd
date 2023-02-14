----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Create Date: 02/7/2023 09:01:19 AM
-- Module Name: SwitchLeds_BASYS3 - SwitchLeds_BASYS3_ARCH
-- 
-- Course Name: CPE 3020/01
-- Lab 2
-- 
--      Wrapper file for SwitchLeds component using the basys3 board
--      configured to use the first three switches, left and right joystick 
--      buttons, and all 16 leds.
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SwitchLeds_BASYS3 is
    -- Here we define the ports from the default basys3 config file.
    -- Names must match config file names since we are porting from there.
    port (  
           sw :    in  std_logic_vector (2 downto 0);
           btnL :  in  std_logic;
           btnR :  in  std_logic;
           led :   out std_logic_vector (15 downto 0)
    );
end SwitchLeds_BASYS3;

architecture SwitchLeds_BASYS3_ARCH of SwitchLeds_BASYS3 is
    -- This component is used to pull in the ports from the SwitchLeds design.
    component SwitchLeds
        port (
                ledCount:     in  std_logic_vector(2 downto 0);  --switch inputs (active high)
                leftButton:   in  std_logic;
                rightButton:  in  std_logic;
                leds:         out std_logic_vector(15 downto 0)  --led outputs (active low)
        );
    end component;
begin
    -- Mapping the config file pins to the ports in SwitchLeds design.
    MY_DESIGN: SwitchLeds port map (
        ledCount => sw,
        leftButton => btnL,
        rightButton => btnR,
        leds => led
    );
end SwitchLeds_BASYS3_ARCH;