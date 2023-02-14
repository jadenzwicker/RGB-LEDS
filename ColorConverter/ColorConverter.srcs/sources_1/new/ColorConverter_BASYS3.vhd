----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/14/2023 12:38:31 PM
-- Design Name: 
-- Module Name: ColorConverter_BASYS3 - ColorConverter_BASYS3_ARCH
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

entity ColorConverter_BASYS3 is
--  Port ( );
end ColorConverter_BASYS3;

architecture ColorConverter_BASYS3_ARCH of ColorConverter_BASYS3 is

begin


end ColorConverter_BASYS3_ARCH;


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
           sw :    in  std_logic_vector (2 downto 0);
           btnL :  in  std_logic;
           btnR :  in  std_logic;
           led :   out std_logic_vector (15 downto 0)
    );
end ColorConverter_BASYS3;

architecture ColorConverter_BASYS3_ARCH of ColorConverter_BASYS3 is
    -- This component is used to pull in the ports from the ColorConverter design.
    component ColorConverter
        port (
                ledCount:     in  std_logic_vector(2 downto 0);  --switch inputs (active high)
                leftButton:   in  std_logic;
                rightButton:  in  std_logic;
                leds:         out std_logic_vector(15 downto 0)  --led outputs (active low)
        );
    end component;
begin
    -- Mapping the config file pins to the ports in ColorConverter design.
    MY_DESIGN: ColorConverter port map (
        ledCount => sw,
        leftButton => btnL,
        rightButton => btnR,
        leds => led
    );
end ColorConverter_BASYS3_ARCH;