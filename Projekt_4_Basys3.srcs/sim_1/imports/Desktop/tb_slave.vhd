-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 2.4.2020 16:56:54 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_slave is
generic(data_length : integer := 16);
end tb_slave;

architecture tb of tb_slave is

    component slave
        port (SClk           : in std_logic;
              SS             : in std_logic;
              MOSI           : in std_logic;
              MISO           : out std_logic;
              Data_Rec_Buf   : inout std_logic_vector (data_length-1 downto 0);
              Data_Tra_Buf   : in std_logic_vector (data_length-1 downto 0);
              Ready_Recieve  : out std_logic;
              Ready_Transmit : out std_logic);
    end component;

    signal SClk           : std_logic;
    signal SS             : std_logic;
    signal MOSI           : std_logic;
    signal MISO           : std_logic;
    signal Data_Rec_Buf   : std_logic_vector (data_length-1 downto 0);
    signal Data_Tra_Buf   : std_logic_vector (data_length-1 downto 0);
    signal Ready_Recieve  : std_logic;
    signal Ready_Transmit : std_logic;

    signal MasterOutData: std_logic_vector (data_length-1 downto 0);
    signal MasterInData:  std_logic_vector (data_length-1 downto 0) := X"0000";

begin

    dut : slave
    port map (SClk           => SClk,
              SS             => SS,
              MOSI           => MOSI,
              MISO           => MISO,
              Data_Rec_Buf   => Data_Rec_Buf,
              Data_Tra_Buf   => Data_Tra_Buf,
              Ready_Recieve  => Ready_Recieve,
              Ready_Transmit => Ready_Transmit);

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        SClk <= '0';
        SS <= '1';
        MOSI <= '0';

        Data_Tra_Buf <= X"1111"; -- Slave sende
        MasterOutData <= X"8444";
        wait for 20 ns;
        SS   <= '0';
        wait for 20 ns;
        for i in data_length-1 downto 0 loop
            MOSI <= MasterOutData(i);
            wait for 20 ns;
            SCLK   <= '1';
            MasterInData(i) <= MISO;
            wait for 20 ns;
            SCLK   <= '0';
        end loop;
        wait for 20 ns;
        SS   <= '1';

        ----------------------------------------------
        Data_Tra_Buf <= X"2222"; -- Slave sende -- Data fra Slave til Master
        MasterOutData <= X"4444"; -- Data fra Master til Slave
        wait for 200 ns;
        SS   <= '0';
        wait for 20 ns;
        for i in data_length-1 downto 0 loop
            MOSI <= MasterOutData(i);
            wait for 20 ns;
            SCLK   <= '1';
            MasterInData(i) <= MISO;
            wait for 20 ns;
            SCLK   <= '0';
        end loop;
        wait for 20 ns;
        SS   <= '1';

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_slave of tb_slave is
    for tb
    end for;
end cfg_tb_slave;
