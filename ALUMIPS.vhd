library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_LOGIC_arith.ALL;
use IEEE.std_logic_signed.ALL;

entity ALUMIPS is
	Port (
		Op1 : in std_logic_vector (31 downto 0);
		Op2 : in std_logic_vector (31 downto 0);
		ALUControl : in std_logic_vector (2 downto 0);
		Res : out std_logic_vector (31 downto 0);
		Z : out std_logic
		);
end ALUMIPS;

architecture Practica of ALUMIPS is

	signal aux: std_logic_vector (31 downto 0);

begin
	
	process(Op1, Op2, aux, ALUControl)
	begin
		case ALUControl is
			--suma--
			when "010" => aux <= Op1 + Op2;
			--resta--
			when "110" => aux <= Op1 - Op2;
			--and--
			when "000" => aux <= Op1 and Op2;
			--or--
			when "001" => aux <= Op1 or Op2;
			--nor--
			when "101" => aux <= Op1 nor Op2;
			--SLT--
			when "111" => 
				if Op1(31)='0' then
					if Op2(31)='0' then
						aux <= Op1 - Op2;
						if aux(31) = '1' then
							--slt vale 1--
							aux <= (others => '0');
							aux(0) <= '1';
						else
							--slt vale 0--
							aux <= (others => '0');
						end if;
					else
						--slt vale 0--
						aux <= (others => '0');
					end if;
				elsif Op2(31)='1' then
					aux <= Op1 - Op2;
					if aux(31) = '1' then
						--slt vale 1--
						aux <= (others => '0');
						aux(0) <= '1';
					else
						--slt vale 0--
						aux <= (others => '0');
					end if;
				else
					--slt vale 1--
					aux <= (others => '0');
					aux(0) <= '1';
				end if;
			  
			when others =>
		end case;
	end process;
	
	Res <= aux;
	
	Z <= '1' when aux = (31 downto 0 => '0') else
	     '0';

end Practica;