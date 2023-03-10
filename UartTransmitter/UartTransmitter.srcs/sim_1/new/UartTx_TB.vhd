library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--*****************************************************************************
--*
--* Name: UartTx Test Bench
--* Designer: Scott Tippens
--*
--*     Test the UartRx component by simulating the transmission of three values
--*     (X"A5", X"5A", and X"FF").  The test conditions are for a clock rate
--*     of 100 MHz and baud rate of 115200.
--*
--*****************************************************************************

entity UartTx_TB is
end UartTx_TB;



architecture UartTx_TB_ARCH of UartTx_TB is

	----general-definitions--------------------------------------------CONSTANTS--
	constant ACTIVE: std_logic := '1';
	constant CLOCK_FREQ:  integer := 100_000_000;
	constant BAUD_RATE:   integer := 115200;

	
	----connections--------------------------------------------------UUT-SIGNALS--
	signal clock:       std_logic;
	signal reset:       std_logic;
	signal txEn:        std_logic;
	signal dataIn:      std_logic_vector(7 downto 0);
	signal txComplete:  std_logic;
	signal dataOut:     std_logic;

	component UartTx
		generic (
			BAUD_RATE:  positive := 115200;
			CLOCK_FREQ: positive := 100_000_000
			); 
		port (
			clock:       in  std_logic;
			reset:       in  std_logic;
			txEn:        in  std_logic;
	 		dataIn:      in  std_logic_vector(7 downto 0);
	 		txComplete:  out std_logic;
			dataOut:     out std_logic
			);
	end component UartTx;

begin

	--============================================================================
	--  UUT
	--============================================================================
	UUT: UartTx
		generic map (
			BAUD_RATE  =>  BAUD_RATE,
			CLOCK_FREQ =>  CLOCK_FREQ
			)
		port map (
			clock      => clock,
			reset      => reset,
			txEn       => txEn,
			dataIn     => dataIn,
			txComplete => txComplete,
			dataOut    => dataOut
			);


	--============================================================================
	--  Reset
	--============================================================================
	SYSTEM_RESET: process
	begin
		reset <= ACTIVE;
		wait for 15 ns;
		reset <= not ACTIVE;
		wait;
	end process SYSTEM_RESET;

	
	--============================================================================
	--  Clock
	--============================================================================
	SYSTEM_CLOCK: process
	begin
		clock <= not ACTIVE;
		wait for 5 ns;
		clock <= ACTIVE;
		wait for 5 ns;
	end process SYSTEM_CLOCK;


	--============================================================================
	--  Signal Driver
	--============================================================================
	SIGNAL_DRIVER: process
	begin
	
		----initialize-signals-and-wait-for-reset-to-be-lifted--------------------
		txEn <= not ACTIVE;
		dataIn <= X"00";
		wait until reset=not ACTIVE;

				
		----transmit 0x5A---------------------------------------------------------
		wait until rising_edge(clock);
		txEn   <= ACTIVE;
		dataIn <= X"5A";
		wait until rising_edge(clock);
		txEn   <= not ACTIVE;
		wait until (txComplete=ACTIVE);
		wait until rising_edge(clock);


		----transmit 0xA5---------------------------------------------------------
		wait until rising_edge(clock);
		txEn   <= ACTIVE;
		dataIn <= X"A5";
		wait until rising_edge(clock);
		txEn   <= not ACTIVE;
		wait until (txComplete=ACTIVE);
		wait until rising_edge(clock);

				
		----transmit 0xFF---------------------------------------------------------
		wait until rising_edge(clock);
		txEn   <= ACTIVE;
		dataIn <= X"FF";
		wait until rising_edge(clock);
		txEn   <= not ACTIVE;
		wait until (txComplete=ACTIVE);


		wait;
	end process SIGNAL_DRIVER;


end UartTx_TB_ARCH;