-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 4.4.2020 14:35:47 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_PWM_Module is
	generic(
		resolution: integer := 8
	);
end tb_PWM_Module;

architecture tb of tb_PWM_Module is

    component PWM_Module
        port (clk     : in std_logic;
              val_cur : in std_logic_vector (resolution-1 downto 0);
              pulse   : out std_logic);
    end component;

    signal clk     : std_logic;
    signal val_cur : std_logic_vector (resolution-1 downto 0);
    signal pulse   : std_logic;

    constant TbPeriod : time := 0.01 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PWM_Module
    port map (clk     => clk,
              val_cur => val_cur,
              pulse   => pulse);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        val_cur <= X"7f";

        -- EDIT Add stimuli here
        wait for 20000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_PWM_Module of tb_PWM_Module is
    for tb
    end for;
end cfg_tb_PWM_Module;