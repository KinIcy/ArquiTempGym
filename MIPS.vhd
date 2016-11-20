Library IEEE;

Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Entity MIPS is
Port (
	ClockIn: in std_logic;
	KEY   : in std_logic_vector(3 downto 0);
	HEX0  : out std_logic_vector(6 downto 0);
	HEX1  : out std_logic_vector(6 downto 0);
	HEX2  : out std_logic_vector(6 downto 0);
	HEX3  : out std_logic_vector(6 downto 0);
	RX    : in  std_logic;
	TX    : out std_logic;
	INS    : out signed(31 downto 0);
	PCOUT  : out signed(31 downto 0);
	STATE  : out natural;
	MEMOUT : out std_logic_vector(31 downto 0);
	sA     : out signed(31 downto 0)
);
End MIPS;

Architecture Main of MIPS is
Component Divisor is
Port (
	ClockIn:  in  std_logic;
	ClockOut: out std_logic
);
	
End Component;
Component ControlUnit is
Port(
	Clock      : in  std_logic;
	Opcode     : in  std_logic_vector(5 downto 0);
	IO         : in  std_logic;
	Stall      : in  std_logic;
	Done       : in  std_logic;
	Branch     : out std_logic;
	PCWrite    : out std_logic;
	IorD       : out std_logic;
	MemRead    : out std_logic;
	MemWrite   : out std_logic;
	MDRWrite   : out std_logic;
	RegDataSrc : out std_logic_vector(1 downto 0);
	IRWrite    : out std_logic;
	PCSrc      : out std_logic_vector(1 downto 0);
	ALUOp      : out std_logic_vector(1 downto 0);
	ALUSrcB    : out std_logic_vector(1 downto 0);
	ALUSrcA    : out std_logic;
	ALUOutWrite: out std_logic;
	RegWrite   : out std_logic;
	RegRead    : out std_logic;
	RegDst     : out std_logic_vector(1 downto 0);
	STATE      : out natural
);
End Component;
Component Register32 is
	port (
		Input : in  signed(31 downto 0);
		Output: out signed(31 downto 0);
		Enable: in  std_logic;
		Clock : in  std_logic
	);
End Component;
Component Register32D is
	port (
		Input : in  signed(31 downto 0);
		Output: out signed(31 downto 0);
		Enable: in  std_logic;
		Clock : in  std_logic
	);
End Component;
Component SynchronousRAM is
   Port (
      Clock        : in  std_logic;
      Data         : in  std_logic_vector (31 downto 0);
      Address      : in  integer Range 0 to 31;
      ReadEnable   : in  std_logic;
      WriteEnable  : in  std_logic;
      DataOutput   : out std_logic_vector (31 downto 0)
   );
End Component;
Component RegisterFile is
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
End Component;
Component ALUControl is
	port (
		Functor    : in  std_logic_vector(5 downto 0);
		Operator   : in  std_logic_vector(1 downto 0);
		Operation  : out std_logic_vector(2 downto 0);
		Opcode     : in  std_logic_vector(5 downto 0);
		IO         : out std_logic
	);
End Component;
Component ALU is
	port (
		A:        in  signed(31 downto 0);
		B:        in  signed(31 downto 0);
		Operation: in  std_logic_vector(2 downto 0);
		Zero:     out std_logic;
		Result:   out signed(31 downto 0)
	);
End Component;
Component IOUnit Is
Port (
	ID    : in natural range 0 to 15;
	Input : in signed(31 downto 0);
	Output: out signed(31 downto 0);
	Enable: in std_logic;
	KEY   : in std_logic_vector(3 downto 0);
	HEX0  : out std_logic_vector(6 downto 0);
	HEX1  : out std_logic_vector(6 downto 0);
	HEX2  : out std_logic_vector(6 downto 0);
	HEX3  : out std_logic_vector(6 downto 0);
	RX    : in  std_logic;
	TX    : out std_logic;
	Stall : out std_logic;
	Done  : out std_logic;
	Clock : in std_logic
);
End Component;
Component MUX32 is
	Port (
		Selector : in  std_logic_vector(1 downto 0);
		Input0, Input1, Input2, Input3 : in signed(31 downto 0);
		Output: out signed(31 downto 0)
	);
End Component;

Signal Clock       : std_logic;
Signal Branch      : std_logic;
Signal PCWrite     : std_logic;
Signal IorD        : std_logic;
Signal MemRead     : std_logic;
Signal MemWrite    : std_logic;
Signal MDRWrite    : std_logic;
Signal RegDataSrc  : std_logic_vector(1 downto 0);
Signal IRWrite     : std_logic;
Signal PCSrc       : std_logic_vector(1 downto 0);
Signal ALUOp       : std_logic_vector(1 downto 0);
Signal ALUSrcB     : std_logic_vector(1 downto 0);
Signal ALUSrcA     : std_logic;
Signal ALUOutWrite : std_logic;
Signal RegWrite    : std_logic;
Signal RegRead     : std_logic;
Signal RegDst      : std_logic_vector(1 downto 0);
Signal InstructionAdress: signed(31 downto 0);
Signal MemoryOutput: std_logic_vector(31 downto 0);
Signal Instruction : signed(31 downto 0);
Signal rfA         : std_logic_vector(31 downto 0);
Signal rfB         : std_logic_vector(31 downto 0);
Signal A           : signed(31 downto 0);
Signal B           : signed(31 downto 0);
Signal Operation   : std_logic_vector(2 downto 0);
Signal Zero        : std_logic;
Signal ALUResult   : signed(31 downto 0);
Signal ALuOut      : signed(31 downto 0);
Signal MemoryData  : signed(31 downto 0);
Signal IO          : std_logic;
Signal Done        : std_logic;
Signal Stall       : std_logic;
Signal IOOut       : signed(31 downto 0);

Signal PCSrcMUX    : signed(31 downto 0);
Signal IorDMUX     : signed(31 downto 0);
Signal RegDataSrcMUX : signed(31 downto 0);
Signal RegDstMUX   : std_logic_vector(4 downto 0);
Signal ASrcMUX     : signed(31 downto 0);
Signal BSrcMUX     : signed(31 downto 0);

Signal JumpAdress  : signed(31 downto 0);
Signal SignExtend  : signed(31 downto 0);

Begin
	JumpAdress <= InstructionAdress(31 downto 28)&Instruction(25 downto 0)&"00";
	SignExtend <= RESIZE(Instruction(15 downto 0),32);

	With PCSrc Select PCSrcMUX <=
		ALUResult  when "00",
		ALUOut     when "01",
		JumpAdress when "10",
		NULL       when Others;
	With IorD Select IorDMUX <=
		InstructionAdress when '0',
		ALUOut            when '1';
	With RegDataSrc Select RegDataSrcMUX <=
		ALUOut     when "00",
		MemoryData when "01",
		IOOut      when "10",
		NULL       when Others;
	With RegDst Select RegDstMUX <=
		std_logic_vector(Instruction(20 downto 16)) when "00",
		std_logic_vector(Instruction(15 downto 11)) when "01",
		std_logic_vector(to_signed(31,5))           when "10",
		NULL                                        when Others;
	With ALUSrcA Select ASrcMUX <=
		InstructionAdress when '0',
		A                 when '1';
	With ALUSrcB Select BSrcMUX <=
		B                            when "00",
		to_signed(4,32)              when "01",
		SignExtend                   when "10",
		SignExtend(29 downto 0)&"00" when "11";

--	DV: Divisor Port Map(ClockIn,Clock);
   Clock <= ClockIn;
		
	CU: ControlUnit Port Map(Clock,std_logic_vector(Instruction(31 downto 26)),'0',Stall,Done,Branch,PCWrite,
	                         IorD,MemRead,MemWrite,MDRWrite,RegDataSrc,IRWrite,PCSrc,ALUOp,ALUSrcB,
									 ALUSrcA,ALUOutWrite,RegWrite,RegRead,RegDst);
	PC: Register32 Port Map(PCSrcMUX,InstructionAdress,PCWrite or (Branch and Zero),Clock);
	RAM: SynchronousRAM Port Map(Clock,std_logic_vector(B),to_integer(IorDMUX(6 downto 2)),
	                             MemRead,MemWrite,MemoryOutput);
	IR: Register32D Port Map(signed(MemoryOutput),Instruction,IRWrite,Clock);
	RF: RegisterFile Port Map (std_logic_vector(Instruction(25 downto 21)),
	                           std_logic_vector(Instruction(20 downto 16)),	RegDstMUX, RegWrite,
										Clock, std_logic_vector(RegDataSrcMUX),rfA,rfB);
	rA: Register32 Port Map (signed(rfA),A,regRead,Clock);
	rB: Register32 Port Map (signed(rfB),B,regRead,Clock);
	ALUC: ALUControl Port Map (std_logic_vector(Instruction(5 downto 0)),ALUOp,Operation,
	                          std_logic_vector(Instruction(31 downto 26)),IO);
	ALU0: ALU Port Map (ASrcMUX,BSrcMUX,Operation,Zero,ALUResult);
	ALUOutR: Register32 Port Map (ALUResult,ALUOut,ALUOutWrite,Clock);
	MDR: Register32 Port Map (signed(MemoryOutput),MemoryData,MDRWrite,Clock);
	IOU: IOUnit Port Map (to_integer(B(3 downto 0)),ALUOut,IOOut,IO,KEY,HEX0,HEX1,HEX2,HEX3,RX,TX,Stall,Done,Clock);
	
	INS <= Instruction;
	sA <= A;
	MEMOUT <= MemoryOutput;
	PCOUT <= InstructionAdress;
End Main;