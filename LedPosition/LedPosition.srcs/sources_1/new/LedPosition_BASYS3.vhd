--=======================================================================================
--=
--=  Name: LedPosition_BASYS3
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      Basys3 wrapper for LedPosition component. Utilizes other componets such as:
--=          SynchronizerChain
--=          Debouncer
--=          SevenSegmentDriver
--=
--=      ~    Asynchronous signals are denoted by the ending 'Async'
--=      ~    Synchronous signals are denoted by the ending 'Sync'
--=      ~    Raw or unbounced signals are denoted by the ending 'Unbounce'
--=      ~    Debounced signals are denoted by the ending 'Debounced'
--=      ~    Level signals are denoted by the ending 'Level'
--=      ~    Pulse/Single Press signals are denoted by the ending 'Enable'
--=      ~    A slower/enable clock signal is denoted by the ending 'Pulse'
--=      ~    Signals referencing ports are internal signals and are hence denoted with 
--=           the ending 'IS'
--=
--=      Component functionality seeks to use hardware to test the potential of the 
--=      system to maintain a theoretical LED's position. When in editMode(sw(0)) the 
--=      system will allow the LED's position to be modified by the left(btnL) and 
--=      right(btnR) buttons. All other cases the LED's position will be at 0.
--=
--=      This sets up future capability to modeify each selected LED.
--=      
--=======================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LedPosition_BASYS3 is
	port(
		clk:   in   std_logic;
		btnC:  in   std_logic;
		btnR:  in   std_logic;
		btnL:  in   std_logic;
		sw:    in   std_logic_vector(15 downto 0);
		seg:   out  std_logic_vector(6 downto 0);
		led:   out  std_logic_vector(15 downto 0);
		an:    out  std_logic_vector(3 downto 0)
		);
end LedPosition_BASYS3;

architecture LedPosition_BASYS3_ARCH of LedPosition_BASYS3 is

	-- Active High Constant
	constant ACTIVE: std_logic := '1';
	
	-- LedPosition Constants
	constant NUM_OF_LEDS: positive := 16;
	constant NUM_OF_OUTPUT_BITS: positive := 8;
	
	-- Debouncer Constants
    constant TIME_BETWEEN_PULSES: positive := 15;
    constant CLOCK_FREQUENCY:     positive := 100000000;
    
    -- SynchronizerChain Constants
    constant CHAIN_SIZE: positive := 2;

	-- Internal Connection Signals
    signal incrementCurrentLedPositionSync:  std_logic;
    signal decrementCurrentLedPositionSync:  std_logic;
    signal editModeSync:                     std_logic;
    
    signal incrementCurrentLedPositionEnable:  std_logic;
    signal decrementCurrentLedPositionEnable:  std_logic;
    
    signal currentLedPosition: std_logic_vector(NUM_OF_OUTPUT_BITS - 1 downto 0);
    
    signal digit0:     std_logic_vector(3 downto 0);
    signal digit1:     std_logic_vector(3 downto 0);
    signal tempDigits: std_logic_vector(7 downto 0);
    
    signal sevenSegs: std_logic_vector(6 downto 0);
    signal anodes:    std_logic_vector(3 downto 0);

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

begin

	--===================================================================================
	--  SynchronizerChain component being initalized as SYNC_BTNR
	--===================================================================================
	SYNC_BTNR: SynchronizerChain
		generic map (
		    CHAIN_SIZE => CHAIN_SIZE
		    )
		port map (
			clock    => clk,
			reset    => btnC,
			asyncIn  => btnR,
			syncOut  => incrementCurrentLedPositionSync
			);

    --===================================================================================
	--  SynchronizerChain component being initalized as SYNC_BTNL
	--===================================================================================
	SYNC_BTNL: SynchronizerChain
		generic map (
		    CHAIN_SIZE => CHAIN_SIZE
		    )
		port map (
			clock    => clk,
			reset    => btnC,
			asyncIn  => btnL,
			syncOut  => decrementCurrentLedPositionSync
			);
			
	--===================================================================================
	--  SynchronizerChain component being initalized as SYNC_SW0
	--===================================================================================
	SYNC_SW0: SynchronizerChain
		generic map (
		    CHAIN_SIZE => CHAIN_SIZE
		    )
		port map (
			clock    => clk,
			reset    => btnC,
			asyncIn  => sw(0),
			syncOut  => editModeSync
			);
			
	--===================================================================================
	--  Debouncer component being initalized as DEBOUNCE_INC
	--===================================================================================
	DEBOUNCE_INC: Debouncer
	    generic map (
            ACTIVE              => ACTIVE,
            TIME_BETWEEN_PULSES => TIME_BETWEEN_PULSES,
            CLOCK_FREQUENCY     => CLOCK_FREQUENCY
            )
		port map (
			clock           => clk,
			reset           => btnC,
			input           => incrementCurrentLedPositionSync,
			debouncedOutput => incrementCurrentLedPositionEnable
			);		

    --===================================================================================
	--  Debouncer component being initalized as DEBOUNCE_DEC
	--===================================================================================
	DEBOUNCE_DEC: Debouncer
	    generic map (
            ACTIVE              => ACTIVE,
            TIME_BETWEEN_PULSES => TIME_BETWEEN_PULSES,
            CLOCK_FREQUENCY     => CLOCK_FREQUENCY
            )
		port map (
			clock           => clk,
			reset           => btnC,
			input           => decrementCurrentLedPositionSync,
			debouncedOutput => decrementCurrentLedPositionEnable
			);
			
	--===================================================================================
	--  LedPosition component being initalized as LED_POSITION_DRIVER
	--===================================================================================
	LED_POSITION_DRIVER: LedPosition
		generic map (
            NUM_OF_LEDS        => NUM_OF_LEDS,
            NUM_OF_OUTPUT_BITS => NUM_OF_OUTPUT_BITS
            )
        port map(
            reset                             => btnC,
            clock                             => clk,
            incrementCurrentLedPositionEnable => incrementCurrentLedPositionEnable,
            decrementCurrentLedPositionEnable => decrementCurrentLedPositionEnable,
            editMode                          => editModeSync,
            currentLedPosition                => currentLedPosition
            );		
			
	--===================================================================================
	--  Implements to_bcd_8bit() function
	--      currentLedPosition is converted to an integer then to BCD values.
	--      Each bcd digit is then assigned accordingly. 
	--===================================================================================
	tempDigits <= to_bcd_8bit(to_integer(unsigned(currentLedPosition)));
	digit1 <= tempDigits(7 downto 4);    -- tens place
	digit0 <= tempDigits(3 downto 0);    -- ones place
	
	--===================================================================================
	--  SevenSegmentDriver component being initalized as SEVEN_SEG_DRIVER
	--===================================================================================
	SEVEN_SEG_DRIVER: SevenSegmentDriver
		port map (
			clock     => clk,
			reset     => btnC,
			digit0    => digit0,
			digit1    => digit1,
			digit2    => (others=>not ACTIVE),
			digit3    => (others=>not ACTIVE),
			blank0    => not ACTIVE,
			blank1    => not ACTIVE,
			blank2    => ACTIVE,
			blank3    => ACTIVE,
			sevenSegs => sevenSegs,
			anodes    => anodes
			);
			
	-- Assigning output ports		
	seg <= sevenSegs;
	an  <= anodes;					
					
end LedPosition_BASYS3_ARCH;