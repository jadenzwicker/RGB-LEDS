library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--==================================================================================
--=
--=  Name: rgb_led_package.vhd
--=  Designer: Jaden Zwicker
--=
--=      This package contains needed components and functions for the RGB_LEDS 
--=      project
--=
--==================================================================================

package rgb_led_package is

    -----------------------------------------------------------------------FUNCTIONS
    function to_bcd_8bit( inputValue: integer) return std_logic_vector;


    ----------------------------------------------------------------------PROCEDURES
    procedure count_to_99( signal  reset:    in     std_logic;
                           signal  clock:    in     std_logic;
                           signal  countEn:  in     std_logic;
                           signal  count:    inout  integer);


    --==================================================SevenSegmentDriver COMPONENT
    component SevenSegmentDriver is
        port (
            reset: in std_logic;
            clock: in std_logic;
            digit3: in std_logic_vector(3 downto 0);
            digit2: in std_logic_vector(3 downto 0);
            digit1: in std_logic_vector(3 downto 0);
            digit0: in std_logic_vector(3 downto 0);
            blank3: in std_logic;
            blank2: in std_logic;
            blank1: in std_logic;
            blank0: in std_logic;
            sevenSegs: out std_logic_vector(6 downto 0);
            anodes:    out std_logic_vector(3 downto 0)
        );
    end component SevenSegmentDriver;


    --=======================================================LevelDetector COMPONENT
    component LevelDetector is
        port (
            reset:     in  std_logic;
            clock:     in  std_logic;
            trigger:   in  std_logic;
            pulseOut:  out std_logic
        );
    end component LevelDetector;

    --==============================================================================
    --  Name: SynchronizerChain Component 
    --  Designer: Scott Tippens
    --  Description: 
    --      This component implements a synchronization chain for use with asynchronous 
    --      inputs or clock-domain crossing signals.  The size of the synchronization
    --      chain is determined by the CHAIN_SIZE generic parameter.
    --==============================================================================
    component SynchronizerChain is
        generic (CHAIN_SIZE: positive);
        port (
            reset:    in  std_logic;
            clock:    in  std_logic;
            asyncIn:  in  std_logic;
            syncOut:  out std_logic
        );
    end component SynchronizerChain;

end package;


package body rgb_led_package is

    constant ACTIVE: std_logic := '1';


    --======================================================================FUNCTION
    --  to_bcd_8bit()
    --      Convert the input integer value to a two digit BCD representation.
    --      This function limits the return value to 99.
    --==============================================================================
    function to_bcd_8bit( inputValue: integer) return std_logic_vector is
        variable tensValue: integer;
        variable onesValue: integer;
    begin
        if (inputValue < 99) then
            tensValue := inputValue  /  10;
            onesValue := inputValue mod 10;
        else
            tensValue := 9;
            onesValue := 9;
        end if;

        return std_logic_vector(to_unsigned(tensValue, 4)) &  std_logic_vector(to_unsigned(onesValue, 4));
    end function to_bcd_8bit;


    --=====================================================================PROCEDURE
    --  count_to_99()
    --      Implements a counter that will count from 0 to 99.  Once the count
    --      reaches 99 it must be reset to return to 0.
    --==============================================================================
    procedure count_to_99( signal  reset:    in  std_logic;
                           signal  clock:    in  std_logic;
                           signal  countEn:  in std_logic;
                           signal  count:    inout integer) is
    begin
        if (reset=ACTIVE) then
            count <= 0;
        elsif (rising_edge(clock)) then
            if (countEn=ACTIVE) then
                if (count>=0 and count<99) then
                    count <= count + 1;
                else
                    count <= 99;
                end if;
            end if;
        end if;

    end procedure count_to_99;


end package body rgb_led_package;