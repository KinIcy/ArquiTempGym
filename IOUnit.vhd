Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Entity IOUnit Is
Port (
	ID    : in natural range 0 to 15;
	Input : in signed(31 downto 0);
	Output: out signed(31 downto 0);
	KEY   : in std_logic_vector(3 downto 0);
	HEX0  : out std_logic_vector(6 downto 0);
	HEX1  : out std_logic_vector(6 downto 0);
	HEX2  : out std_logic_vector(6 downto 0);
	HEX3  : out std_logic_vector(6 downto 0);
	RX    : in  std_logic;
	TX    : out std_logic;
	Stall : out std_logic;
	Clock : in std_logic
);
End IOUnit;

Architecture RTL of IOUnit Is
Component ASCIIto7Seg Is
Port (
	ASCII: in natural range 0 to 255;
	SvSeg: out std_logic_vector(6 downto 0)
);
End Component;

Signal ASCII0, ASCII1, ASCII2, ASCII3: natural range 0 to 255;
Signal UARTIn, UARTOut: signed(31 downto 0);

Begin
	U0: ASCIIto7Seg Port Map (ASCII0,HEX0);
	U1: ASCIIto7Seg Port Map (ASCII1,HEX1);
	U2: ASCIIto7Seg Port Map (ASCII2,HEX2);
	U3: ASCIIto7Seg Port Map (ASCII3,HEX3);
	
	Process (Clock)
	Begin
		If (rising_edge(Clock)) Then
			Case ID Is
				When 0 => Output <= RESIZE(signed(KEY(0 downto 0)),32);
				When 1 => Output <= RESIZE(signed(KEY(1 downto 1)),32);
				When 2 => Output <= RESIZE(signed(KEY(2 downto 2)),32);
				When 3 => Output <= RESIZE(signed(KEY(3 downto 3)),32);	
				When 4 => ASCII0 <= to_integer(Input);
				When 5 => ASCII1 <= to_integer(Input);
				When 6 => ASCII2 <= to_integer(Input);
				When 7 => ASCII3 <= to_integer(Input);
				When 8 => UARTIn <= Input;
				When 9 => Output <= UARTOut;
				When Others => NULL;
			End Case;
		End If;
	End Process;
End Architecture;