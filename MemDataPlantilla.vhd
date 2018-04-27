----------------------------------------------------------------------
-- Fichero: MemDataPlantilla.vhd
-- Descripción: Plantilla para la memoria de datos para el MIPS
-- Fecha última modificación: 2018-06-04

-- Autores: Alberto Sánchez (2012-2018), Ángel de Castro (2010)
-- Asignatura: EC. 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 4
-- Ejercicio: 1
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MemDataPlantilla is
	port (
		Clk : in std_logic;
		NRst : in std_logic;
		MemDataAddr : in std_logic_vector(31 downto 0);
		MemDataDataWrite : in std_logic_vector(31 downto 0);
		MemDataWE : in std_logic;
		MemDataDataRead : out std_logic_vector(31 downto 0)
	);
end MemDataPlantilla;

architecture Simple of MemDataPlantilla is

  -- 4 GB son 1 gigapalabras, pero el simulador no deja tanta memoria
  -- Dejamos 64 kB (16 kpalabras), usamos los 16 LSB
  type Memoria is array (0 to (2**14)-1) of std_logic_vector(31 downto 0);
  signal memData : Memoria;

begin

	EscrituraMemProg: process(Clk, NRst)
	begin
	if NRst = '0' then
		-- Se inicializa a ceros, salvo los valores de las direcciones que
		-- tengan un valor inicial distinto de cero (datos ya cargados en
		-- memoria de datos desde el principio)
		for i in 0 to (2**14)-1 loop
			memData(i) <= (others => '0');
		end loop;
		-- Cada palabra ocupa 4 bytes
	-------------------------------------------------------------
	-- Sólo introducir cambios desde aquí	

		-- Por cada dato en .data, agregar una línea del tipo:
		-- memData(conv_integer(DIRECCIÓN)/4) <= DATO;
		-- Por ejemplo, si la posición 0x00002000 debe inicializarse con el dato 0x12345678, poner:
		--memData(conv_integer(X"00002000")/4) <= X"12345678";
	-- Hasta aquí	
	---------------------------------------------------------------------	
	elsif rising_edge(Clk) then
		-- En este caso se escribe por flanco de bajada para que sea
		-- a mitad de ciclo y todas las señales estén estables
		if MemDataWE = '1' then
			memData(conv_integer(MemDataAddr)/4) <= MemDataDataWrite;
		end if;
	end if;
	end process EscrituraMemProg;

	-- Lectura combinacional siempre activa
	-- Cada vez se devuelve una palabra completa, que ocupa 4 bytes
	LecturaMemProg: process(MemDataAddr, memData)
	begin
		-- Parte baja de la memoria sí está, se lee tal cual
		if MemDataAddr(31 downto 16)=X"0000" then
			MemDataDataRead <= MemData(conv_integer(MemDataAddr)/4);
		else -- Parte alta no existe, se leen ceros
			MemDataDataRead <= (others => '0');
		end if;
	end process LecturaMemProg;

end Simple;

