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
              Rbuf_signal : out std_logic_vector(data_length-1 downto 0);
              TBuf_signal : out std_logic_vector(data_length-1 downto 0)
              );
    end component;

    signal SClk           : std_logic := '0';
    signal SS             : std_logic := '1';
    signal MOSI           : std_logic := '0';
    signal MISO           : std_logic;
    signal Data_Rec_Buf   : std_logic_vector (data_length-1 downto 0);
    signal Data_Tra_Buf   : std_logic_vector (data_length-1 downto 0);
    signal Rbuf_signal    : std_logic_vector(data_length-1 downto 0);
    signal TBuf_signal    : std_logic_vector(data_length-1 downto 0);

    signal MasterOutData: std_logic_vector (data_length-1 downto 0);
    signal MasterInData: std_logic_vector (data_length-1 downto 0) := X"0000";

   -------------------------------------------------------------- Clock period definitions
   constant SClk_period : time := 20 ns;
begin

    dut : slave
    port map (SClk           => SClk,
              SS             => SS,
              MOSI           => MOSI,
              MISO           => MISO,
              Data_Rec_Buf   => Data_Rec_Buf,
              Data_Tra_Buf   => Data_Tra_Buf,
              Rbuf_signal    => Rbuf_signal,
              Tbuf_signal    => Tbuf_signal
              );

    clock : process
    begin
        SClk <= '0'; wait for SClk_period/2;
        SClk <= '1'; wait for SClk_period/2;
    end process;
    
    stimuli : process
    begin
        -- Initialization
        Data_Tra_Buf <= X"1111"; -- Slave sende
        MasterOutData <= X"8444";
        
        -- Round one process
        wait until rising_edge(SClk);
        SS   <= '0';
        
        for i in data_length-1 downto 0 loop
            
            wait until falling_edge(SClk);
            MOSI <= MasterOutData(i);
            
            wait until rising_edge(SClk);
            MasterInData(i) <= MISO;         
            -- next data ready
            if i = 3 then
                Data_Tra_Buf <= X"2222"; -- Slave sende -- Data fra Slave til Master
            end if;
            
        end loop;

        wait until rising_edge(SClk);
        SS   <= '1';

        -- Round 2 process
        -- Init new master data
        MasterOutData <= X"4444"; -- Data fra Master til Slave

        wait until rising_edge(SClk);
        SS   <= '0';
        
        for i in data_length-1 downto 0 loop
            
            wait until falling_edge(SClk);
            MOSI <= MasterOutData(i);
            
            wait until rising_edge(SClk);
            MasterInData(i) <= MISO;
            
            -- next data ready
            if i = 5 then
                Data_Tra_Buf <= X"3432"; -- Slave sende -- Data fra Slave til Master
            end if;
        end loop;
        
        wait until rising_edge(SClk);
        SS   <= '1';

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_slave of tb_slave is
    for tb
    end for;
end cfg_tb_slave;
