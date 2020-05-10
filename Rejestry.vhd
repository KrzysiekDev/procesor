library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Rejestry is port ( 
	clk : in std_logic;
	DI : in signed (31 downto 0);
	BA : in signed (31 downto 0);
	Sbb : in signed (3 downto 0);
	Sbc : in signed (3 downto 0);
	Sba : in signed (3 downto 0);
	Sid : in signed (2 downto 0);
	Sa : in signed (1 downto 0);
	BB : out signed (31 downto 0);
	BC : out signed (31 downto 0);
	ADR : out signed (31 downto 0);
	ES : out signed (15 downto 0); --dodany rejestr
	DS : out signed (15 downto 0); --dodany rejestr
	CS : out signed (15 downto 0); --dodany rejestr	
	AP1 : out signed (15 downto 0); --dodany rejestr
	AP2 : out signed (15 downto 0); --dodany rejestr
	IRout : out signed (31 downto 0) );
end entity;
architecture rtl of Rejestry is
begin process (clk, Sbb, Sbc, Sba, Sid, Sa, DI) 
variable IR, TMP, A, B, C, D, E, F: signed (31 downto 0);
variable AD, PC, SP, ATMP : signed (31 downto 0);
begin if (clk'event and clk='1') 
then case Sid is 
	when "001" => PC := PC + 1;
	when "010" => SP := SP + 1;
	... 
	when others => null;
end case;
case Sba is when "0000" => IR := BA;
when "0001" => TMP := BA;
when "0010" => A := BA;
when "0011" => B := BA;
... 
end case;
end if;
case Sbb is when "0000" => BB <= DI;
when "0001" => BB <= TMP;
when "0010" => BB <= A;
when "0011" => BB <= B;
when "0100" => BB <= C;
... 
end case;
case Sbc is when "0000" => BC <= DI;
when "0001" => BC <= TMP;
when "0010" => BC <= A;
when "0011" => BC <= B;
... 
end case;
case Sa is when "00" => ADR <= AD;
when "01" => ADR <= PC;
when "10" => ADR <= SP;
when "11" => ADR <= ATMP;
end case;
IRout <= IR;
end process;
end rtl;