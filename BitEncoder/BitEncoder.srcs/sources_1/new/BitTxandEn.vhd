--=======================================================================================
--=
--=  Name: BitTxandEn
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=  Ties ColorConverter to BitEncoder which allows for an 8 bit ASCII value to be 
--=  converted into a 3 pulse encoded waveform.       
--=      
--=======================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitTxandEn is
	port(
		clock:      in   std_logic;
		reset:      in   std_logic;
		txStart:    in   std_logic;
		color:      in   std_logic_vector(23 downto 0);
		waveform:   out  std_logic;
		bitTxComplete: out std_logic
		);
end BitTxandEn;

architecture BitTxandEn_ARCH of BitTxandEn is

	-- Active High Constant
	constant ACTIVE: std_logic := '1';
	
	-- BitEncoder Constants
	constant PULSE_TIME:        positive := 400;
	constant NUM_OF_DATA_BITS:  positive := 24;
	constant CLOCK_FREQUENCY:   positive := 100000000;
	
	-- Internal Connection Signals
    signal transferBit:  std_logic;
    signal txEnIC:       std_logic;
    signal txDoneIC:     std_logic;

    --===================================================================================
    --  BitEncoder                                                              COMPONENT
    --===================================================================================
    component BitEncoder
        generic (
            ACTIVE: std_logic := '1';
            PULSE_TIME:          positive := 400;      -- In ns
            CLOCK_FREQUENCY:     positive := 100000000 -- In Hz
            );
        port (
            reset:    in  std_logic;
            clock:    in  std_logic;
            txEn:     in  std_logic;
            dataBit:  in  std_logic;
            waveform: out std_logic;
            txDone:   out std_logic
            );
    end component;

    --===================================================================================
    --  BitTransmitter                                                          COMPONENT
    --===================================================================================
	component BitTransmitter
        generic (
            ACTIVE: std_logic := '1';
            NUM_OF_DATA_BITS: positive := 24
            );
        port (
            reset:         in  std_logic;
            clock:         in  std_logic;
            txStart:       in  std_logic;
            txBitDone:     in  std_logic;
            data:          in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
            currentBit:    out std_logic;
            txEn:          out std_logic;
            bitTxComplete: out std_logic
            );
    end component;

begin

	--===================================================================================
	--  BitTransmitter 
	--===================================================================================
	BIT_TX: BitTransmitter
		generic map (
            ACTIVE           => ACTIVE,
            NUM_OF_DATA_BITS => NUM_OF_DATA_BITS
            )
        port map(
            reset      => reset,
            clock      => clock,
            txStart    => txStart,
            txBitDone  => txDoneIC,
            data       => color,
            currentBit => transferBit,
            txEn       => txEnIC,
            bitTxComplete => bitTxComplete
            );

    --===================================================================================
	--  BitEncoder 
	--===================================================================================
	BIT_EN: BitEncoder
		generic map (
            ACTIVE           => ACTIVE,
            PULSE_TIME       => PULSE_TIME,
            CLOCK_FREQUENCY  => CLOCK_FREQUENCY
            )
		port map (
			clock    => clock,
			reset    => reset,
			txEn     => txEnIC,
			dataBit  => transferBit,
			waveform => waveform,
			txDone   => txDoneIC
			);
		
end BitTxandEn_ARCH;
