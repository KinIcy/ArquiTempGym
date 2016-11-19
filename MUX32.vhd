library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity MUX32 is
	Port (
		Selector : in  std_logic_vector(1 downto 0);
		Input0, Input1, Input2, Input3 : in signed(31 downto 0);
		Output: out signed(31 downto 0)
	);
End MUX32;

architecture behavior of MUX32 is
	signal Data: signed(31 downto 0);
begin
	With Selector Select Output <=
		Input0 when "00",
		Input1 when "01",
		Input2 when "10",
		Input3 when "11";

end behavior;