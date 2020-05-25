----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/10/2020 08:45:14 PM
-- Design Name:
-- Module Name: STANDARD_TOPLEVEL - Behavioral
-- Project Name: Pan-Tilt
-- Target Devices:  Basys3
-- Tool Versions:
-- Description:
--
-- Dependencies:
-- In Basys3_Master.xdc ##Pmod Header JXADC for SPI
-- PIN NAVN -> PROGRAM NAVN : FUNKTION
-- PIN J3 -> vauxp6 : CLOCK
-- PIN L3 -> vauxp14 : SLAVE SELECT
-- PIN M2 --> vauxp7 : MASTER OUT SLAVE IN
-- PIN N2 --> vauxp15 : MASTER IN SLAVE OUT

-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity STANDARD_TOPLEVEL is
  generic(
            SPI_data_length : integer := 16;
            PWM_resolution: integer := 8; -- number of bits used to describe max_val
            Hall_Counter_size : integer := 11
          );
    Port ( clk      : in STD_LOGIC;
            --SPI pins
           vauxp6   : in STD_LOGIC; -- SCLK
           vauxp14  : in STD_LOGIC; -- SS
           vauxp7   : in STD_LOGIC; -- MOSI
           vauxp15  : out STD_LOGIC; -- MISO
           -- Frame sensors
           HALL0    : in STD_LOGIC;
           HALL1    : in STD_LOGIC;
           -- Motor sensors
           CHAN_A1  : in STD_LOGIC;
           CHAN_A2  : in STD_LOGIC;
           CHAN_B1  : in STD_LOGIC;
           CHAN_B2  : in STD_LOGIC;
           --H-Bridge
           ENA      : out STD_LOGIC;
           IN1A     : out STD_LOGIC;
           IN2A     : out STD_LOGIC;
           ENB      : out STD_LOGIC;
           IN1B     : out STD_LOGIC;
           IN2B     : out STD_LOGIC;
           
           --Simulations porte:
           -- Positions countere
           POS1    : out std_logic_vector (Hall_Counter_size-1 downto 0);
           POS2    : out std_logic_vector (Hall_Counter_size-1 downto 0);
           
           --SPI Buffers
           RECEIVE_BUFFER : out std_logic_vector(SPI_data_length-1 downto 0);
           TRANSMIT_BUFFER : out std_logic_vector(SPI_data_length-1 downto 0);
           
           --PWM buffer and puls
           PWM_DUTYCYCLE1 : out std_logic_vector( PWM_resolution-1 downto 0);
           PWM_DUTYCYCLE2 : out std_logic_vector( PWM_resolution-1 downto 0);
           
           PWM_PULSE1 : out std_logic;
           PWM_PULSE2 : out std_logic    
           );
end STANDARD_TOPLEVEL;

architecture Behavioral of STANDARD_TOPLEVEL is
    component slave
        port(SClk : in std_logic;
             SS : in std_logic;
             MOSI : in std_logic;
             MISO : out std_logic;
             Data_Rec_Buf : inout std_logic_vector(SPI_data_length-1 downto 0);
             Data_Tra_Buf : in std_logic_vector(SPI_data_length-1 downto 0)
             );
    end component;

    signal Data_Tra_Queue :  STD_LOGIC_VECTOR(SPI_data_length-1 downto 0) := (others => '0');
    signal Data_Rec_Queue :  STD_LOGIC_VECTOR(SPI_data_length-1 downto 0) := (others => '1');

    component PWM_Module is
    	port(
    		clk: in std_logic; -- clock input
    		-- Example: if val_cur is set to half of max_val duty cycle will be 50%
    		val_cur: in std_logic_vector( PWM_resolution-1 downto 0); -- Length depends on max_val
    		pulse: out std_logic := '0' -- single bit which represents the output
    	);
    end component;

    

    component Hall_Modul is
    port (
    clk : in STD_LOGIC;
    Chan_A : in STD_LOGIC := '0';
    Chan_B : in STD_LOGIC := '0';
    Hall_Counter : out STD_LOGIC_VECTOR (Hall_Counter_size-1 downto 0);
    
    Tdirection : out std_logic;
    TA_prev : out std_logic;
    TB_prev : out std_logic;
    TA_curr : out std_logic;
    TB_curr : out std_logic;
    
    TA_in : out std_logic_vector(1 downto 0);
    TB_in : out std_logic_vector(1 downto 0)
    );
    end component;
    
    signal motor1_out : std_logic_vector (Hall_Counter_size-1 downto 0);
    signal motor2_out : std_logic_vector (Hall_Counter_size-1 downto 0);
    
    signal Tra_Motor_sel : std_logic := '0';
    
    component H_Bridge is
    Port (  Enable      : in STD_LOGIC := '0';
            EN          : out STD_LOGIC;
            IN1         : out STD_LOGIC := '0';
            IN2         : out STD_LOGIC := '0';
            dir         : in  STD_LOGIC;
            PWM_pulse   : in  STD_LOGIC
        );
    end component;
    
    signal dirA : STD_LOGIC;
    signal enableA : STD_LOGIC := '0';
    signal PWM_pulseA : STD_LOGIC := '0';
    signal PWM_dutyCycleA :  std_logic_vector( PWM_resolution-1 downto 0) := ( others => '0'); -- Length depends on max_val
    
    signal dirB : STD_LOGIC;
    signal enableB : STD_LOGIC := '0';
    signal PWM_pulseB : STD_LOGIC := '0';
    signal PWM_dutyCycleB :  std_logic_vector( PWM_resolution-1 downto 0) := ( others => '0'); -- Length depends on max_val
    
begin
   SPI_SL : slave
   port map ( SClk => vauxp6,
              SS   => vauxp14,
              MOSI => vauxp7,
              MISO => vauxp15,
              Data_Tra_Buf => Data_Tra_Queue,
              Data_Rec_Buf => Data_Rec_Queue
              );

    PWM_ControllerA : PWM_Module
    port map (  clk => clk,
                val_cur => PWM_dutyCycleA,
                pulse => PWM_pulseA
             );
             
    PWM_ControllerB : PWM_Module
    port map (  clk => clk,
                val_cur => PWM_dutyCycleB,
                pulse => PWM_pulseB
             );
    
    MotorEncoder1 : Hall_Modul
    port map (  clk => clk,
                Chan_A => CHAN_A1,
                Chan_B => CHAN_B1,
                Hall_counter => motor1_out, 
                
                Tdirection => open,
                TA_prev => open,
                TB_prev => open,
                TA_curr => open,
                TB_curr => open,
                
                TA_in => open,
                TB_in => open
    );
    
    
    
    MotorEncoder2 : Hall_Modul
    port map (  clk => clk,
                Chan_A => CHAN_A2,
                Chan_B => CHAN_B2,
                Hall_counter => motor2_out, 
                
                Tdirection => open,
                TA_prev => open,
                TB_prev => open,
                TA_curr => open,
                TB_curr => open,
                
                TA_in => open,
                TB_in => open
    );
    
    Motor1 : H_bridge
    port map ( Enable => enableA,
               EN     => ENA,
               IN1    => IN1A,
               IN2    => IN2A,
               dir    => dirA,
               PWM_pulse => PWM_pulseA
    );
    
    Motor2 : H_bridge
    port map ( Enable => enableB,
               EN     => ENB,
               IN1    => IN1B,
               IN2    => IN2B,
               dir    => dirB,
               PWM_pulse => PWM_pulseB
    );
    
 -- SIMULATION PORTS:
 POS1 <= motor1_out;
 POS2 <= motor2_out;
 
 TRANSMIT_BUFFER<= Data_Tra_Queue;
 RECEIVE_BUFFER <= Data_Rec_Queue;
 
 PWM_DUTYCYCLE1 <= PWM_dutyCycleA;
 PWM_DUTYCYCLE2 <= PWM_dutyCycleB;
 
 PWM_PULSE1 <= PWM_pulseA;
 PWM_PULSE2 <= PWM_pulseB;
  
  --Transmit
  Data_Tra_Queue(Hall_Counter_size + 2 downto Hall_Counter_size) <= Hall1 & Hall0 & Data_Rec_Queue(10);
  
  transmit : process(clk)
  begin
  --When data is ready to read, transmission is done.
  if Data_Rec_Queue(10) = '1' then
  Data_Tra_Queue(Hall_Counter_size -1 downto 0) <= motor2_out;
  else
  Data_Tra_Queue(Hall_Counter_size -1 downto 0) <= motor1_out;
  end if;
  end process;
  
  recieve : process(clk)
  begin
    if Data_Rec_Queue(10) = '1' then --MotorSelect - Enable - direction - PWM 8 bit
        enableA <= Data_Rec_Queue(9);
        dirA <= Data_Rec_Queue(8);
        PWM_dutyCycleA <= Data_Rec_Queue(PWM_resolution -1 downto 0);          
    else
        enableB <= Data_Rec_Queue(9);
        dirB <= Data_Rec_Queue(8);
        PWM_dutyCycleB <= Data_Rec_Queue(PWM_resolution -1 downto 0);    
        
    end if;
  end process;
  

  

end Behavioral;
