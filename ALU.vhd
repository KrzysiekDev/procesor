library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity ALU is port (    
	A : in signed(31 downto 0);
	B : in signed(31 downto 0);
	Salu : in bit_vector (3 downto 0);
	LDF : in bit;
	clk : in bit;
	Y : out signed (31 downto 0);
	C,Z,S,P : out std_logic );--P dodana flaga
end entity;

architecture rtl of ALU is

begin 
process (Salu, A, B, clk) 
	variable res, AA, BB, CC: signed (32 downto 0);
	variable nibble: signed (3 downto 0);
	variable number, num4b: integer;
	variable CF,ZF,SF : std_logic;
	variable counter : integer;
	variable index: integer;

begin 
	AA(32) := A(31);
	AA(31 downto 0) := A;
	BB(32) := B(31);
	BB(31 downto 0) := B;
	CC(0) := CF;
	CC(32 downto 1) := "00000000000000000000000000000000";
case Salu is 
	when "0000" => res := AA; -- MOV arg1, arg2, -- LD arg1, arg2
	when "0001" => res := BB; -- MOV arg1, arg2, -- LD arg1, arg2
	when "0010" => res := AA + BB; -- ADD arg1, arg2
	when "0011" => res := AA - BB; -- SUB arg1, arg2
	when "0100" => if (AA = BB) then --CMPEQ arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001"; -- lub przez to_signed(1, 32)
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "0101" => if (AA >= BB) then --CMPGE arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "0110" => if (AA > BB) then --CMPGT arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "0111" => if (AA <= BB) then --CMPLE arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "1000" => if (AA < BB) then --CMPLT arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "1001" => res := AA or BB;  -- OR arg1, arg2
	when "1010" => if (AA /= BB) then --CMPNE arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;

	when "1011" => 
		number := 0;
		--number := 
		 for n in 0 to 7 loop
			number := number + to_integer(AA(4*n));
			number := number + (2**n);
		--	num4b := 0;
		-- 	for b in 0 to 3 loop
		-- 		index :=(4*n)+b;
		-- 		num4b := num4b + AA(index)*(2**b);
		-- 		--num4b := num4b + AA(4*n+b)*(2**b);
		-- 	end loop ;
		-- number := number + num4b*(10**n);
		 end loop ;

	res(32 downto 0) := "000000000000000000000000000000000";
	counter := 0;

	while(number /=0) loop
 		--res(counter) := number mod 2, 1; --to_signed(number mod 2, 1);
    	number := number/2;
    	counter := counter + 1;
	end loop;

	when "1111" => 
		res(32) := AA(32);
		res(31 downto 0) := AA(32 downto 1);
	when others =>
		null;
end case;

Y <= res(31 downto 0);
Z <= ZF;
S <= SF;
C <= CF;

if (clk'event and clk='1') then 
	if (LDF='1') then 
		if (res = "00000000000000000") then 
			ZF:='1';
		else 
			ZF:='0';
		end if;

		if (res(31)='1') then 
			SF:='1';
		else 
			SF:='0';
		end if;
	end if;

	CF := res(32) xor res(31);
end if;

end process;
end rtl;