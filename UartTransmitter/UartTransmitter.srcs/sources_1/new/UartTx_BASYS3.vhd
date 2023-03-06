library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tip_tools_package.all;

--*****************************************************************************
--*
--* Name: UartTx_Basys3 Test Wrapper
--* Designer: Scott Tippens
--*
--*     Connected through USB-Serial to the Basys3 Board.  Utilizes the lower
--*     8 slide switches as input data for the transmitter and the center
--*     joystick button for initiating a transfer.  The down joystick button
--*     will serve as an external reset.
--*
--*****************************************************************************

entity UartTx_Basys3 is
	port(
		clk:   in   std_logic;
		btnD:  in   std_logic;
		btnC:  in   std_logic;
		sw:    in   std_logic_vector(7 downto 0);
		RsTx:  out  std_logic
		);
end UartTx_Basys3;



architecture UartTx_Basys3_ARCH of UartTx_Basys3 is

	----general-definitions--------------------------------------------CONSTANTS--
	constant ACTIVE: std_logic := '1';
	constant CLOCK_FREQ:  integer := 100_000_000;
	constant BAUD_RATE:   integer := 115_200;

	
	----connections--------------------------------------------------UUT-SIGNALS--
	signal reset:       std_logic;
	signal clock:       std_logic;
	signal txComplete:  std_logic;
	signal txEn:        std_logic;

	component UartTx
		generic (
			BAUD_RATE:  positive;
			CLOCK_FREQ: positive
			); 
		port (
			clock:      in  std_logic;
			reset:      in  std_logic;
			txEn:       in  std_logic;
	 		dataIn:     in  std_logic_vector(7 downto 0);
	 		txComplete: out std_logic;
			dataOut:    out std_logic
			);
	end component UartTx;

begin
	clock <= clk;
	reset <= btnD;

	--============================================================================
	--  UUT
	--============================================================================
	UUT: UartTx
		generic map (
			BAUD_RATE  =>  BAUD_RATE,
			CLOCK_FREQ =>  CLOCK_FREQ
			)
		port map (
			clock       => clock,
			reset       => reset,
			txEn        => TxEn,
			dataIn      => sw,
			txComplete  => txComplete,
			dataOut     => RsTx
			);

	TX_BUTTON: MetaPulse
		generic map(
			CHAIN_SIZE => 2
			)
		port map(
			reset => reset,
			clock => clock,
			asyncIn => btnC,
			pulseOut => txEn
			);
	--txEn <= btnC;

end UartTx_Basys3_ARCH;