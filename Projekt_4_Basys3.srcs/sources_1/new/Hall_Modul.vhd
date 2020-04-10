----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 04/07/2020 12:18:44 PM
-- Design Name:
-- Module Name: Hall_Modul - Behavioral
-- Project Name: Projekt_4_Basys3
-- Target Devices: Basys3
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

entity Hall_Modul is
  generic(Counter_size : integer := 11);
port (
clk : in STD_LOGIC;
Chan_A : in STD_LOGIC;
Chan_B : in STD_LOGIC;
Hall_Counter : out STD_LOGIC_VECTOR (Counter_size-1 downto 0);

Tdirection : out std_logic;
TA_prev : out std_logic;
TB_prev : out std_logic;
TA_curr : out std_logic;
TB_curr : out std_logic;

TA_in : out std_logic_vector(1 downto 0);
TB_in : out std_logic_vector(1 downto 0)

);
end Hall_Modul;

architecture Behavioral of Hall_Modul is

signal direction : STD_lOGIC;
signal counter : STD_LOGIC_VECTOR (Counter_size-1 downto 0) := (others => '0');

signal A_prev : std_logic;
signal B_prev : std_logic;

signal A_curr : std_logic;
signal B_curr : std_logic;

signal A_in : std_logic_vector(1 downto 0);
signal B_in : std_logic_vector(1 downto 0);
signal data_def : std_logic := '0';
signal dir_def : std_logic := '0';

begin
Hall_counter <= counter;

Tdirection <= direction;
TA_prev <= A_prev;
TB_prev <= B_prev;
TA_curr <= A_curr;
TB_curr <= B_curr;

TA_in <= A_in;
TB_in <= B_in;

process(clk)
begin

   A_in <= A_in(0) & Chan_A;
   B_in <= B_in(0) & Chan_B;
   
   A_curr <= A_in(1);
   B_curr <= B_in(1);
   
   if data_def = '1' then
        
        if ( (A_in(0) XOR A_in(1)) OR (B_in(0) XOR B_in(1)) ) = '1' then
            A_prev <= A_curr;
            B_prev <= B_curr;
            
            A_curr <= A_in(0);
            B_curr <= B_in(0);
            
            direction <= A_in(0) XOR B_curr;
            
            if  (A_in(0) XOR B_curr) = '1' then
                if counter = 1079 then
                    counter <= (others => '0');
                else
                 counter <= counter +1;
                end if;
            elsif  (A_in(0) XOR B_curr) = '0' then
                if counter = 0 then
                    counter <= "10000110111"; -- 1079
                else
                    counter <= counter -1;
                end if;      
            end if;
                
        end if;
        
   else   
     data_def <= '1';
   end if;

    
    

end process;


end Behavioral;




