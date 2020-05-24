library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Rejestry is port ( 
	clk : in std_logic;
	DI : in signed (31 downto 0);
	BA : in signed (31 downto 0);
	Sbb : in signed (3 downto 0);
	Sbc : in signed (4 downto 0);
	Sba : in signed (3 downto 0);
	Sid : in signed (2 downto 0);
	Sa : in signed (1 downto 0);
	BB : out signed (31 downto 0);
	BC : out signed (31 downto 0);
	ADR : out signed (31 downto 0);
	IRout : out signed (31 downto 0) );
end entity;
architecture rtl of Rejestry is
begin process (clk, Sbb, Sbc, Sba, Sid, Sa, DI) 
variable IR, TMP, C, D, E, F: signed (31 downto 0) := to_signed(0,32);
variable A: signed (31 downto 0):= to_signed(8,32);
variable B: signed (31 downto 0):= to_signed(18,32);
variable AD, PC, ATMP : signed (31 downto 0) := to_signed(0,32);
variable ES, DS, CS, AP1, AP2 : signed(15 downto 0) := to_signed(0,16); -- dodane rejestry
variable SP : signed (31 downto 0) := x"FFFFFFFF";
begin if (clk'event and clk='1') then 
	case Sid is 
		when "000" =>
			null;
		when "001" =>
			PC := PC + 1;
		when "010" =>
			SP := SP + 1;
		when "011" =>
			SP := SP - 1;
		when "100" =>
			AD := AD + 1;
		when "101" =>
			AD := AD - 1;
		when others =>
			null;
	end case;
	case Sba is 
		when "0000" => IR := BA;
		when "0001" => TMP := BA;
		when "0010" => A := BA;
		when "0011" => B := BA;
		when "0100" => C := BA;
		when "0101" => D := BA;
		when "0110" => E := BA;
		when "0111" => F := BA;
		when "1000" => AP1 := BA(31 downto 16);
		when "1001" => AP2 := BA(15 downto 0);
		when "1010" => ES := BA(15 downto 0);
		when "1011" => DS := BA(15 downto 0);
		when "1100" => CS := BA(15 downto 0);
		when "1101" => ATMP := BA; 
		when others => null;
	end case;
end if; 
case Sbb is 
	when "0000" => BB <= DI;
	when "0001" => BB <= TMP;
	when "0010" => BB <= A;
	when "0011" => BB <= B;
	when "0100" => BB <= C;
	when "0101" => BB <= D;
	when "0110" => BB <= E;
	when "0111" => BB <= F;
	when "1000" => BB(31 downto 16) <= AP1;
	when "1001" => BB(15 downto 0) <= AP2;
	when "1010" => BB(15 downto 0) <= ES;
	when "1011" => BB(15 downto 0) <= DS;
	when "1100" => BB(15 downto 0) <= CS;
	when "1101" => BB <= ATMP; 
	when others => null;
end case;
case Sbc is 
	when "00000" => BC <= DI;
	when "00001" => BC <= TMP;
	when "00010" => BC <= A;
	when "00011" => BC <= B;
	when "00100" => BC <= C;
	when "00101" => BC <= D;
	when "00110" => BC <= E;
	when "00111" => BC <= F;
	when "01000" => BC(31 downto 16) <= AP1;
	when "01001" => BC(15 downto 0) <= AP2;
	when "01010" => BC(15 downto 0) <= ES;
	when "01011" => BC(15 downto 0) <= DS;
	when "01100" => BC(15 downto 0) <= CS;
	when "01101" => BC <= ATMP;
	when "01110" => BC <= IR and "00000000000000000000111111111111";
	when "01111" => BC <= IR and "00000000000000001111111111111111";
	when "10000" => BC <= IR and "00000000000000111111111111111111";
	when "10001" => BC <= IR and "00000000000000000000000000001111";
	when others => null;
end case;
case Sa is 
	when "00" => ADR <= AD;
	when "01" => ADR <= PC;
	when "10" => ADR <= SP;
	when "11" => ADR <= ATMP;
	when others => null;
end case;
IRout <= IR;
end process;
end rtl;
