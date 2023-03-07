library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--==================================================================================
--=
--=  Name: Debouncer
--=  Designer: Scott Tippens and Jaden Zwicker
--=
--=      This component generates a one-cycle clock pulse whenever the input goes
--=      from a LOW to a HIGH level. Holding the input signal ACTIVE for extended
--=      periods of time will not generate additional pulses. The trigger signal
--=      must fall low prior to generating another pulse.
--=
--=      This is Scott Tippens LevelDetector with slight modifications to generalize
--=
--==================================================================================
entity Debouncer is
    port (
    	reset:          in  std_logic;
        clock:          in  std_logic;
    	input:          in  std_logic;
        debouncedInput: out std_logic
    );
end Debouncer;

architecture Debouncer_ARCH of Debouncer is

    -- Active High constant implemented for readability.
	constant ACTIVE:  std_logic := '1';

begin

	process(reset, clock)
		variable held: std_logic;
	begin
		if (reset = ACTIVE) then
			debouncedInput <= not ACTIVE;
			held := not ACTIVE;
		elsif (rising_edge(clock)) then
			debouncedInput <= not ACTIVE;
			if (input = ACTIVE) then
				if (held = not ACTIVE) then
					debouncedInput <= ACTIVE;
					held := ACTIVE;
				end if;
			else
				held := not ACTIVE;
			end if;
		end if;
	end process;

end Debouncer_ARCH;