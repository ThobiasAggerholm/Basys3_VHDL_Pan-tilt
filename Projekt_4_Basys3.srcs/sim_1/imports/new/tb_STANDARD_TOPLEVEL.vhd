-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 7.5.2020 08:28:38 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_STANDARD_TOPLEVEL is
  generic(
            SPI_data_length : integer := 16;
            PWM_resolution: integer := 8; -- number of bits used to describe max_val
            Hall_Counter_size : integer := 11
          );
end tb_STANDARD_TOPLEVEL;

architecture tb of tb_STANDARD_TOPLEVEL is

    component STANDARD_TOPLEVEL
        port (clk             : in std_logic;
              vauxp6          : in std_logic;
              vauxp14         : in std_logic;
              vauxp7          : in std_logic;
              vauxp15         : out std_logic;
              HALL0           : in std_logic;
              HALL1           : in std_logic;
              CHAN_A1         : in std_logic;
              CHAN_A2         : in std_logic;
              CHAN_B1         : in std_logic;
              CHAN_B2         : in std_logic;
              ENA             : out std_logic;
              IN1A            : out std_logic;
              IN2A            : out std_logic;
              ENB             : out std_logic;
              IN1B            : out std_logic;
              IN2B            : out std_logic;
              POS1            : out std_logic_vector (hall_counter_size-1 downto 0);
              POS2            : out std_logic_vector (hall_counter_size-1 downto 0);
              RECEIVE_BUFFER  : out std_logic_vector (spi_data_length-1 downto 0);
              TRANSMIT_BUFFER : out std_logic_vector (spi_data_length-1 downto 0);
              PWM_DUTYCYCLE1  : out std_logic_vector (pwm_resolution-1 downto 0);
              PWM_DUTYCYCLE2  : out std_logic_vector (pwm_resolution-1 downto 0);
              PWM_PULSE1      : out std_logic;
              PWM_PULSE2      : out std_logic);
    end component;

    signal clk             : std_logic;
    signal vauxp6          : std_logic;
    signal vauxp14         : std_logic;
    signal vauxp7          : std_logic;
    signal vauxp15         : std_logic;
    signal HALL0           : std_logic;
    signal HALL1           : std_logic;
    signal CHAN_A1         : std_logic;
    signal CHAN_A2         : std_logic;
    signal CHAN_B1         : std_logic;
    signal CHAN_B2         : std_logic;
    signal ENA             : std_logic;
    signal IN1A            : std_logic;
    signal IN2A            : std_logic;
    signal ENB             : std_logic;
    signal IN1B            : std_logic;
    signal IN2B            : std_logic;
    signal POS1            : std_logic_vector (hall_counter_size-1 downto 0);
    signal POS2            : std_logic_vector (hall_counter_size-1 downto 0);
    signal RECEIVE_BUFFER  : std_logic_vector (spi_data_length-1 downto 0);
    signal TRANSMIT_BUFFER : std_logic_vector (spi_data_length-1 downto 0);
    signal PWM_DUTYCYCLE1  : std_logic_vector (pwm_resolution-1 downto 0);
    signal PWM_DUTYCYCLE2  : std_logic_vector (pwm_resolution-1 downto 0);
    signal PWM_PULSE1      : std_logic;
    signal PWM_PULSE2      : std_logic;

    constant TbPeriod : time := 10 ns; -- 100 MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';
    
    constant TbPeriod2 : time := 125 ns; -- 8 MHz
    signal TbClock2 : std_logic := '0';
    
    --Mater signals
    signal MasterInData: std_logic_vector (SPI_data_length-1 downto 0) := X"0000";
    signal MasterOutData: std_logic_vector (SPI_data_length-1 downto 0);

begin

    dut : STANDARD_TOPLEVEL
    port map (clk             => clk,
              vauxp6          => vauxp6,
              vauxp14         => vauxp14,
              vauxp7          => vauxp7,
              vauxp15         => vauxp15,
              HALL0           => HALL0,
              HALL1           => HALL1,
              CHAN_A1         => CHAN_A1,
              CHAN_A2         => CHAN_A2,
              CHAN_B1         => CHAN_B1,
              CHAN_B2         => CHAN_B2,
              ENA             => ENA,
              IN1A            => IN1A,
              IN2A            => IN2A,
              ENB             => ENB,
              IN1B            => IN1B,
              IN2B            => IN2B,
              POS1            => POS1,
              POS2            => POS2,
              RECEIVE_BUFFER  => RECEIVE_BUFFER,
              TRANSMIT_BUFFER => TRANSMIT_BUFFER,
              PWM_DUTYCYCLE1  => PWM_DUTYCYCLE1,
              PWM_DUTYCYCLE2  => PWM_DUTYCYCLE2,
              PWM_PULSE1      => PWM_PULSE1,
              PWM_PULSE2      => PWM_PULSE2);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    TbClock2 <= not TbClock2 after TbPeriod2/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;
    -- SPI clock signal
    vauxp6 <= TbClock2;
    
    Encoder : process
    begin
    -- EDIT Adapt initialization as needed
        HALL0 <= '0';
        HALL1 <= '0';
        CHAN_A1 <= '0';
        CHAN_A2 <= '0';
        CHAN_B1 <= '0';
        CHAN_B2 <= '0';
        

        
        for j in 2 downto 0 loop
            for i in 60 downto 0 loop
            
                wait until rising_edge(clk);      
                CHAN_A1 <= '1';
                CHAN_B2 <= '1';
                
                wait until rising_edge(clk);        
                CHAN_B1 <= '1';
                CHAN_A2 <= '1';
                
                wait until rising_edge(clk);        
                CHAN_A1 <= '0';
                CHAN_B2 <= '0';
                
                wait until rising_edge(clk);        
                CHAN_B1 <= '0';
                CHAN_A2 <= '0';
                
            
            end loop;
            
            HALL0 <= HALL0 XOR '1';
            HALL1 <= HALL1 XOR '1';
            
            for i in 60 downto 0 loop
            
                wait until rising_edge(clk);      
                CHAN_A1 <= '1';
                CHAN_B2 <= '1';
                
                wait until rising_edge(clk);        
                CHAN_B1 <= '1';
                CHAN_A2 <= '1';
                
                wait until rising_edge(clk);        
                CHAN_A1 <= '0';
                CHAN_B2 <= '0';
                
                wait until rising_edge(clk);        
                CHAN_B1 <= '0';
                CHAN_A2 <= '0';
                
            
            end loop;
        end loop;
        
    end process;
    
    
    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        vauxp14 <= '1'; --

        
        MasterOutData <= X"03FB";
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        vauxp14 <= '0'; --ss
        
        for i in SPI_DATA_LENGTH -1 downto 0 loop
            if(i < SPI_DATA_LENGTH -1) then
            wait until falling_edge(vauxp6);
            end if;
            vauxp7 <= MasterOutData(i);                    
            
            wait until rising_edge(vauxp6);
            MasterInData(i) <= vauxp15;
            
                     
        
        end loop;


        vauxp14 <= '1'; --ss
        
        --New input
        MasterOutData <= X"03FD";
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        vauxp14 <= '0'; --ss

        
        for i in SPI_DATA_LENGTH -1 downto 0 loop
            if(i < SPI_DATA_LENGTH -1) then
            wait until falling_edge(vauxp6);
            end if;
            vauxp7 <= MasterOutData(i);                    
            
            wait until rising_edge(vauxp6);
            MasterInData(i) <= vauxp15;
            
                     
        
        end loop;
        vauxp14 <= '1'; --ss
        
                --New input
        MasterOutData <= X"03FD";
        
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        vauxp14 <= '0'; --ss

        
        for i in SPI_DATA_LENGTH -1 downto 0 loop
            if(i < SPI_DATA_LENGTH -1) then
            wait until falling_edge(vauxp6);
            end if;
            vauxp7 <= MasterOutData(i);                    
            
            wait until rising_edge(vauxp6);
            MasterInData(i) <= vauxp15;
            
                     
        
        end loop;
        vauxp14 <= '1'; --ss

        -- EDIT Add stimuli here
        wait for 1000 * TbPeriod2;

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