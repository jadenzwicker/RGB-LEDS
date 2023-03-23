library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=======================================================================================
--=
--=  Package for RBG_LEDS project
--=     To include in a file that is in the same working directory include, 
--=     ~   use work.rgb_leds_package.all;
--=     under the default ieee packages brought in.
--=
--=======================================================================================

package rgb_leds_package is

	--===================================================================================
    --  to_bcd_8bit                                                              FUNCTION
    --===================================================================================
	function to_bcd_8bit(inputValue: integer) return std_logic_vector;


	--===================================================================================
    --  LedPosition                                                             COMPONENT
    --===================================================================================
    component LedPosition
		generic(
            NUM_OF_LEDS:        positive := 16;
            NUM_OF_OUTPUT_BITS: positive := 8
            );
        port(
            reset:                              in  std_logic;
            clock:                              in  std_logic;
            incrementCurrentLedPositionEnable:  in  std_logic;
            decrementCurrentLedPositionEnable:  in  std_logic;
            editMode:                           in  std_logic;
            currentLedPosition:     out std_logic_vector(NUM_OF_OUTPUT_BITS - 1 downto 0)
            );
	end component LedPosition;


    --===================================================================================
    --  SynchronizerChain                                                       COMPONENT
    --===================================================================================
	component SynchronizerChain
		generic (
		    CHAIN_SIZE: positive
		    );
        port (
            reset:    in  std_logic;
            clock:    in  std_logic;
            asyncIn:  in  std_logic;
            syncOut:  out std_logic
            );
	end component SynchronizerChain;


    --===================================================================================
    --  Debouncer                                                               COMPONENT
    --===================================================================================
    component Debouncer
        generic (
            ACTIVE: std_logic := '1';
            TIME_BETWEEN_PULSES: positive := 12;       -- In Hz
            CLOCK_FREQUENCY:     positive := 100000000 -- In Hz
            );
        port (
            reset:           in  std_logic;
            clock:           in  std_logic;
            input:           in  std_logic;
            debouncedOutput: out std_logic
            );
    end component;
	
	
	--===================================================================================
    --  SevenSegmentDriver                                                      COMPONENT
    --===================================================================================
	component SevenSegmentDriver
		port(
            reset: in std_logic;
            clock: in std_logic;
    
            digit3: in std_logic_vector(3 downto 0);    --leftmost digit
            digit2: in std_logic_vector(3 downto 0);    --2nd from left digit
            digit1: in std_logic_vector(3 downto 0);    --3rd from left digit
            digit0: in std_logic_vector(3 downto 0);    --rightmost digit
    
            blank3: in std_logic;    --leftmost digit
            blank2: in std_logic;    --2nd from left digit
            blank1: in std_logic;    --3rd from left digit
            blank0: in std_logic;    --rightmost digit
    
            sevenSegs: out std_logic_vector(6 downto 0);    --MSB=g, LSB=a
            anodes:    out std_logic_vector(3 downto 0)    --MSB=leftmost digit
            );
	end component SevenSegmentDriver;

end package;


package body rgb_leds_package is

    --===================================================================================
    --  GLOBAL CONSTANTS USED THROUGHOUT THE PROJECT                             CONSTANT
    --      Do not redefine any of these constants in sources using this package.
    --      Simply apply this constant in them and change the value here.
    --===================================================================================
	constant ACTIVE: std_logic := '1';


	--===================================================================================
    --  to_bcd_8bit()                                                            FUNCTION
    --      Convert the input integer value to a two digit BCD representation.
    --      This function limits the return value to 99.
    --===================================================================================
    function to_bcd_8bit(inputValue: integer) return std_logic_vector is
        variable tensValue: integer;
        variable onesValue: integer;
    begin
        if (inputValue < 99) then
            tensValue := inputValue / 10;
            onesValue := inputValue mod 10;
        else
            tensValue := 9;
            onesValue := 9;
        end if;
        return std_logic_vector(to_unsigned(tensValue, 4))
               & std_logic_vector(to_unsigned(onesValue, 4));
    end to_bcd_8bit;


end package body rgb_leds_package;