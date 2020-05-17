library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity control is port( 
	clk : in std_logic;
	IR : in signed(31 downto 0);
	reset : in std_logic;
	--C, Z, S,P, INT : in std_logic;
	Salu, Sbb, Sba : out bit_vector(3 downto 0);
	Sbc : out bit_vector(4 downto 0);
	Sid : out bit_vector(2 downto 0);
	Sa : out bit_vector(1 downto 0);
	Smar, Smbr, WR, RD : out bit
	--INTA, MIO : out bit
	);
end entity;
architecture rtl of control is 
type state_type is (fetch, fetch2, decode, MOV_R, MOV_S, ADD_R, ADD_S, SUB_R, SUB_S, LD_R, LD_S, LD_A, CMPEQ_S, CMPEQ_A, CMPGE_S, CMPGE_A, CMPGT_S, CMPGT_A,
					CMPLE_S, CMPLE_A, CMPLT_S, CMPLT_A, OR_S, OR_P, CMPNE_R, CMPNE_S, CMPNE_A, BCDtoB); --dodac kolejne stany
signal state : state_type;

 begin
    process (clk, reset)
        begin
            if(reset = '1') then
                state <= fetch;
            elsif (clk'event and clk = '1') then
                case state is
                    when fetch =>
                        state <= fetch2;
                    when fetch2 =>
                        state <= decode;
                    --dekodowanie rozkazu procesora
                    when decode =>
                        -- pierwsze 2 bity - ilość argumentów operacji
                        case IR(31 downto 29) is
                        	when "001" =>
                        		case IR(28 downto 26) is
                        			when "000" =>
                        				state <= BCDtoB;
                        			when others =>
                        				state <= fetch;
                        		end case;
                        	when "010" =>	
                        		case IR(28 downto 26) is
                        			when "000" => 
                        				state <= MOV_R;
                        			when "001" =>
                        				state <= ADD_R;
                        			when "010" =>
                        			 	state <= SUB_R;
                        			when "011" =>
                        			 	state <= LD_R;
                        			when "100" =>
                        			 	state <= CMPNE_R;
                        			when others =>
                        			 	state <= fetch;
                        		end case;
                        	when "011" =>
                        		case IR(28 downto 26) is
                        			when "000" => 
                        				state <= MOV_S;
                        			when "001" =>
                        				state <= ADD_S;
                        			when "010" =>
                        			 	state <= SUB_S;
                        			when others =>
                        			 	state <= fetch;
                        		end case;
                        	when "100" =>
                        		case IR(28 downto 26) is
                        			when "000" => 
                        				state <= OR_S;
                        			when others =>
                        				state <= fetch;
                        		end case;
                        	when "101" =>
                        		case IR(28 downto 26) is
                        			when "000" => 
                        				state <= LD_S;
                        			when "001" =>
                        				state <= CMPEQ_S;
                        			when "010" =>
                        			 	state <= CMPGE_S;
                        			when "011" =>
                        			 	state <= CMPGT_S;
                        			when "100" =>
                        			 	state <= CMPLE_S;
                        			when "101" =>
                        			 	state <= CMPLT_S;
                        			when "110" =>
                        			 	state <= CMPNE_S;
                        			when others =>
                        			 	state <= fetch;
                        		end case;
                        	when "110" =>
                        		case IR(28 downto 26) is
                        			when "000" => 
                        				state <= LD_A;
                        			when "001" =>
                        				state <= CMPEQ_A;
                        			when "010" =>
                        			 	state <= CMPGE_A;
                        			when "011" =>
                        			 	state <= CMPGT_A;
                        			when "100" =>
                        			 	state <= CMPLE_A;
                        			when "101" =>
                        			 	state <= CMPLT_A;
                        			when "110" =>
                        			 	state <= CMPNE_A;
                        			when others =>
                        			 	state <= fetch;
                        		end case;
                        	when "111" =>
                        		case IR(28 downto 26) is
                        			when "000" => 
                        				state <= OR_P;
                        			when others =>
                        				state <= fetch;
                        		end case;
                        	when others =>
                        		state <= fetch;
                        end case;

                      -- przejscia pomiedzy stanami

				end case;
        	end if;
    end process;


    process(state)
    begin
    	case state is
    		when fetch =>
    			Salu <="0000";
    			Sbb <= "0000";
    			Sbc <= "00000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "01";
				Smar <= '1';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when fetch2 =>
				Salu <="0000";
    			Sbb <= "0000";
    			Sbc <= "00000";
    			Sba <= "0000";
				Sid <= "001";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '1';
			when decode =>
				Salu <="0000";
    			Sbb <= "0000";
    			Sbc <= "00000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when BCDtoB =>
				Salu <="1011";
    			Sbb <= IR(3 downto 0);
    			Sbc <= "11111";
    			Sba <= IR(3 downto 0);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when MOV_R =>
				Salu <="0001";
    			Sbb <= IR(8 downto 5);
    			Sbc <= IR(4 downto 0);
    			Sba <= IR(8 downto 5);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when ADD_R =>
				Salu <="0010";
    			Sbb <= IR(5 downto 5);
    			Sbc <= IR(4 downto 0);
    			Sba <= IR(8 downto 5);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when SUB_R =>
				Salu <="0011";
    			Sbb <= IR(8 downto 5);
    			Sbc <= IR(4 downto 0);
    			Sba <= IR(8 downto 5);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when LD_R =>
				Salu <="0001";
    			Sbb <= IR(8 downto 5);
    			Sbc <= IR(4 downto 0);
    			Sba <= IR(8 downto 5);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when CMPNE_R =>
				Salu <="1010";
    			Sbb <= IR(8 downto 5);
    			Sbc <= IR(4 downto 0);
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when MOV_S =>
				Salu <="0001";
    			Sbb <= IR(15 downto 12);
    			Sbc <= "01110";
    			Sba <= IR(15 downto 12);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when ADD_S =>
				Salu <="0010";
    			Sbb <= IR(15 downto 12);
    			Sbc <= "01110";
    			Sba <= IR(15 downto 12);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when SUB_S =>
				Salu <="0011";
    			Sbb <= IR(15 downto 12);
    			Sbc <= "01110";
    			Sba <= IR(15 downto 12);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when OR_S =>
				Salu <="1001";
    			Sbb <= IR(19 downto 16);
    			Sbc <= "01111";
    			Sba <= IR(19 downto 16);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when LD_S =>
				Salu <="0001";
    			Sbb <= IR(21 downto 18);
    			Sbc <= "10000";
    			Sba <= IR(21 downto 18);
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';	
			when CMPEQ_S =>
				Salu <="0100";
    			Sbb <= IR(21 downto 18);
    			Sbc <= "10000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';	
			when CMPGE_S =>
				Salu <="0101";
    			Sbb <= IR(21 downto 18);
    			Sbc <= "10000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';	
			when CMPGT_S =>
				Salu <="0110";
    			Sbb <= IR(21 downto 18);
    			Sbc <= "10000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';	
			when CMPLE_S =>
				Salu <="0111";
    			Sbb <= IR(21 downto 18);
    			Sbc <= "10000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';	
			when CMPLT_S =>
				Salu <="1000";
    			Sbb <= IR(21 downto 18);
    			Sbc <= "10000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when CMPNE_S =>
				Salu <="1010";
    			Sbb <= IR(21 downto 18);
    			Sbc <= "10000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';		
			when others =>
				Salu <="0000";
    			Sbb <= "0000";
    			Sbc <= "00000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
    	end case;
    end process;
end rtl;
           
