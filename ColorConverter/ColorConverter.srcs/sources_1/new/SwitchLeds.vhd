-------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jaden Zwicker
-- 
-- Create Date: 01/31/2023 09:01:19 AM
-- Module Name: SwitchLeds - SwitchLeds_ARCH
-- 
-- Course Name: CPE 3020/01
-- Lab 2
--
-- Description:
-- This program sets out to illuminate a group of 16 leds corresponding to user 
-- input. The user has 3 switches they can use to input a binary number.
-- The number they input will determine the amount of leds illuminated in a bar 
-- fashion. The user also has control over a left and right button joystick. 
-- When the user pressed the left button the leds will count or display starting
-- at the left side and vice versa for the right. In the case of both buttons
-- being pressed, both sides of the total 16 leds will fill up to the inputted
-- value. A maximum of 14 leds can be lit in the case of 111 being input on 
-- the 3 switches and both buttons being pressed. These 14 lit leds would fill
-- from the outside going in. 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SwitchLeds is
    port (
        -- ledCount is determined from physical switches which are active high
        ledCount:    in  std_logic_vector(2 downto 0);
        -- Button presses are active high
        leftButton:  in  std_logic;
        rightButton: in  std_logic;
        -- Leds output are active high
        leds:        out std_logic_vector(15 downto 0)  
     );
end SwitchLeds;

architecture SwitchLeds_ARCH of SwitchLeds is
    -- These signals are to conjoin ledCount and the button presses to be used later
    signal ledCountLeft:  std_logic_vector(3 downto 0);
    signal ledCountRight: std_logic_vector(3 downto 0);
    -- The total 16 bit led bar must be split up into two vectors each relating to 
    -- the button pressed.
    signal leftLeds:      std_logic_vector(7 downto 0);
    signal rightLeds:     std_logic_vector(7 downto 0);
    
    -- Creating constants for the Lit Led bars.
    constant LEFT_NO_LED_LIT:    std_logic_vector(7 downto 0) := "00000000";
    constant LEFT_ONE_LED_LIT:   std_logic_vector(7 downto 0) := "10000000";
    constant LEFT_TWO_LED_LIT:   std_logic_vector(7 downto 0) := "11000000";
    constant LEFT_THREE_LED_LIT: std_logic_vector(7 downto 0) := "11100000";
    constant LEFT_FOUR_LED_LIT:  std_logic_vector(7 downto 0) := "11110000";
    constant LEFT_FIVE_LED_LIT:  std_logic_vector(7 downto 0) := "11111000";
    constant LEFT_SIX_LED_LIT:   std_logic_vector(7 downto 0) := "11111100";
    constant LEFT_SEVEN_LED_LIT: std_logic_vector(7 downto 0) := "11111110";
    
    constant RIGHT_NO_LED_LIT:    std_logic_vector(7 downto 0) := "00000000";
    constant RIGHT_ONE_LED_LIT:   std_logic_vector(7 downto 0) := "00000001";
    constant RIGHT_TWO_LED_LIT:   std_logic_vector(7 downto 0) := "00000011";
    constant RIGHT_THREE_LED_LIT: std_logic_vector(7 downto 0) := "00000111";
    constant RIGHT_FOUR_LED_LIT:  std_logic_vector(7 downto 0) := "00001111";
    constant RIGHT_FIVE_LED_LIT:  std_logic_vector(7 downto 0) := "00011111";
    constant RIGHT_SIX_LED_LIT:   std_logic_vector(7 downto 0) := "00111111";
    constant RIGHT_SEVEN_LED_LIT: std_logic_vector(7 downto 0) := "01111111";
    
    -- Creating constants for pressed buttons and led count.
    constant BUTTON_PRESSED_LED_COUNT_0: std_logic_vector(3 downto 0) := "1000";
    constant BUTTON_PRESSED_LED_COUNT_1: std_logic_vector(3 downto 0) := "1001";
    constant BUTTON_PRESSED_LED_COUNT_2: std_logic_vector(3 downto 0) := "1010";
    constant BUTTON_PRESSED_LED_COUNT_3: std_logic_vector(3 downto 0) := "1011";
    constant BUTTON_PRESSED_LED_COUNT_4: std_logic_vector(3 downto 0) := "1100";
    constant BUTTON_PRESSED_LED_COUNT_5: std_logic_vector(3 downto 0) := "1101";
    constant BUTTON_PRESSED_LED_COUNT_6: std_logic_vector(3 downto 0) := "1110";
    constant BUTTON_PRESSED_LED_COUNT_7: std_logic_vector(3 downto 0) := "1111";
    
begin
    -- These two signals combine the ledCount variable with either button press.
    -- This is to allow for only 1 input into the Selected Signal Assignment Statement.
    -- The most significant bit in the signals refers to the associated button.
    ledCountLeft  <= leftButton & ledCount;
    ledCountRight <= rightButton & ledCount;
    -- The two sides of the led bar are combined into the total 16 bit bar for output.
    leds <= leftLeds & rightLeds;
    
    LEFT_PATTERN: with ledCountLeft select
        -- The left leds must illuminate from left to right
        leftLeds <= LEFT_NO_LED_LIT    when BUTTON_PRESSED_LED_COUNT_0,         
                    LEFT_ONE_LED_LIT   when BUTTON_PRESSED_LED_COUNT_1,            
                    LEFT_TWO_LED_LIT   when BUTTON_PRESSED_LED_COUNT_2,             
                    LEFT_THREE_LED_LIT when BUTTON_PRESSED_LED_COUNT_3,             
                    LEFT_FOUR_LED_LIT  when BUTTON_PRESSED_LED_COUNT_4,            
                    LEFT_FIVE_LED_LIT  when BUTTON_PRESSED_LED_COUNT_5,             
                    LEFT_SIX_LED_LIT   when BUTTON_PRESSED_LED_COUNT_6,            
                    LEFT_SEVEN_LED_LIT when BUTTON_PRESSED_LED_COUNT_7,             
                    -- all other cases emit 0, includes when the button bit is 0
                    LEFT_NO_LED_LIT when others;
                 
    RIGHT_PATTERN: with ledCountRight select
       -- Due to this being the right leds they can illuminate starting at the right
       rightLeds <= RIGHT_NO_LED_LIT    when BUTTON_PRESSED_LED_COUNT_0,       
                    RIGHT_ONE_LED_LIT   when BUTTON_PRESSED_LED_COUNT_1,             
                    RIGHT_TWO_LED_LIT   when BUTTON_PRESSED_LED_COUNT_2,             
                    RIGHT_THREE_LED_LIT when BUTTON_PRESSED_LED_COUNT_3,             
                    RIGHT_FOUR_LED_LIT  when BUTTON_PRESSED_LED_COUNT_4,             
                    RIGHT_FIVE_LED_LIT  when BUTTON_PRESSED_LED_COUNT_5,             
                    RIGHT_SIX_LED_LIT   when BUTTON_PRESSED_LED_COUNT_6,             
                    RIGHT_SEVEN_LED_LIT when BUTTON_PRESSED_LED_COUNT_7,            
                    -- all other cases emit 0, includes when the button bit is 0
                    RIGHT_NO_LED_LIT when others;  
end SwitchLeds_ARCH;