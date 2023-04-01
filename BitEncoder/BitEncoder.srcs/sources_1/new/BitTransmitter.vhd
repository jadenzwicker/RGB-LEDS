--=======================================================================================
--=
--=  Name: BitTransmitter
--=  University: Kennesaw State University
--=  Designer: Jaden Zwicker
--=
--=      This generic component serves the purpose of reciving an amount of data and outputing the given data bit by bit.
--=
--=      When provided with the input txDone the componet will begin sending the next bit in the order MSB to LSB.
--=      
--=
--=      Generic input definitions are described as follows:
--=          ACTIVE: A constant that is of type std_logic. Should only be defined as '1'
--=                  or '0' according to an active LOW or HIGH system.

--=
--=          CLOCK_FREQUENCY: A constant that is of type positive defining the clock 
--=                           frequency of the system.
--=                           This is described in real time Hz.
--= 
--=======================================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitTransmitter is
    generic (
        ACTIVE: std_logic := '1';
        NUM_OF_DATA_BITS: positive := 24
        );
    port (
    	reset:      in  std_logic;
        clock:      in  std_logic;
    	txStart:    in  std_logic;
    	txDone:     in  std_logic;
    	data:       in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
        currentBit: out std_logic
        );
end BitTransmitter;

architecture BitTransmitter_ARCH of BitTransmitter is
    
    signal shift_reg : std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0) := (others => '0');
    signal shift_counter : integer range 0 to NUM_OF_DATA_BITS - 1 := 0;
    signal txStarted : boolean := false;
    
begin

    --===================================================================================
    -- Bit Transmitter                                                            PROCESS
    --===================================================================================
    BIT_TRANS: process (clock, reset)
    begin
        if (reset = ACTIVE) then
            shift_reg <= (others => '0');
            shift_counter <= 0;
            txStarted <= false;
            currentBit <= '0';
        elsif (rising_edge(clock)) then
            if (txStart = ACTIVE) and (txStarted = false) then
                txStarted <= true;
                currentBit <= data(NUM_OF_DATA_BITS - 1);
                shift_counter <= 1;
            elsif (txDone = ACTIVE and txStarted) then
                if (shift_counter < NUM_OF_DATA_BITS) then
                    currentBit <= data(NUM_OF_DATA_BITS - shift_counter - 1);
                    shift_counter <= shift_counter + 1;
                else
                    txStarted <= false;
                    shift_counter <= 0;
                end if;
            end if;
        end if;
    end process BIT_TRANS;
    

end BitTransmitter_ARCH;