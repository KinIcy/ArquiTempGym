library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.std_logic_1164.all;

entity Divisor is
	port (
		ClockIn:  in  std_logic;
		ClockOut: out std_logic
	);
	
End Divisor;

architecture behavior of Divisor is
	constant max:     natural   := 249999;
	signal   counter: integer range 0 to max := 0;
	signal   state:   std_logic := '0';
begin
	process (ClockIn, counter, state)
	begin
		if rising_edge(ClockIn) then
			if counter = max then
				state <= not state;
				counter <= 0;
			else
				counter <= counter + 1;
			end if;
		end if;
	end process;

	ClockOut <= state;
end behavior;