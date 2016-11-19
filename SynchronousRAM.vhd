Library ieee;
Use ieee.std_logic_1164.ALL;
Entity SynchronousRAM is
   Port (
      Clock        : in  std_logic;
      Data         : in  std_logic_vector (31 downto 0);
      Address      : in  integer Range 0 to 31;
      ReadEnable   : in  std_logic;
      WriteEnable  : in  std_logic;
      DataOutput   : out std_logic_vector (31 downto 0)
   );
End SynchronousRAM;
Architecture RTL of SynchronousRAM is
   Type Memory is Array(0 to 31) of std_logic_vector(31 downto 0);
   Signal RAM : Memory := (
		0 => X"24090000",
		1 => X"24090001",
		2 => X"01695821",
		3 => X"08100002",
		Others => (Others => '0')
	);
	Signal ReadAddress: integer Range 0 to 31;
Begin
   Process (clock)
   Begin
      If (clock'event and clock = '1') Then
         If (WriteEnable = '1') Then
            RAM(Address) <= Data;
         End If;
			If (ReadEnable = '1') Then
				ReadAddress <= Address;
			End If;
         DataOutput <= RAM(ReadAddress);
      End If;
   End Process;
End RTL;