library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity SyncChain_Debouncer is
    port (
    	reset:    in  std_logic;
        clock:    in  std_logic;
    	btnR:  in  std_logic;
        debouncedInput:  out std_logic
    );
end SyncChain_Debouncer;

architecture SyncChain_Debouncer_ARCH of SyncChain_Debouncer is
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
    --  SynchronizerChain                                                COMPONENT
    --============================================================================
	component SynchronizerChain
		generic (CHAIN_SIZE: positive);
        port (
            reset:    in  std_logic;
            clock:    in  std_logic;
            asyncIn:  in  std_logic;
            syncOut:  out std_logic
        );
	end component SynchronizerChain;

begin
	
	SYNC: SynchronizerChain
		generic map (2)
		port map (
			clock    => clock,
			reset    => reset,
			asyncIn  => btnR,
			syncOut  => transfer
			);

    DEBOUNCE: Debouncer
		port map (
			clock           => clock,
			reset           => reset,
			input           => transfer,
			debouncedInput  => debouncedInput
			);	

end SyncChain_Debouncer_ARCH;