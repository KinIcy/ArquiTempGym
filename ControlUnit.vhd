---------------------------------------------------------------------------------------------------
-- Unidad de Control Secuencial
---------------------------------------------------------------------------------------------------
Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Entity ControlUnit is
Port(
----------------------------------------------------------------------------------------------------
-- Solo simulación
----------------------------------------------------------------------------------------------------
STATE      : out natural;
----------------------------------------------------------------------------------------------------
-- Entradas y Salidas
----------------------------------------------------------------------------------------------------
	Clock      : in  std_logic;                     -- Clock
	Opcode     : in  std_logic_vector(5 downto 0);  -- Opcode de la instrucción

--  Branch: Tipo de Branch. 
--     0- Branch If Equal. 1- Branch If Not Equal
	Branch     : out std_logic;
--  BranchMode: Tipo de Branch:
--     0- Branch if equal. 1- Branch if equal not.
	BranchMode : out std_logic;
--  PCWrite: Habilitar escritura en el PC:
--     0- No. 1- Si 
	PCWrite    : out std_logic;
--  IorD: Origin de la dirección de lectura de la memoria.
--     0- Instrucción. 1- Dato
	IorD       : out std_logic; 
--  MemRead: Habilitar lectura de la memoria.
--     0- No. 1- Si
	MemRead    : out std_logic;
--  MemWrite: Habilitar escritura en la memoria.
--     0- No. 1-Si
	MemWrite   : out std_logic;
--  MDRWrite: Habilitar escritura en el MDR.
--     0-No. 1-Si
	MDRWrite   : out std_logic;
--  MemToReg: Origiden del Dato de escritura del RF.
--     0- ALU Out. 1- MDR
	MemToReg   : out std_logic;
--  IRWrite: Habilitar escritura en el IR.
--     0- No. 1- Si.
	IRWrite    : out std_logic;
--  PCSrc: Origen de la nueva dirección del PC.
--     00- Salida de ALU. 01- ALU Out. 10- Dirección de Salto
	PCSrc      : out std_logic_vector(1 downto 0);
--  ALUOp: Tipo de operación de la ALU:
--     00- Suma. 01- Resta. 10- Tipo R. 11- Tipo I.
	ALUOp      : out std_logic_vector(1 downto 0);
--  ALUSrcB: Origen del operando B de la ALU:
--     00- Registro B. 01- Numero 4. 10- Signo Extendido. 11- Signo Extendido x4
	ALUSrcB    : out std_logic_vector(1 downto 0);
--  ALUSrcA: Origen del operando A de la ALU:
--     0- PC. 1- Registro A.
	ALUSrcA    : out std_logic;
--  ALUOutWrite: Habilitar escritura en ALUOut.
--     0- No. 1- Si.
	ALUOutWrite: out std_logic;
--  RegWrite: Habilitar escritura en el RF.
--     0- No. 1- Si.
	RegWrite   : out std_logic;
--  RegRead: Habilitar escritura en los registro A y B.
--     0- No. 1- Si.
	RegRead    : out std_logic;
--  RegDst: Origen del registro de escritura del RF.
--     00- $rt. 01- $rd. $01- $ra (31)
	RegDst     : out std_logic_vector(1 downto 0)
);
End ControlUnit;

----------------------------------------------------------------------------------------------------
-- Implementación
----------------------------------------------------------------------------------------------------
Architecture RTL of ControlUnit is
--  uPC: Registro que contiene el estado actual del programa.
	Signal uPC       : natural := 0;
--  NextState Registro que contiene el siguiente estado del programa.
	Signal NextState : natural;
--  uTable1: Primera tabla de estados
	Signal uTable1   : natural;
--  uTable2: Segunda tabla de estados.
	Signal uTable2   : natural;

--  uIM: memoria ROM que contiene el microprograma de la unidad de control.
	Type uIM_t is Array (14 downto 0) of std_logic_vector(22 downto 0);
	Constant uIM: uIM_t := (

--  Las señasles están en el orden en que se declararon anteriormente.
--    Los dos ultimos bits indican cual será el siguiente estado:
--    00- Fetch. 01- uPC + 1. 10- Tabla 1. 11- Tabla 2

--  ID Estado => Señales de control     -- Nombre del Estado     
		0  => "00101000000000100000001", -- Fetch
		1  => "00000000000000000000001", -- Wait Memory
		2  => "00000000100001101010010", -- Decode
		3  => "11000000001010010000000", -- Branch If Not Equal
		4  => "00100000010000000000000", -- Jump
		5  => "00100000010000101101000", -- Jump And Link
		6  => "10000000001010010000000", -- Branch If Equal
		7  => "00000000000100011000011", -- R-Execution
		8  => "00000000000000000100100", -- R-Completion
		9  => "00000000000111011000011", -- I-Execution
		10 => "00000000000000000100000", -- I-Completion
		11 => "00000000000011101000011", -- Address Computation
		12 => "00011010000000000000001", -- Memory Read
		13 => "00000001000000000100000", -- Write-Back
		14 => "00010100000000000000000"  -- Memory Write
	);
----------------------------------------------------------------------------------------------------
--  Funcionamiento de la unidad de control:
--  1- Actualiza el estado actual por el siguiente estado
--  2- Elege cual será el siguiente estado, según los dos ultimos bits de cada micro instrucción
--
--  Las tablas de estados solo dependen del Opcode, por lo que su lógica es secuencial.
--
--  Al final se asigna cada señal de control a sus respectivos bits de la microinstruccion
----------------------------------------------------------------------------------------------------
Begin
--  Tabla de estados 1. Solo depende del Opcode
	With Opcode Select uTable1 <=
		3  when "000101", -- bne
		4  when "000010", -- j
		5  when "000011", -- jal
		6  when "000100", -- beq
		7  when "000000", -- r-type
		9  when "001000", -- addi
		9  when "001001", -- addiu
		11 when "100011", -- lw
		11 when "101011", -- sw
		0  When Others;
--  Tabla de estados2. Solo depende del Opcode
	With Opcode Select uTable2 <=
		8  when "000000", -- r-type
		10 when "001000", -- addi
		10  when "001001", -- addiu
		12 when "100011", -- lw
		14 when "101011", -- sw
		0  When Others;

--  Proceso Principal.
	Process (Clock)
	Begin
		If rising_edge(Clock) Then
		-- Actualizamos el estado actual por el siguiente estado. 
			uPC <= NextState;
		End If;
	End Process;
	Process (uPC)
	Begin
		-- Elegimos el siguiente estado dependiendo de los 
		Case uIM(uPC)(1 downto 0) Is
			When "00" => NextState <= 0;
			When "01" => NextState <= uPC + 1;
			When "10" => NextState <= uTable1;
			When "11" => NextState <= uTable2;
		End Case;
	End Process;
	
	-- Asignamos a cada señal sus bits correspondientes de la microinstrucción.
	Branch      <= uIM(uPC)(22);
	BranchMode  <= uIM(uPC)(21);
	PCWrite     <= uIM(uPC)(20);
	IorD        <= uIM(uPC)(19);
	MemRead     <= uIM(uPC)(18);
	MemWrite    <= uIM(uPC)(17);
	MDRWrite    <= uIM(uPC)(16);
	MemToReg    <= uIM(uPC)(15);
	IRWrite     <= uIM(uPC)(14);
	PCSrc       <= uIM(uPC)(13 downto 12);
	ALUOp       <= uIM(uPC)(11 downto 10);
	ALUSrcB     <= uIM(uPC)(9  downto 8);
	ALUSrcA     <= uIM(uPC)(7);
	ALUOutWrite <= uIM(uPC)(6);
	RegWrite    <= uIM(uPC)(5);
	RegRead     <= uIM(uPC)(4);
	RegDst      <= uIM(uPC)(3 downto 2);
	
-- Solo Simulación:
STATE <= uPC;
End RTL;