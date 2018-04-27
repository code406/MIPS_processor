----------------------------------------------------------------------
-- Fichero: MemProgPlantilla.vhd
-- Descripción: Plantilla para la memoria de programa para el MIPS
-- Fecha última modificación: 2018-04-06

-- Autores: Alberto Sánchez (2012-2018), Ángel de Castro (2010-2015) 
-- Asignatura: EC 1º grado
-- Grupo de Prácticas:
-- Grupo de Teoría:
-- Práctica: 4
-- Ejercicio: 3
----------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity MemProgPlantilla is
	port (
		MemProgAddr : in std_logic_vector(31 downto 0); -- Dirección para la memoria de programa
		MemProgData : out std_logic_vector(31 downto 0) -- Código de operación
	);
end MemProgPlantilla;

architecture Simple of MemProgPlantilla is

begin

	LecturaMemProg: process(MemProgAddr)
	begin
		-- La memoria devuelve un valor para cada dirección.
		-- Estos valores son los códigos de programa de cada instrucción,
		-- estando situado cada uno en su dirección.
		case MemProgAddr is
		-------------------------------------------------------------
		-- Sólo introducir cambios desde aquí	

			-- Por cada instrucción en .text, agregar una línea del tipo:
			-- when DIRECCION => MemProgData <= INSTRUCCION;
			-- Por ejemplo, si la posición 0x00000000 debe guardarse la instrucción con código máquina 0x20010004, poner:
			--when X"00000000" => MemProgData <= X"20010004";
		-- Hasta aquí	
		---------------------------------------------------------------------	
			
			when others => MemProgData <= X"00000000"; -- Resto de memoria vacía
		end case;
	end process LecturaMemProg;

end Simple;

