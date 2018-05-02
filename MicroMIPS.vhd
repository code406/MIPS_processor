library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity MicroMIPS is
	port (
		Instruction : in std_logic_vector (31 downto 0);
		Clk : in std_logic;
	);
end MicroMIPS;

architecture Practica of MicroMIPS is
	signal uc1, uc2, uc3, uc5, uc6, uc7, uc8, uc9, am2, pcsrc: std_logic;
	signal uc4: std_logic_vector(2 downto 0);
	signal mp1: std_logic_vector(31 downto 0);
	signal am1: std_logic_vector(31 downto 0);
	signal mpd1: std_logic_vector(31 downto 0);
	signal mux1o: std_logic_vector(31 downto 0);
	signal mux2o: std_logic_vector(31 downto 0);
	signal mux3o: std_logic_vector(4 downto 0);
	signal mux4o: std_logic_vector(31 downto 0);
	signal mux5o: std_logic_vector(31 downto 0);
	signal mux6o: std_logic_vector(31 downto 0);
	signal dout: std_logic_vector(31 downto 0);
	signal sum1: std_logic_vector(31 downto 0);
	signal sum2: std_logic_vector(31 downto 0);
	signal desp1: std_logic_vector(27 downto 0);
	signal desp2: std_logic_vector(31 downto 0);
	signal exts: std_logic_vector(31 downto 0);
	signal extc: std_logic_vector(31 downto 0);

	component UnidadControl 
		port (
		OpCode : in std_logic_vector (5 downto 0);
		Funct : in std_logic_vector (5 downto 0);
		MemToReg : out std_logic;
		MemWrite : out std_logic;
		Branch : out std_logic;
		ALUControl: out std_logic_vector (2 downto 0);
		ALUSrc : out std_logic;
		RegDest : out std_logic;
		RegWrite : out std_logic;
		ExtCero : out std_logic;
		Jump : out std_logic
		);
	end component;
	
	component MemProgMIPS
		port (		
		MemProgAddr : in std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
		MemProgData : out std_logic_vector(31 downto 0) -- Código de operación
		);
	end component;

	component RegsMIPS
		port (		
		Clk : in std_logic; -- Reloj
		NRst : in std_logic; -- Reset asíncrono a nivel bajo   SE USA???
		A1 : in std_logic_vector(4 downto 0); -- registro a leer
		Rd1 : out std_logic_vector(31 downto 0); -- copia del valor de A1
		A2 : in std_logic_vector(4 downto 0); -- otro registro a leer
		Rd2 : out std_logic_vector(31 downto 0); -- copia del valor de A2
		A3 : in std_logic_vector(4 downto 0); -- registro sobre el que escribir el dato Wd3
		Wd3 : in std_logic_vector(31 downto 0); -- Dato de entrada
		We3 : in std_logic -- Habilitación de escritura (RegWrite)
		); 
	end component;
	
	component ALUMIPS
		port (
		Op1 : in std_logic_vector (31 downto 0);
		Op2 : in std_logic_vector (31 downto 0);
		ALUControl : in std_logic_vector (2 downto 0);
		Res : out std_logic_vector (31 downto 0);
		Z : out std_logic
		);
	end component;
	
	component MemDataMIPS
		port (
		Clk : in std_logic;
		NRst : in std_logic;
		MemDataAddr : in std_logic_vector(31 downto 0);
		MemDataDataWrite : in std_logic_vector(31 downto 0);
		MemDataWE : in std_logic;
		MemDataDataRead : out std_logic_vector(31 downto 0)
		);
	end component;

begin
	u1: UnidadControl
	port map (
	OpCode => Instruction(31 downto 26), 
	Funct => Instruction(5 downto 0),
	MemToReg => uc1,
	MemWrite => uc2,
	Branch => uc3, 
	ALUControl => uc4,
	ALUSrc => uc5, 
	RegDest => uc6, 
	RegWrite => uc7,
	ExtCero => uc8,
	Jump => uc9,
	);
	
	u2: MemProgMIPS
	port map (
	MemProgAddr => dout,
	MemProgData => mp1,
	);
	
	u3: RegsMIPS
		port map (
			Clk => Clk,
			NRst => 
			A1 => mp1(25 downto 21),
			Rd1 => rm1,
			A2 => mp1(20 downto 16),
			Rd2 => rm2,
			A3 => mux3o,
			Wd3 => mux6o,
			We3 => uc7,
	);

	u4: ALUMips
		port map(
			Op1 => rm1,
			Op2 => mux5o,
			ALUControl => uc4,
			Res => am1, 
			Z => am2,
		);

	u5: MemProgData
		port map(
			Clk => Clk,
			NRst => 
			MemDataAddr => am1,
			MemDataDataWrite => rm2,
			MemDataWE => uc2,
			MemDataDataRead => mpd1,
		);
	

	mux1o <= sum2 when pcsrc = 1 else
			 sum1;
	mux2o <= mux1o when uc9 = 0 else
			 sum1(31 downto 28) & desp1;
			 
	biestable: process(Clk)
	begin
		if rising_edge(Clk) 
			dout <= mux2o;
	end process biestable;
	
	sum1 <= dout + x"00000004";
	sum2 <= desp2 + sum1;
	
	desp2 <= mp1(25 downto 0) & "00";
	desp2 <= exts(29 downto 0) & "00";
	exts <= mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15) & mp1(15 downto 0);

	extc <= "0000000000000000" & mp1(15 downto 0);
	
	mux3o <= mp1(20 downto 16) when uc6 = 0 else
			 		 mp1(15 downto 11); 

	mux4o <= exts when uc8 = 0 else
			 		 extc;

	mux5o <= rm2 when uc5 = 0 else
			 		 mux4o; 
 
	mux6o <= am1 when uc1 = 0 else
			 		 mpd1;

	
	pcsrc <= uc3 and am2;

end Practica;
