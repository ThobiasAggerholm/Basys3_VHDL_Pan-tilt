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
            SPI_data_length : integer := 14;
            PWM_resolution: integer := 8; -- number of bits used to describe max_val
            Hall_Counter_size : integer := 11
          );
    Port ( clk : in STD_LOGIC;
           vauxp6 : in STD_LOGIC;
           vauxp14 : in STD_LOGIC;
           vauxp7 : in STD_LOGIC;
           vauxp15 : out STD_LOGIC;
           led : out STD_LOGIC_VECTOR(SPI_data_length-1 downto 0);
           sw : in STD_LOGIC_VECTOR(PWM_resolution-1 downto 0));
end STANDARD_TOPLEVEL;

architecture Behavioral of STANDARD_TOPLEVEL is
    component slave
        port(SClk : in std_logic;
             SS : in std_logic;
             MOSI : in std_logic;
             MISO : out std_logic;
             Data_Rec_Buf : inout std_logic_vector(SPI_data_length-1 downto 0);
             Data_Tra_Buf : in std_logic_vector(SPI_data_length-1 downto 0);
             Ready_Recieve : out std_logic;
             Ready_Transmit : out std_logic
             );
    end component;

    signal Ready_Recieve : std_logic;
    signal Ready_Transmit : std_logic;
    signal Data_Tra_Queue :  STD_LOGIC_VECTOR(SPI_data_length-1 downto 0) := (others => '0');
    signal Data_Rec_Queue :  STD_LOGIC_VECTOR(SPI_data_length-1 downto 0);

    component PWM_Module is
    	port(
    		clk: in std_logic; -- clock input
    		-- Example: if val_cur is set to half of max_val duty cycle will be 50%
    		val_cur: in std_logic_vector( PWM_resolution-1 downto 0); -- Length depends on max_val
    		pulse: out std_logic := '0' -- single bit which represents the output
    	);
    end component;

    signal PWM_output : std_logic;
    signal PWM_dutyCycle :  std_logic_vector( PWM_resolution-1 downto 0); -- Length depends on max_val

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
    
    signal motor0_out : std_logic_vector (Hall_Counter_size-1 downto 0);
    signal motor1_out : std_logic_vector (Hall_Counter_size-1 downto 0);
    
    signal Rec_Motor_sel : std_logic;
    signal Tra_Motor_sel : std_logic := '0';
begin
   SPI_SL : slave
   port map ( SClk => vauxp6,
              SS   => vauxp14,
              MOSI => vauxp7,
              MISO => vauxp15,
              Ready_Recieve => Ready_Recieve,
              Ready_Transmit => Ready_Transmit,
              Data_Tra_Buf => Data_Tra_Queue,
              Data_Rec_Buf => Data_Rec_Queue
              );

    PWM_Controller : PWM_Module
    port map (  clk => clk,
                val_cur => PWM_dutyCycle,
                pulse => PWM_output
             );
    
    Motor0 : Hall_Modul
    port map (  clk => clk,
                Chan_A => open,
                Chan_B => open,
                Hall_counter => motor0_out, 
                
                Tdirection => open,
                TA_prev => open,
                TB_prev => open,
                TA_curr => open,
                TB_curr => open,
                
                TA_in => open,
                TB_in => open
    );
    
    
    
    Motor1 : Hall_Modul
    port map (  clk => clk,
                Chan_A => open,
                Chan_B => open,
                Hall_counter => motor1_out, 
                
                Tdirection => open,
                TA_prev => open,
                TB_prev => open,
                TA_curr => open,
                TB_curr => open,
                
                TA_in => open,
                TB_in => open
    );
    

  PWM_dutyCycle <= Data_Rec_Queue(PWM_resolution -1 downto 0);
  Rec_Motor_sel <= Data_rec_Queue(PWM_resolution);

  led <= "000" & Rec_Motor_sel & PWM_output;
  
  process(clk)
  begin
  
  Tra_Motor_sel <= Tra_Motor_sel XOR '1';
  Data_Tra_Queue(Hall_Counter_size) <= Tra_Motor_sel;
  
      if Tra_Motor_sel = '1' then
        Data_Tra_Queue(Hall_Counter_size downto 0) <= Tra_Motor_sel & motor1_out;
      else
        Data_Tra_Queue(Hall_Counter_size downto 0) <= Tra_Motor_sel & motor0_out;
      end if;
      
  end process;

end Behavioral;
