----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 26.03.2020 10:02:12
-- Design Name:
-- Module Name: PWM_Module - Behavioral
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
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PWM_Module is
	generic(
		resolution: integer := 8; -- number of bits used to describe max_val
		clk_div_reset : std_logic_vector := X"0000";
		cnt_reset : std_logic_vector := X"00"
	);
	port(
		clk: in std_logic; -- clock input
		-- Example: if val_cur is set to half of max_val duty cycle will be 50%
		val_cur: in std_logic_vector( resolution-1 downto 0); -- Length depends on max_val
		pulse: out std_logic := '0' -- single bit which represents the output
	);
end entity;

architecture Behavioral of PWM_Module is

	signal clk_div: std_logic_vector(15 downto 0) := clk_div_reset;
	signal clk_div_max : std_logic_vector(15 downto 0) := X"1388"; --5000 dec
	-- divides the 100MHz clock down to 20kHz

  signal cnt: std_logic_vector(resolution-1 downto 0) := cnt_reset;
	signal cnt_max : std_logic_vector(resolution-1 downto 0) := X"FF"; --255 dec

begin

process(clk) -- Counting. Increments counter on rising edge of clock for everytime the clk_div hits 5000
begin
	if rising_edge(clk) then

		if clk_div = clk_div_max then-- divides the 100MHz clock down to 20kHz
			clk_div <= clk_div_reset;

			if cnt = cnt_max then
				cnt <= cnt_reset;
			else
				cnt <= cnt + 1;
			end if;

		else
			clk_div <= clk_div + 1;
		end if;

	end if;
end process;

process(clk) -- Pulsing. Initial high PWM
begin
	if(rising_edge(clk)) then
		if (val_cur > cnt) then -- check val_cur related to the counter
		-- when the counter passes val_cur it inverts the output
			pulse <= '1'; -- pulse high = PWM high
		else
			pulse <= '0'; -- pulse low = PWM low
		end if;
	end if;
end process;

end Behavioral;
