library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RegisterFile is
	port (
		rs:         in  std_logic_vector(4 downto 0);
		rt:         in  std_logic_vector(4 downto 0);
		rd: 	       in  std_logic_vector(4 downto 0);
		WriteEnable: in  std_logic;
		Clock:       in  std_logic;
		DataInput:   in  std_logic_vector(31 downto 0);
		DataOutput1: out std_logic_vector(31 downto 0);
		DataOutput2: out std_logic_vector(31 downto 0)
	);
	
End RegisterFile;

architecture behavior of RegisterFile is
	signal r0: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r1: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r2: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r3: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r4: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r5: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r6: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r7: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r8: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r9: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r10: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r11: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r12: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r13: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r14: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r15: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r16: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r17: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r18: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r19: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r20: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r21: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r22: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r23: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r24: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r25: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r26: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r27: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r28: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r29: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r30: std_logic_vector(31 downto 0) := (Others =>'0');
	signal r31: std_logic_vector(31 downto 0) := (Others =>'0');
			
begin
	process (Clock, WriteEnable)
	begin
		if (rising_edge(Clock)) Then
			If (WriteEnable = '1') then
				Case rd is
					When "00000" => r0 <= DataInput;
					When "00001" => r1 <= DataInput;
					When "00010" => r2 <= DataInput;
					When "00011" => r3 <= DataInput;
					When "00100" => r4 <= DataInput;
					When "00101" => r5 <= DataInput;
					When "00110" => r6 <= DataInput;
					When "00111" => r7 <= DataInput;
					When "01000" => r8 <= DataInput;
					When "01001" => r9 <= DataInput;
					When "01010" => r10 <= DataInput;
					When "01011" => r11 <= DataInput;
					When "01100" => r12 <= DataInput;
					When "01101" => r13 <= DataInput;
					When "01110" => r14 <= DataInput;
					When "01111" => r15 <= DataInput;
					When "10000" => r16 <= DataInput;
					When "10001" => r17 <= DataInput;
					When "10010" => r18 <= DataInput;
					When "10011" => r19 <= DataInput;
					When "10100" => r20 <= DataInput;
					When "10101" => r21 <= DataInput;
					When "10110" => r22 <= DataInput;
					When "10111" => r23 <= DataInput;
					When "11000" => r24 <= DataInput;
					When "11001" => r25 <= DataInput;
					When "11010" => r26 <= DataInput;
					When "11011" => r27 <= DataInput;
					When "11100" => r28 <= DataInput;
					When "11101" => r29 <= DataInput;
					When "11110" => r30 <= DataInput;
					When "11111" => r31 <= DataInput;
				End Case;
			End If;
		end if;
	end process;
	With rs Select DataOutput1 <= 
		r0  when "00000",
		r1  when "00001",
		r2  when "00010",
		r3  when "00011",
		r4  when "00100",
		r5  when "00101",
		r6  when "00110",
		r7  when "00111",
		r8  when "01000",
		r9  when "01001",
		r10 when "01010",
		r11 when "01011",
		r12 when "01100",
		r13 when "01101",
		r14 when "01110",
		r15 when "01111",
		r16 when "10000",
		r17 when "10001",
		r18 when "10010",
		r19 when "10011",
		r20 when "10100",
		r21 when "10101",
		r22 when "10110",
		r23 when "10111",
		r24 when "11000",
		r25 when "11001",
		r26 when "11010",
		r27 when "11011",
		r28 when "11100",
		r29 when "11101",
		r30 when "11110",
		r31 when "11111";
	With rt Select DataOutput2 <= 
		r0  when "00000",
		r1  when "00001",
		r2  when "00010",
		r3  when "00011",
		r4  when "00100",
		r5  when "00101",
		r6  when "00110",
		r7  when "00111",
		r8  when "01000",
		r9  when "01001",
		r10 when "01010",
		r11 when "01011",
		r12 when "01100",
		r13 when "01101",
		r14 when "01110",
		r15 when "01111",
		r16 when "10000",
		r17 when "10001",
		r18 when "10010",
		r19 when "10011",
		r20 when "10100",
		r21 when "10101",
		r22 when "10110",
		r23 when "10111",
		r24 when "11000",
		r25 when "11001",
		r26 when "11010",
		r27 when "11011",
		r28 when "11100",
		r29 when "11101",
		r30 when "11110",
		r31 when "11111";
end behavior;