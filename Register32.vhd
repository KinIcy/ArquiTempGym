library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity Register32 is
	Port (
		Input : in  signed(31 downto 0);
		Output: out signed(31 downto 0);
		Enable: in  std_logic;
		Clock : in  std_logic
	);
	
End Register32;

architecture behavior of Register32 is
	signal Data: signed(31 downto 0);
begin
	process (Clock)
	begin
		if rising_edge(Clock) then
			if Enable = '1' then
				Data <= Input;
			end if;
		end if;
	end process;
	
	Output <= Data;

end behavior;