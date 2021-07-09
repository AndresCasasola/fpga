
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     07/2020
-- Module Name:     top - Behavioral
-- Dependencies:    
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity top is
  port ( 
    CLK         : in std_logic;     -- Counts designed for 125MHz
    RST         : in std_logic;
    SW          : in std_logic_vector(3 downto 0);
    BTN         : in std_logic_vector(3 downto 0);
    UART_RX     : in std_logic;
    UART_TX     : out std_logic
  );
end top;

architecture Behavioral of top is

    -- Signals
    signal MCLK             : std_logic;
    signal GRST             : std_logic;
    signal locked           : std_logic;
    signal btn_reg          : std_logic_vector(1 downto 0);
    signal tx_trigger       : std_logic;
    signal din              : std_logic_vector(7 downto 0);
    signal data_tx          : std_logic;
    signal data_rx          : std_logic_vector(7 downto 0);
    
    component clk_wiz_0 is
    port (
        reset       : in std_logic;
        clk_in1     : in std_logic;
        clk_out1    : out std_logic;
        locked      : out std_logic
    );
    end component;
    
begin

    -- Inputs 
    GRST <= not locked;
    
    -- Button rising edge detector
    btn_reg <= btn_reg(0) & BTN(0) when rising_edge(CLK);
    tx_trigger <= btn_reg(0) and not(btn_reg(1));
    
    -- Data in
    --din <= std_logic_vector(to_unsigned(65, 8));
    --din <= "0100" & SW;
    
    process
    begin
        wait until rising_edge(CLK);
        if GRST = '1' then
            din <= (others=>'0');
        elsif(tx_trigger = '1') then
            din <= std_logic_vector(unsigned(din) + 1);
        end if;
    end process;

    MMCM: clk_wiz_0
    port map(
        reset       => RST,
        clk_in1     => CLK,
        clk_out1    => MCLK,
        locked      => locked
    );
    
    UART_TX_UNIT: 
    entity Work.uart_tx
    generic map(
      DBIT          => 8,
      SB_TICK       => 16,
      BAUDRATE      => 9600
    )
    port map(
      CLK           => CLK,
      RST           => GRST,
      DIN           => din,
      TX_TRIGGER    => tx_trigger,
      TX_DONE_TICK  => open,
      DOUT          => data_tx
    );
    
    UART_RX_UNIT:
    entity Work.uart_rx
    generic map(
        DBIT          => 8,
        SB_TICK       => 16,
        BAUDRATE      => 9600
    )
    port map(
        CLK           => CLK,
        RST           => RST,
        DIN           => data_tx,
        RX_DONE_TICK  => open,
        DOUT          => data_rx
    );
    
    -- Outputs:
    UART_TX <= data_tx;

end Behavioral;
