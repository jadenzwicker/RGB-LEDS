--=======================================================================================
--=
--=  Name: LedPosition
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      This component seeks to manage the current position of a led being modified.
--=      Upon the editMode port being assigned an ACTIVE signal the current led's
--=      position will be modifiable and output as currentLedPosition. The two controls
--=      to modify the currentLedPosition are incrementCurrentLedPositionEnable and 
--=      decrementCurrentLedPositionEnable. They perform the operation in their names
--=      accordingly.
--=
--=      In the situation of both enable signals being ACTIVE the component will hold
--=      the currentLedPosition.
--=
--=      This component loops the currentLedPostion.
--=      ie. When the last possible led is selected and a user enables the increment
--=      signal the position will go back to the beginning led rather than counting
--=      to a non-existent led position.
--=
--=      Starting LED Position is 0.
--=        
--=      Signals referencing ports are internal signals and are hence denoted with the
--=      ending 'IS'
--=
--=      Generic input definitions are described as follows:
--=          ACTIVE: a constant that is of type std_logic. Should only be defined as '1'
--=                  or '0' according to an active LOW or HIGH system.
--=
--=          NUM_OF_LEDS: a constant that is of type positive. Describes the physical 
--=                       number of LEDs the system is controlling.
--=
--=          NUM_OF_OUTPUT_BITS: a constant that is of type positive. It defines the 
--=                             number of bits needed to represent NUM_OF_LEDS in binary.
--=
--=======================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LedPosition is
    generic(
        ACTIVE: std_logic := '1';
        NUM_OF_LEDS:        positive := 16;
        NUM_OF_OUTPUT_BITS: positive := 8
        );
    -- All ports are defined as std_logic variants for per standard.
    port(
        reset:                              in  std_logic;
        clock:                              in  std_logic;
        incrementCurrentLedPositionEnable:  in  std_logic;
        decrementCurrentLedPositionEnable:  in  std_logic;
        editMode:                           in  std_logic;
        currentLedPosition:         out std_logic_vector(NUM_OF_OUTPUT_BITS - 1 downto 0)
        );
end LedPosition;

architecture LedPosition_ARCH of LedPosition is

    -- Internal Signal (IS) for the currentLedPosition
    signal currentLedPositionIS: integer range 0 to NUM_OF_LEDS - 1;
    
begin

    process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentLedPositionIS <= 0;
        elsif (rising_edge(clock)) then
            if (editMode = not ACTIVE) then
                currentLedPositionIS <= 0;
                
            elsif (editMode = ACTIVE) then
                if ((incrementCurrentLedPositionEnable and
                     decrementCurrentLedPositionEnable) = ACTIVE) then
                    currentLedPositionIS <= currentLedPositionIS;
                    
                elsif (incrementCurrentLedPositionEnable = ACTIVE) then
                    if (currentLedPositionIS >= NUM_OF_LEDS - 1) then
                        currentLedPositionIS <= 0;
                    else
                        currentLedPositionIS <= currentLedPositionIS + 1;
                    end if;
                    
                elsif (decrementCurrentLedPositionEnable = ACTIVE) then
                    if (currentLedPositionIS <= 0) then
                        currentLedPositionIS <= NUM_OF_LEDS - 1;
                    else
                        currentLedPositionIS <= currentLedPositionIS - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Assigns the currentLedPosition_IS to the currentLedPosition port.
    -- Hence it is necessary to convert from int to std_logic_vector.
    currentLedPosition <=
    std_logic_vector(to_unsigned(currentLedPositionIS, currentLedPosition'length));
    
end LedPosition_ARCH;