----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2023 08:13:46 AM
-- Design Name: 
-- Module Name: SingleBitTx - SingleBitTx_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SingleBitTx is
    generic (
        ACTIVE: std_logic := '1';
        NUM_OF_DATA_BITS: positive := 24
        );
    port (
    	reset:      in  std_logic;
        clock:      in  std_logic;
        txDoneEn:   in  std_logic;
    	data:       in  std_logic_vector(NUM_OF_DATA_BITS - 1 downto 0);
        dataBit:    out std_logic
        );
end SingleBitTx;

architecture SingleBitTx_ARCH of SingleBitTx is

begin

    --===================================================================================
    --  SINGLE_BIT_TX                                                             PROCESS
    --===================================================================================
	SINGLE_BIT_TX: process(reset, clock)
	variable doneCount: natural range 0 to (data'length) := 0;
    begin
        if (reset = ACTIVE) then
            dataBit <=  '0';       -- Default
            doneCount := 0;
        elsif (rising_edge(clock)) then
            if (doneCount >= data'length) then        -- max value, *not an index in data*
                dataBit <= '0';    -- Output 0 when finished sending data
                doneCount := 0;
            else
                -- Signals are assigned at end of process and variables are assigned 
                -- immedialty, so when the else statement increments doneCount the new
                -- count will still be assigned at signal 
                dataBit <= data(doneCount);
                if (txDoneEn = ACTIVE) then
                    doneCount := doneCount + 1;
                    
                end if;
            end if;
        end if;
    end process SINGLE_BIT_TX;

end SingleBitTx_ARCH;
