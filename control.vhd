library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity control is port( 
	clk : in std_logic;
	IR : in signed(31 downto 0);
	reset : in std_logic;
	--C, Z, S,P, INT : in std_logic;
	Salu, Sbb, Sba : out signed(3 downto 0);
	Sbc : out signed(4 downto 0);
	Sid : out signed(2 downto 0);
	Sa : out signed(1 downto 0);
	Smar, Smbr, WR, RD : out std_logic
	--INTA, MIO : out bit
	);
end entity;
architecture rtl of control is 
type state_type is (fetch, fetch2, decode, MOV_R, MOV_S, ADD_R, ADD_S, SUB_R, SUB_S, LD_R, LD_S, LD_A1,LD_A2,LD_A3,LD_A4,LD_A5, CMPEQ_S, CMPEQ_A, CMPGE_S, CMPGE_A, CMPGT_S, CMPGT_A,
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
                        				state <= LD_A1;
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
                    when BCDtoB =>
                    	state <= fetch;
                    when MOV_R =>
                    	state <= fetch;
                    when ADD_R =>
                    	state <= fetch;
                    when SUB_R =>
                    	state <= fetch;
                    when LD_R =>
                    	state <= fetch;
                    when CMPNE_R =>
                    	state <= fetch;
                    when MOV_S =>
                    	state <= fetch;
                    when ADD_S =>
                    	state <= fetch;
                    when SUB_S =>
                    	state <= fetch;
                    when OR_S =>
                    	state <= fetch;
                    when LD_S =>
                     	state <= fetch;
                    when CMPEQ_S =>
                    	state <= fetch;
                    when CMPGE_S =>
                    	state <= fetch;
                    when CMPGT_S =>
                    	state <= fetch;
                    when CMPLE_S =>
                    	state <= fetch;
                    when CMPLT_S =>
                    	state <= fetch;
                    when CMPNE_S =>
                    	state <= fetch;
                    when LD_A1 =>
                    	state <= LD_A2;
                    when LD_A2 =>
                    	state <= LD_A3;
                    when LD_A3 =>
                    	state <= LD_A4;
                    when LD_A4 =>
                    	state <= LD_A5;
                    when LD_A5 =>
                    	state <= fetch;
                    when others =>
                    	state <= fetch;

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
				RD <= '1';
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
    			Sbb <= IR(8 downto 5);
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
			when LD_A1 =>
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
			when LD_A2 =>
				Salu <="0000";
    			Sbb <= "0000";
    			Sbc <= "00000";
    			Sba <= "1101";
				Sid <= "001";
				Sa <= "00";
				Smar <= '0';
				Smbr <= '0';
				WR <= '0';
				RD <= '0';
			when LD_A3 =>
				Salu <="0000";
    			Sbb <= "0000";
    			Sbc <= "00000";
    			Sba <= "1111";
				Sid <= "000";
				Sa <= "11";
				Smar <= '1';
				Smbr <= '0';
				WR <= '0';
				RD <= '1';
			when LD_A4 =>
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
			when LD_A5 =>
				Salu <="0000";
    			Sbb <= "0000";
    			Sbc <= "00000";
    			Sba <= IR(3 downto 0);
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
                        	

























--begin 
--process (clk, reset) 
--begin 
--if (reset = '1') then 
--	state <= m0;
--elsif (clk'event and clk='1') then 
--	case state is     
--		when m0=> state <= m1;
--        when m1=> 
--        	case IR(15 downto 13) is      
--        		when "000" => 
--        			case IR(12 downto 11) is   
--        				when "00" =>                         
--                    	if(INT='0') then 
--                    		state <= m0;
--                        else state <= m9;
--                        end if;
--   						when "01" => state <= m10;
--   						when "10" => state <= m11;
--   						when "11" => state <= m15;
--					end case;
--				when "001" => 
--					case IR(12 downto 8) is
--						when "00000" => state <= m20;
--						when "00001" => state <= m21;
--						when "00010" => state <= m23;
--						when "00011" => state <= m24;
--						when "00100" => state <= m25;
--						when "00101" => state <= m26;
--						when "00110" => state <= m27;
--						when "00111" => state <= m28;
--						when "01000" => state <= m29;
--						when "01001" => state <= m30;
--						when "01010" => state <= m31;
--						when "01011" => state <= m32;
--						when "01100" => state <= m33;
--						when "01101" => state <= m34;
--						when "01110" => state <= m35;
--						when "01111" => state <= m36;
--						when "10000" => state <= m37;
--						when "10001" => state <= m38;
--						when others => state <= m0;
--					end case;
--	when "010" => state <= m40;
--	when "011" => state <= m50;
--	when "100" => state <= m60;
--	when "101" => state <= m80;
--	when others => state <= m0;
--end case;
--when m10=> if INT = '1' then state <= m9;
--else state <= m10;
--end if;
--      when m11 => state <= m12;
--      when m12 => state <= m13;
--      when m13 => state <= m14;
--      when m14 => if INT = '1' then state <= m9;
--else state <= m0;
--end if;
--... end case;
--end if;
--end process;
--process (state) begin 
--case state is 
--when m0 => 
--	Sa <= "01"; Sbb <= "0000"; Sba <= "0000"; Sid <="001"; Sbc <="0000"; MIO <='1';
--	Smar <='1'; Smbr <= '0'; WR <='0'; RD <='1'; Salu <="0000"; INTA <='0';
--when m1 => 
--	Sa <= "00"; Sbb <= "0000"; Sba <= "0000"; Sid <="000"; Sbc <="0000"; MIO <='1';
--	Smar <='0'; Smbr <= '0'; WR <='0'; RD <='0'; Salu <="0000"; INTA <='0'; 
--when m10 => 
--	Sa <= "00"; Sbb <= "0000"; Sba <= "0000"; Sid <="000"; Sbc <="0000"; MIO <='1';
--	Smar <='0'; Smbr <= '0'; WR <='0'; RD <='0'; Salu <="0000"; INTA <='0'; 
--when m11 => 
--	Sa <= "10"; Sbb <= "1010"; Sba <= "0000"; Sid <="011"; Sbc <="0000"; MIO <='1';
--	Smar <='1'; Smbr <= '1'; WR <='1'; RD <='0'; Salu <="0000"; INTA <='0'; 
--	... 
--when others =>
--	Sa <= "00"; Sbb <= "0000"; Sba <= "0000"; Sid <="000"; Sbc <="0000"; MIO <='1';
--	Smar <='0'; Smbr <= '0'; WR <='0'; RD <='0'; Salu <="0000"; INTA <='0';
--end case;
--end process;
--end rtl;
