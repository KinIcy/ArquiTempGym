Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Entity ASCIIto7Seg Is
Port (
	ASCII: in natural range 0 to 255;
	SvSeg: out std_logic_vector(6 downto 0)
);
End ASCIIto7Seg;

Architecture RTL of ASCIIto7Seg Is
Begin
	With ASCII Select SvSeg <=
		"0000000" when 32, -- (space)
		"0000000" when 48, -- 0
		"0000000" when 49, -- 1
		"0000000" when 50, -- 2
		"0000000" when 51, -- 3
		"0000000" when 52, -- 4
		"0000000" when 53, -- 5
		"0000000" when 54, -- 6
		"0000000" when 55, -- 7
		"0000000" when 56, -- 8
		"0000000" when 57, -- 9
		"0000000" when 65, -- A
		"0000000" when 66, -- B
		"0000000" when 67, -- C
		"0000000" when 68, -- D
		"0000000" when 69, -- E
		"0000000" when 70, -- F
		"0000000" when 71, -- G
		"0000000" when 72, -- H
		"0000000" when 73, -- I
		"0000000" when 74, -- J
		"0000000" when 75, -- K
		"0000000" when 76, -- L
		"0000000" when 77, -- M
		"0000000" when 78, -- N
		"0000000" when 79, -- O
		"0000000" when 80, -- P
		"0000000" when 81, -- Q
		"0000000" when 82, -- R
		"0000000" when 83, -- S
		"0000000" when 84, -- T
		"0000000" when 85, -- U
		"0000000" when 86, -- V
		"0000000" when 87, -- W
		"0000000" when 88, -- X
		"0000000" when 89, -- Y
		"0000000" when 90, -- Z
		"1111111" when Others;
		
End Architecture;