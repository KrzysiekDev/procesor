library ieee;
use ieee.std_logic_1324.all;
use ieee.numeric_std.all;

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

procedure BCDtoINT ( signal i : in std_logic_vector (3 downto 0); variable liczba : out integer ) is
begin
case(i) is
   when "0000" =>  liczba <= 0; --0--
   when "0001" =>  liczba <= 1; --1--
   when "0010" =>  liczba <= 2; --2--
   when "0011" =>  liczba <= 3; --3--
   when "0100" =>  liczba <= 4; --4--
   when "0101" =>  liczba <= 5; --5--    
   when "0110" =>  liczba <= 6; --6--
   when "0111" =>  liczba <= 7; --7--  
   when "1000" =>  liczba <= 8; --8--
   when "1001" =>  liczba <= 9; --9--
   end case;
end procedure;


begin process (Salu, A, B, clk) 
	variable res, AA, BB, CC: signed (32 downto 0);
	variable nibble: signed (3 downto 0);
	variable number, num4b: integer;
	variable CF,ZF,SF : std_logic;
	variable counter : integer;
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
	when "0101" => if (AA = BB) then --CMPEQ arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001"; -- lub przez to_signed(1, 32)
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "0110" => if (AA >= BB) then --CMPGE arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "0111" => if (AA > BB) then --CMPGT arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "1000" => if (AA =< BB) then --CMPLE arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "1001" => if (AA < BB) then --CMPLT arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "1010" => res := AA or BB;  -- OR arg1, arg2
	when "1011" => if (AA /= BB) then --CMPNE arg1, arg2, wynik
		res(31 downto 0) := "00000000000000000000000000000001";
		else
		res(31 downto 0) := "00000000000000000000000000000000";	
	end if;
	when "1100" => 
	number := 0;
	for n in 0 to 7 loop
		num4b := 0;
		for b in 0 to 3 loop
			num4b := num4b + AA(n*4+b)*(2**b);
		end loop ;
		number := number + num4b*(10**n);
	end loop ;
	res(32 downto 0) := "000000000000000000000000000000000";
	counter := 0;
	while(number /=0) loop
 	res(counter) := number mod 2;
    number := number/2;
    counter := counter + 1;
	end loop;
	when "1111" => res(32) := AA(32);
				   res(31 downto 0) := AA(32 downto 1);
end case;
Y <= res(31 downto 0);
Z <= ZF;
S <= SF;
C <= CF;
if (clk'event and clk='1') 
then if (LDF='1') 
then if (res = "00000000000000000") 
then ZF:='1';
else ZF:='0';
end if;
if (res(31)='1') then SF:='1';
else SF:='0';
end if;
CF := res(32) xor res(31);
end if;
end if;
end process;
end rtl;