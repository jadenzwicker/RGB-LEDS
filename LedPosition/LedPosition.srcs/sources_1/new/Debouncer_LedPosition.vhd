library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Debouncer_LedPosition is
    port (
    	reset:    in  std_logic;
        clock:    in  std_logic;
    	input:  in  std_logic;
    	decLed:  in  std_logic;
    	edit:  in  std_logic;
        currentLedPosition:  out std_logic_vector(7 downto 0)
    );
end Debouncer_LedPosition;

architecture Debouncer_LedPosition_ARCH of Debouncer_LedPosition is
	constant ACTIVE:  std_logic := '1';

    signal transfer: std_logic;

    --============================================================================
    --  Debouncer                                                        COMPONENT
    --============================================================================
    component Debouncer
        port (
            reset:          in  std_logic;
            clock:          in  std_logic;
            input:          in  std_logic;
            debouncedInput: out std_logic
        );
	end component Debouncer;
	
	--============================================================================
    --  LedPosition                                                      COMPONENT
    --============================================================================
    component LedPosition
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
	end component LedPosition;

begin

    DEBOUNCE: Debouncer
		port map (
			clock           => clock,
			reset           => reset,
			input           => input,
			debouncedInput  => transfer
			);	

    --============================================================================
	--  LedPosition component being initalized as LED_POSITION_DRIVER
	--============================================================================
	LED_POSITION_DRIVER: LedPosition
		generic map (
            NUM_OF_LEDS        => 16,
            NUM_OF_OUTPUT_BITS => 8
        )
        port map(
            reset                             => reset,
            clock                             => clock,
            incrementCurrentLedPositionEnable => transfer,
            decrementCurrentLedPositionEnable => decLed,
            editMode                          => edit,
            currentLedPosition                => currentLedPosition
        );

end Debouncer_LedPosition_ARCH;