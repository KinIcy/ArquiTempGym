library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Entity ALU is
	port (
		A:        in  signed(31 downto 0);
		B:        in  signed(31 downto 0);
		Operation: in  std_logic_vector(2 downto 0);
		Zero:     out std_logic;
		Result:   out signed(31 downto 0)
	);
	
End ALU;

architecture behavior of ALU is

signal SLT: signed(31 downto 0);

begin	
	SLT <= to_signed(1,32) when A < B else (Others => '0');
	
	with Operation select Result <=
		A and B         when "000", -- And
		A or B          when "001", -- Or
		resize(A+B,32)  when "010", -- Suma
		resize(A-B,32)  when "110", -- Resta
		SLT             when "111", -- Set On Less Than;
		(Others => '0') when others;
		
	Zero <= '1' when A = B else '0';
		
end behavior;