-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Mon Apr 27 15:37:13 2020
-- Host        : DESKTOP-HA0SSCD running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/Thobi/CloudStation/Thobias/UNI/4.Semester/Digital_Porgrammerbar_Elektronik/vivado/Projekt_4_Basys3/Projekt_4_Basys3.sim/sim_1/impl/func/xsim/cfg_tb_slave_func_impl.vhd
-- Design      : Hall_Modul
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity Hall_Modul is
  port (
    clk : in STD_LOGIC;
    Chan_A : in STD_LOGIC;
    Chan_B : in STD_LOGIC;
    Hall_Counter : out STD_LOGIC_VECTOR ( 10 downto 0 );
    Tdirection : out STD_LOGIC;
    TA_prev : out STD_LOGIC;
    TB_prev : out STD_LOGIC;
    TA_curr : out STD_LOGIC;
    TB_curr : out STD_LOGIC;
    TA_in : out STD_LOGIC_VECTOR ( 1 downto 0 );
    TB_in : out STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of Hall_Modul : entity is true;
  attribute Counter_size : integer;
  attribute Counter_size of Hall_Modul : entity is 11;
  attribute ECO_CHECKSUM : string;
  attribute ECO_CHECKSUM of Hall_Modul : entity is "fadec40e";
end Hall_Modul;

architecture STRUCTURE of Hall_Modul is
  signal TA_in_OBUF : STD_LOGIC_VECTOR ( 0 to 0 );
  signal TB_in_OBUF : STD_LOGIC_VECTOR ( 0 to 0 );
begin
Chan_A_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => Chan_A,
      O => TA_in_OBUF(0)
    );
Chan_B_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => Chan_B,
      O => TB_in_OBUF(0)
    );
\Hall_Counter_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(0)
    );
\Hall_Counter_OBUF[10]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(10)
    );
\Hall_Counter_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(1)
    );
\Hall_Counter_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(2)
    );
\Hall_Counter_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(3)
    );
\Hall_Counter_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(4)
    );
\Hall_Counter_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(5)
    );
\Hall_Counter_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(6)
    );
\Hall_Counter_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(7)
    );
\Hall_Counter_OBUF[8]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(8)
    );
\Hall_Counter_OBUF[9]_inst\: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Hall_Counter(9)
    );
TA_curr_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => TA_in_OBUF(0),
      O => TA_curr
    );
\TA_in_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => TA_in_OBUF(0),
      O => TA_in(0)
    );
\TA_in_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => TA_in_OBUF(0),
      O => TA_in(1)
    );
TA_prev_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => TA_prev
    );
TB_curr_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => TB_in_OBUF(0),
      O => TB_curr
    );
\TB_in_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => TB_in_OBUF(0),
      O => TB_in(0)
    );
\TB_in_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => TB_in_OBUF(0),
      O => TB_in(1)
    );
TB_prev_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => TB_prev
    );
Tdirection_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => '0',
      O => Tdirection
    );
end STRUCTURE;
