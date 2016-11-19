library IEEE;

use IEEE.std_logic_1164.all;

entity ProgramCounter is
	port (
		AddressIn:  in  std_logic_vector(31 downto 0);
		AddressOut: out std_logic_vector(31 downto 0);
		Clock:      in  std_logic
	);
	
End ProgramCounter;

architecture behavior of ProgramCounter is
	signal Address: std_logic_vector(31 downto 0);
begin
	process (Clock)
	begin
		if rising_edge(Clock) then
			Address <= AddressIn;
		end if;
	end process;
	
	AddressOut <= Address;

end behavior;