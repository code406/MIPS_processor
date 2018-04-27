----------------------------------------------------------------------
-- Fichero: MemProgPlantilla.vhd
-- Descripci�n: Plantilla para la memoria de programa para el MIPS
-- Fecha �ltima modificaci�n: 2018-04-06

-- Autores: Alberto S�nchez (2012-2018), �ngel de Castro (2010-2015) 
-- Asignatura: EC 1� grado
-- Grupo de Pr�cticas:
-- Grupo de Teor�a:
-- Pr�ctica: 4
-- Ejercicio: 3
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MemProgPlantilla is
	port (
		MemProgAddr : in std_logic_vector(31 downto 0); -- Direcci�n para la memoria de programa
		MemProgData : out std_logic_vector(31 downto 0) -- C�digo de operaci�n
	);
end MemProgPlantilla;

architecture Simple of MemProgPlantilla is

begin

	LecturaMemProg: process(MemProgAddr)
	begin
		-- La memoria devuelve un valor para cada direcci�n.
		-- Estos valores son los c�digos de programa de cada instrucci�n,
		-- estando situado cada uno en su direcci�n.
		case MemProgAddr is
		-------------------------------------------------------------
		-- S�lo introducir cambios desde aqu�	

			-- Por cada instrucci�n en .text, agregar una l�nea del tipo:
			-- when DIRECCION => MemProgData <= INSTRUCCION;
			-- Por ejemplo, si la posici�n 0x00000000 debe guardarse la instrucci�n con c�digo m�quina 0x20010004, poner:
			--when X"00000000" => MemProgData <= X"20010004";
		-- Hasta aqu�	
		---------------------------------------------------------------------	
			
			when others => MemProgData <= X"00000000"; -- Resto de memoria vac�a
		end case;
	end process LecturaMemProg;

end Simple;

