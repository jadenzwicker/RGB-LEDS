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
--=          NUM_OF_DATA_BITS: A constant that is of type positive. It defines the number
--=                            of bits of the data input. This allows for a variable 
--=                            number of bits to be queded for transmission.
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
    	txStart:    in  std_logic;        -- USE A LOAD TO LOAD DATA
    	txDone:     in  std_logic;
    	data:       in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
        currentBit: out std_logic
        );
end BitTransmitter;

architecture BitTransmitter_ARCH of BitTransmitter is
    
    --signal shift_reg : std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0) := (others => '0');
    signal doneCounter : integer range 0 to NUM_OF_DATA_BITS - 1 := 0;
    signal txStarted : boolean := false;
    signal dataReg : std_logic_vector(data'length -1 downto 0);
    
begin

    --===================================================================================
    -- Bit Transmitter                                                            PROCESS
    --===================================================================================
    BIT_TRANS: process (clock, reset)
    begin
        if (reset = ACTIVE) then
            --shift_reg <= (others => '0');
            doneCounter <= 0;
            txStarted <= false;
            currentBit <= '0';
            dataReg <= (others => '0');
        elsif (rising_edge(clock)) then
            if (txStart = ACTIVE) and (txStarted = false) then
                dataReg <= data;
                txStarted <= true;
                currentBit <= data(NUM_OF_DATA_BITS - 1);          -- no need for register since data should be constant at time of storage anyways
                doneCounter <= 1;
            elsif (txDone = ACTIVE and txStarted) then
                if (doneCounter < NUM_OF_DATA_BITS) then
                    currentBit <= dataReg(NUM_OF_DATA_BITS - doneCounter - 1);
                    doneCounter <= doneCounter + 1;
                else
                    txStarted <= false;
                    doneCounter <= 0;
                    currentBit <= '0';   -- after transmission is completed
                end if;
            end if;
        end if;
    end process BIT_TRANS;
    

end BitTransmitter_ARCH;