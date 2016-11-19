library IEEE;

use IEEE.std_logic_1164.all;

Entity ALUControl is
	port (
		Functor    : in  std_logic_vector(5 downto 0);
		Operator   : in  std_logic_vector(1 downto 0);
		Operation  : out std_logic_vector(2 downto 0);
		Opcode     : in  std_logic_vector(5 downto 0)
	);
End ALUControl;

architecture behavior of ALUControl is

Signal RType: std_logic_vector(2 downto 0);
Signal IType: std_logic_vector(2 downto 0);

begin
	with Functor select RType <=
	   "110" when "100011",
		"010" when "100001",
		"110" when "100010",
		"000" when "100100",
		"001" when "100101",
		"111" when "101010",
		"000" when others;
		
	With Opcode Select IType <=
		"010" when "001000",
		"010" when "001001",
		"000" when Others;
		
	with Operator select Operation <=
		"010" when "00",
		"110" when "01",
		RType when "10",
		IType when "11";
end behavior;