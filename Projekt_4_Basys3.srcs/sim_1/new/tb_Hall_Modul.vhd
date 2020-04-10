-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 8.4.2020 12:47:33 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_Hall_Modul is
  generic(Counter_size : integer := 12);
end tb_Hall_Modul;

architecture tb of tb_Hall_Modul is

    component Hall_Modul
        port (clk          : in std_logic;
              Chan_A       : in std_logic;
              Chan_B       : in std_logic;
              Hall_Counter : out std_logic_vector (counter_size-1 downto 0);
              Tdirection   : out std_logic;
              TA_prev      : out std_logic;
              TB_prev      : out std_logic;
              TA_curr      : out std_logic;
              TB_curr      : out std_logic;
              TA_in        : out std_logic_vector (1 downto 0);
              TB_in        : out std_logic_vector (1 downto 0));
    end component;

    signal clk          : std_logic;
    signal Chan_A       : std_logic;
    signal Chan_B       : std_logic;
    signal Hall_Counter : std_logic_vector (counter_size-1 downto 0);
    signal Tdirection   : std_logic;
    signal TA_prev      : std_logic;
    signal TB_prev      : std_logic;
    signal TA_curr      : std_logic;
    signal TB_curr      : std_logic;
    signal TA_in        : std_logic_vector (1 downto 0);
    signal TB_in        : std_logic_vector (1 downto 0);

    constant TbPeriod : time := 1 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : Hall_Modul
    port map (clk          => clk,
              Chan_A       => Chan_A,
              Chan_B       => Chan_B,
              Hall_Counter => Hall_Counter,
              Tdirection   => Tdirection,
              TA_prev      => TA_prev,
              TB_prev      => TB_prev,
              TA_curr      => TA_curr,
              TB_curr      => TB_curr,
              TA_in        => TA_in,
              TB_in        => TB_in);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        Chan_A <= '1';
        Chan_B <= '1';

        -- EDIT Add stimuli here
        wait for 2 ns;
        Chan_B <= '0';
        --wait for 2 ns;
        --Chan_A <= '0';
        wait for 2 ns;
        Chan_B <= '1';
        wait for 2 ns;
        Chan_A <= '0';

        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_Hall_Modul of tb_Hall_Modul is
    for tb
    end for;
end cfg_tb_Hall_Modul;
