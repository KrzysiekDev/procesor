library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 

entity Program is port (
        main_clk : in std_logic;
        ram_clk : in std_logic;
        --main_reset : in std_logic --reset nie jest na razie dodany
    );
end entity;

architecture Program_arch of Program is

component ALU is port (
   A : in signed(31 downto 0);
    B : in signed(31 downto 0);
    Salu : in bit_vector (3 downto 0);
    clk : in bit;
    Y : out signed (31 downto 0);
    C,Z,S,P : out std_logic 
);
end component;

component Rejestry is port ( 
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
    IRout : out signed (31 downto 0) 

); 
end component;

component RAM is
port
(
    addr: in signed(31 downto 0);
    datain: in signed(31 downto 0);
     we: in bit;
    clk: in std_logic;
    dataout: out signed(31 downto 0)
);
end component;

component busint is port ( 
    ADR : in signed(31 downto 0);
    DO : in signed(31 downto 0);
    Smar, Smbr, WRin, RDin : in bit;
    AD : out signed (31 downto 0);
    D : inout signed (31 downto 0);
    DI : out signed(31 downto 0);
    WR, RD : out bit
); 
end component;

component control is port(
        clk : in std_logic;
        IR : in signed(31 downto 0);
        reset, C, Z, S,P, INT : in std_logic;
        Salu, Sbb, Sba : out bit_vector(3 downto 0);
        Sbc : out bit_vector(4 downto 0);
        Sid : out bit_vector(2 downto 0);
        Sa : out bit_vector(1 downto 0);
        Smar, Smbr, WR, RD, INTA, MIO : out bit
);
end component;

signal ALU_DATA_INPUT_A, ALU_DATA_INPUT_B, ALU_DATA_OUTPUT : signed (31 downto 0);
signal Salu : signed (3 downto 0);
signal C, Z, S, P : std_logic;
signal REGISTER_DATA_INPUT, RAM_DATA, IR : signed (31 downto 0);
signal RAM_ADRESS_INPUT, REGISTER_ADRESS_OUTPUT : signed (31 downto 0);
signal Sba,Sbb,Sbc : signed (3 downto 0);
signal Sid : signed (2 downto 0);
signal Sa : signed (1 downto 0);
signal WR_FromControl, RD_FromControl : std_logic;
signal WR_FromBusint, RD_FromBusInt : std_logic;
signal Smar, Smbr : std_logic;

begin
    ALU_1: ALU port map (ALU_DATA_INPUT_A, ALU_DATA_INPUT_B, Salu, main_clk, ALU_DATA_OUTPUT, C, Z, S, P);
    REGISTER_1: Registers port map (main_clk, REGISTER_DATA_INPUT, ALU_DATA_OUTPUT, Sbb, Sbc, Sba, 
                                    Sid, Sa, ALU_DATA_INPUT_A, ALU_DATA_INPUT_B, REGISTER_ADRESS_OUTPUT, IR); -- mozna jeszcze dodac reset
    RAM_1: RAM port map (RAM_ADRESS_INPUT, RAM_DATA, RD_FromBusInt, ram_clk, RAM_DATA);
    BUSINT_1: busint port map (REGISTER_ADRESS_OUTPUT, ALU_DATA_OUTPUT, Smar, Smbr, WR_FromControl, RD_FromControl, 
                                RAM_ADRESS_INPUT, REGISTER_DATA_INPUT, RAM_DATA, WR_FromBusint, RD_FromBusInt);
    CONTROL_1: control port map (main_clk, main_reset, IR, Salu, S_ALU_A, S_ALU_B, S_ALU_Y, Sid, Sadr, Smar, Smbr, WR_FromControl, RD_FromControl); -- control nie jest ustawiony

end Program_arch;
