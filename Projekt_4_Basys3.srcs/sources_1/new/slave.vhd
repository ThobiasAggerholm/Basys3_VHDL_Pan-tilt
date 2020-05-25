----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/02/2020 05:57:02 PM
-- Design Name:
-- Module Name: slave - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity slave is
  generic(data_length : integer := 16);
  port(SClk : in std_logic;
       SS : in std_logic;
       MOSI : in std_logic;
       MISO : out std_logic;
       Data_Rec_Buf : inout std_logic_vector(data_length-1 downto 0) := X"0000";
       Data_Tra_Buf : in std_logic_vector(data_length-1 downto 0)
       );
end slave;

architecture Behavioral of slave is
  signal index : integer range 0 to data_length-1 := 0;
  signal TBuf : std_logic_vector(data_length-1 downto 0);
  signal RBuf : std_logic_vector(data_length-1 downto 0) := X"0000";

begin
  
  MISO <= TBuf(index) when SS = '0' else 'Z'; --Creates tri-state-buffer.
  -- If Z -> High impedance. Effectively disconnected.
Update_TBuf_Read_RBuf : process(SS)
begin
  if falling_edge(SS) then
    TBuf <= Data_Tra_Buf;
  end if;
  if rising_edge(SS) then
    Data_Rec_Buf <= RBuf;
  end if;
 end process;

Update_RBuf_and_Index : process(SClk, SS)
begin
  if SS = '1' then
    index <= data_length-1;
  elsif rising_edge(SClk) then
    RBuf(index) <= MOSI;
    if index > 1 then
      index <= index-1;
    else
      index <= 0;
    end if;
  end if;
end process;


end Behavioral;
