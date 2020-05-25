----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2020 09:21:12 PM
-- Design Name: 
-- Module Name: H_bridge - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity H_bridge is
  Port (Enable      : in STD_LOGIC := '0';
        EN          : out STD_LOGIC;
        IN1         : out STD_LOGIC := '0';
        IN2         : out STD_LOGIC := '0';
        dir         : in  STD_LOGIC := '0';
        PWM_pulse   : in  STD_LOGIC
        );
end H_bridge;

architecture Behavioral of H_bridge is
begin
IN1 <= PWM_pulse when (dir = '1' and Enable = '1') else '0';
IN2 <= PWM_pulse when (dir = '0' and Enable = '1') else '0';
EN  <= Enable;

end Behavioral;
