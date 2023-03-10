--==================================================================================
--=
--= Name: LedPosition
--= University: Kennesaw State University
--= Designer: Jaden Zwicker
--=
--=     This component seeks to manage the current position of a led being modified.
--=     Upon the editMode port being assigned an ACTIVE signal the current led's
--=     position will be modifiable and output as currentLedPosition. The two
--=     controls to modify the currentLedPosition are
--=     incrementCurrentLedPositionEnable and decrementCurrentLedPositionEnable and
--=     they perform the operation in their names accordingly.
--=
--=     In the situation of both enable signals being ACTIVE the component will hold
--=     the currentLedPosition.
--=
--=     Upon initialization of this generic component the NUM_OF_LEDS must be
--=     assigned the number of leds to be controlled.
--=
--=     This component loops the currentLedPostion.
--=     ie. When the last possible led is selected and a user enables the increment
--=     signal the position will go back to the beginning led rather than counting
--=     to a non-existent led position.
--=
--=     Led position begins starts at 0.
--=        
--=     NUM_OF_OUTPUT_BITS is the number of bits needed to represent NUM_OF_LEDS in
--=     binary.
--=
--==================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LedPosition is
    generic(
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
        currentLedPosition:                 out std_logic_vector(NUM_OF_OUTPUT_BITS - 1 downto 0)
    );
end LedPosition;

architecture LedPosition_ARCH of LedPosition is

    -- Active High constant implemented for readability.
    constant ACTIVE: std_logic := '1';

    -- Internal Signal (IS) for the currentLedPosition
    signal currentLedPosition_IS: integer range 0 to NUM_OF_LEDS - 1;
    
begin

    process(reset, clock)
    begin
        if (reset = ACTIVE) then
            currentLedPosition_IS <= 0;
        elsif (rising_edge(clock)) then
            if (editMode = not ACTIVE) then
                currentLedPosition_IS <= 0;
                
            elsif (editMode = ACTIVE) then
                if ((incrementCurrentLedPositionEnable and
                     decrementCurrentLedPositionEnable) = ACTIVE) then
                    currentLedPosition_IS <= currentLedPosition_IS;
                    
                elsif (incrementCurrentLedPositionEnable = ACTIVE) then
                    if (currentLedPosition_IS >= NUM_OF_LEDS - 1) then
                        currentLedPosition_IS <= 0;
                    else
                        currentLedPosition_IS <= currentLedPosition_IS + 1;
                    end if;
                    
                elsif (decrementCurrentLedPositionEnable = ACTIVE) then
                    if (currentLedPosition_IS <= 0) then
                        currentLedPosition_IS <= NUM_OF_LEDS - 1;
                    else
                        currentLedPosition_IS <= currentLedPosition_IS - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Assigns the currentLedPosition_IS to the currentLedPosition port.
    -- Hence it is necessary to convert from int to std_logic_vector.
    currentLedPosition <=
    std_logic_vector(to_unsigned(currentLedPosition_IS, currentLedPosition'length));
    
end LedPosition_ARCH;