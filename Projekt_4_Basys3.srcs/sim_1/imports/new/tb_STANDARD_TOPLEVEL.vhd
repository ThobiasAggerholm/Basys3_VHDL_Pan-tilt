-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 4.4.2020 14:55:18 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_STANDARD_TOPLEVEL is
  generic(
            SPI_data_length : integer := 16;
            PWM_resolution: integer := 8 -- number of bits used to describe max_val
          );
end tb_STANDARD_TOPLEVEL;

architecture tb of tb_STANDARD_TOPLEVEL is

    component STANDARD_TOPLEVEL
        port (clk     : in std_logic;
              vauxp6  : in std_logic;
              vauxp14 : in std_logic;
              vauxp7  : in std_logic;
              vauxp15 : out std_logic);
    end component;

    signal clk     : std_logic;
    signal vauxp6  : std_logic;
    signal vauxp14 : std_logic;
    signal vauxp7  : std_logic;
    signal vauxp15 : std_logic;

    signal MasterOutData: std_logic_vector (SPI_data_length-1 downto 0);
    signal MasterInData:  std_logic_vector (SPI_data_length-1 downto 0) := X"0000";

    constant TbPeriod : time :=  0.01 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : STANDARD_TOPLEVEL
    port map (clk     => clk,
              vauxp6  => vauxp6,
              vauxp14 => vauxp14,
              vauxp7  => vauxp7,
              vauxp15 => vauxp15);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        vauxp6 <= '0'; --SClk
        vauxp14 <= '1'; --SS
        vauxp7 <= '0'; -- MOSI

        -- vauxp15 -> MISO
        MasterOutData <= X"00ef";

        -- EDIT Add stimuli here

        wait for 20 ns;
        vauxp14   <= '0'; --SS
        wait for 20 ns;
        for i in SPI_data_length-1 downto 0 loop
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

        MasterOutData <= X"000f"; -- Data fra Master til Slave
        wait for 200 ns;
        vauxp14   <= '0'; --SS
        wait for 20 ns;
        for j in SPI_data_length-1 downto 0 loop
        vauxp7 <= MasterOutData(j); -- MOSI
        wait for 20 ns;
        vauxp6   <= '1'; --CLOCK
        MasterInData(j) <= vauxp15; --MISO
        wait for 20 ns;
        vauxp6   <= '0'; --CLOCK
        end loop;
        wait for 20 ns;
        vauxp14   <= '1';      --SS

        ----------------------------------------------

        MasterOutData <= X"00ff"; -- Data fra Master til Slave
        wait for 200 ns;
        vauxp14   <= '0'; --SS
        wait for 20 ns;
        for k in SPI_data_length-1 downto 0 loop
        vauxp7 <= MasterOutData(k); -- MOSI
        wait for 20 ns;
        vauxp6   <= '1'; --CLOCK
        MasterInData(k) <= vauxp15; --MISO
        wait for 20 ns;
        vauxp6   <= '0'; --CLOCK
        end loop;
        wait for 20 ns;
        vauxp14   <= '1';      --SS


        -- EDIT Add stimuli here
        wait for 20000000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_STANDARD_TOPLEVEL of tb_STANDARD_TOPLEVEL is
    for tb
    end for;
end cfg_tb_STANDARD_TOPLEVEL;
