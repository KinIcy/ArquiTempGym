library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity Register32D is
	Port (
		Input : in  signed(31 downto 0);
		Output: out signed(31 downto 0);
		Enable: in  std_logic;
		Clock : in  std_logic
	);
	
End Register32D;

architecture behavior of Register32D is
	signal Data: signed(31 downto 0);
begin
	process (Clock)
	begin
		if falling_edge(Clock) then
			if Enable = '1' then
				Data <= Input;
			end if;
		end if;
	end process;
	
	Output <= Data;

end behavior;