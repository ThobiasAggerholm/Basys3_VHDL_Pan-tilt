-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 3.4.2020 10:20:10 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_STANDARD_TOPLEVEL is
generic(data_length : integer := 16);
end tb_STANDARD_TOPLEVEL;

architecture tb of tb_STANDARD_TOPLEVEL is

    component STANDARD_TOPLEVEL
        port (clk     : in std_logic;
              led     : out std_logic_vector (data_length-1 downto 0);
              vauxp6  : in std_logic;
              vauxp14 : in std_logic;
              vauxp7  : in std_logic;
              vauxp15 : out std_logic);
    end component;

    signal clk     : std_logic;
    signal led     : std_logic_vector (data_length-1 downto 0);
    signal vauxp6  : std_logic;
    signal vauxp14 : std_logic;
    signal vauxp7  : std_logic;
    signal vauxp15 : std_logic;

    signal MasterOutData: std_logic_vector (data_length-1 downto 0);
    signal MasterInData:  std_logic_vector (data_length-1 downto 0) := X"0000";

begin

    dut : STANDARD_TOPLEVEL
    port map (clk     => clk,
              led     => led,
              vauxp6  => vauxp6,
              vauxp14 => vauxp14,
              vauxp7  => vauxp7,
              vauxp15 => vauxp15);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        clk <= '0';

        vauxp6 <= '0'; -- CLOCK
        vauxp14 <= '1'; -- SLAVE SELECT
        vauxp7 <= '0'; -- MOSI
                       -- vauxp15 -> MISO
        MasterOutData <= X"8444";

        -- EDIT Add stimuli here

        wait for 20 ns;
        vauxp14   <= '0'; --SS
        wait for 20 ns;
        for i in data_length-1 downto 0 loop
            vauxp7 <= MasterOutData(i); --MOSI
            wait for 20 ns;
            vauxp6   <= '1'; --CLOCK
            MasterInData(i) <= vauxp15; -- MISO
            wait for 20 ns;
            vauxp6   <= '0'; --CLOCK
        end loop;
        wait for 20 ns;
        vauxp14   <= '1'; --SS

        ----------------------------------------------

        MasterOutData <= X"4444"; -- Data fra Master til Slave
        wait for 200 ns;
        vauxp14   <= '0'; --SS
        wait for 20 ns;
        for i in data_length-1 downto 0 loop
            vauxp7 <= MasterOutData(i); -- MOSI
            wait for 20 ns;
            vauxp6   <= '1'; --CLOCK
            MasterInData(i) <= vauxp15; --MISO
            wait for 20 ns;
            vauxp6   <= '0'; --CLOCK
        end loop;
        wait for 20 ns;
        vauxp14   <= '1';      --SS

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_STANDARD_TOPLEVEL of tb_STANDARD_TOPLEVEL is
    for tb
    end for;
end cfg_tb_STANDARD_TOPLEVEL;
