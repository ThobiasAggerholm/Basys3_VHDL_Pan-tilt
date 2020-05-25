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
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity PWM_Module is
	generic(
		resolution: integer := 8; -- number of bits used to describe max_val
		clk_resolution: integer := 4;
		clk_divider : std_logic_vector := X"8"; --8 tæller 9 gange (Fase korrigeret PWM 510 tick pr. periode -> approx 21,786 Hz clk)
		clk_div_reset : std_logic_vector := X"0";
		cnt_reset : std_logic_vector := X"00"
	);
	port(
		clk: in std_logic; -- clock input
		-- Example: if val_cur is set to half of max_val duty cycle will be approx. 50%
		val_cur: in std_logic_vector( resolution-1 downto 0) := ( others => '0'); -- Length depends on max_val
		pulse: out std_logic := '0'; -- single bit which represents the output
		cnt_test : out std_logic_vector(resolution-1 downto 0)
	);
end entity;

architecture Behavioral of PWM_Module is

	signal clk_div: std_logic_vector(clk_resolution-1 downto 0) := clk_div_reset;
	signal clk_div_max : std_logic_vector(clk_resolution-1 downto 0) := clk_divider; 
	-- divides the 100MHz clock down to 21kHz

  signal cnt: std_logic_vector(resolution-1 downto 0) := cnt_reset;
  signal cnt_min : std_logic_vector(resolution-1 downto 0) := X"00";
  signal cnt_max : std_logic_vector(resolution-1 downto 0) := X"FF"; --255 dec
  signal cnt_dir : std_logic := '1';

begin

    cnt_test <= cnt;

process(clk) -- Counting. Increments counter on rising edge of clock for everytime the clk_div hits 5000
begin
	if rising_edge(clk) then

		if clk_div = clk_div_max then-- divides the 100MHz clock down to 20kHz
			clk_div <= clk_div_reset;

			if cnt = cnt_max-1 then
				cnt_dir <= '0';
		    elsif cnt = cnt_min+1 then
		         cnt_dir <= '1';
		    end if;
		    
		    if cnt_dir = '1' then
		      cnt <= cnt + 1;
		    elsif cnt_dir = '0' then
		      cnt <= cnt -1;
		    end if;

		else
			clk_div <= clk_div + 1;
		end if;

	end if;
end process;

process(clk) -- Pulsing. Initial high PWM
begin
	if(rising_edge(clk)) then
        if cnt_dir = '1' then
            if val_cur > cnt then
                pulse <= '1'; -- pulse high = PWM high
            elsif val_cur = cnt_max then
                pulse <= '1'; -- pulse high = PWM high
            else 
                pulse <= '0'; -- pulse low = PWM low
            end if;
        end if;
        
        if cnt_dir = '0' then
            if val_cur = cnt_min then
                pulse <= '0';
            elsif val_cur >= cnt then
                pulse <= '1'; -- pulse high = PWM high
            else
                pulse <= '0';
            end if;
        end if;
	end if;
end process;

end Behavioral;
