--=======================================================================================
--=
--=  Name: ASCII_WAVE
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

entity ASCII_WAVE is
	port(
		clk:      in   std_logic;
		btnC:     in   std_logic;
		sw:       in   std_logic_vector(15 downto 0);
		seg:      out  std_logic_vector(6 downto 0);
		waveform: out  std_logic
		);
end ASCII_WAVE;

architecture ASCII_WAVE_ARCH of ASCII_WAVE is

	-- Active High Constant
	constant ACTIVE: std_logic := '1';
	
	-- BitEncoder Constants
	constant PULSE_TIME:        positive := 40;
	constant NUM_OF_DATA_BITS:  positive := 24;
	constant CLOCK_FREQUENCY:   positive := 100000000;
	
	-- Internal Connection Signals
    signal transfer:  std_logic_vector(23 downto 0);

    --===================================================================================
    --  BitEncoder                                                              COMPONENT
    --===================================================================================
    component BitEncoder
        generic (
            ACTIVE: std_logic := '1';
            PULSE_TIME:          positive := 400;      -- In ns
            NUM_OF_DATA_BITS:    positive := 24;
            CLOCK_FREQUENCY:     positive := 100000000 -- In Hz
            );
        port (
            reset:    in  std_logic;
            clock:    in  std_logic;
            txEn:     in  std_logic;
            data:     in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
            waveform: out std_logic
            );
    end component;

    --===================================================================================
    --  ColorConverter                                                          COMPONENT
    --===================================================================================
	component ColorConverter
		port (
            charPressed:  in   std_logic_vector(7 downto 0);
            color:        out  std_logic_vector(23 downto 0);
            sevenSegs:    out  std_logic_vector(6 downto 0)  
            );
	end component ColorConverter;

begin

	--===================================================================================
	--  ColorConverter 
	--===================================================================================
	CLR_CNV: ColorConverter
		port map (
			charPressed => sw(7 downto 0),
			color       => transfer,
			sevenSegs   => seg
			);

    --===================================================================================
	--  BitEncoder 
	--===================================================================================
	BIT_EN: BitEncoder
		generic map (
            ACTIVE           => ACTIVE,
            PULSE_TIME       => PULSE_TIME,
            NUM_OF_DATA_BITS => NUM_OF_DATA_BITS,
            CLOCK_FREQUENCY  => CLOCK_FREQUENCY
            )
		port map (
			clock    => clk,
			reset    => btnC,
			txEn     => sw(15),
			data     => transfer,
			waveform => waveform
			);
		
end ASCII_WAVE_ARCH;
