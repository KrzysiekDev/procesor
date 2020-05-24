library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity RAM is
port(
 addr: in signed(31 downto 0);
 datain: in signed(31 downto 0);
 we, rd: in std_logic;
 clk: in std_logic;
 dataout: out signed(31 downto 0) );
end RAM;


architecture RTL of RAM is
   type ram_type is array (0 to 49) of signed(31 downto 0);
   signal ram : ram_type := (
    b"00100000000000000000000000000010",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111",
    b"11111111111111100111111111111111"
   );

begin
  process(clk) is
  begin
    if (clk'event and clk='1') then
      if we = '1' then
        ram(to_integer(addr)) <= datain;
      end if;
  --      dataout <= ram(to_integer(addr)) when rd = '1' else (others => 'Z');    
    end if;
  end process;
  dataout <= ram(to_integer(addr)) when rd = '1'; --else (others => 'Z'); 
end architecture RTL;
