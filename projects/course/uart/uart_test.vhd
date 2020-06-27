
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     uart_test - Behavioral
-- Dependencies:    clk_wiz_0 (core), frcounter.vhd.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity uart_test is
  port ( 
    CLK         : in std_logic;
    RST         : in std_logic;
    TX_TRIGGER  : in std_logic;
    CAT         : out std_logic_vector(3 downto 0);
    AN          : out std_logic_vector(7 downto 0)
  );
end uart_test;

architecture Behavioral of uart_test is

    -- Signals
    signal MCLK             : std_logic;
    signal GRST             : std_logic;
    signal locked           : std_logic;
    signal count            : std_logic_vector(26 downto 0);
    signal tx_tick          : std_logic;
    
    signal s_tick           : std_logic;
    signal tx_rx            : std_logic;
    signal data             : std_logic_vector(7 downto 0);
    signal data_reg         : std_logic_vector(7 downto 0);
    signal rx_done          : std_logic;

    component clk_wiz_0 is
    port (
        reset       : in std_logic;
        clk_in1     : in std_logic;
        clk_out1    : out std_logic;
        locked      : out std_logic
    );
    end component;
    
    component frcounter is
    generic(
        MAX_COUNT   : natural
    );
    port (
        CLK         : in std_logic;
        DATA_OUT    : out std_logic_vector(natural(ceil(log2(real(MAX_COUNT)))) - 1 downto 0);
        TC          : out std_logic
    );
    end component;
    
    component uart_tx is
    generic(
        DBIT              : integer := 8;   -- Data bits
        SB_TICK           : integer := 16   -- Ticks for stop bits
    );
    port(
        CLK              : in std_logic;
        RST              : in std_logic;
        DIN              : in std_logic_vector(DBIT - 1 downto 0);
        TX_TRIGGER       : in std_logic;
        S_TICK           : in std_logic;
        TX_DONE_TICK     : out std_logic;
        DOUT             : out std_logic
    );
    end component;
    
    component uart_rx is
    generic(
        DBIT          : integer := 8;   -- Data bits
        SB_TICK       : integer := 16   -- Ticks for stop bits
    );
    port(
        CLK           : in std_logic;
        RST           : in std_logic;
        DIN           : in std_logic;
        S_TICK        : in std_logic;
        RX_DONE_TICK  : out std_logic;
        DOUT          : out std_logic_vector(DBIT - 1 downto 0)
    );
    end component;
    
    component display is
    port (
        CLK         : in std_logic;     -- Counts designed for 125MHz
        DATA_IN1    : in std_logic_vector(3 downto 0);
        DATA_IN2    : in std_logic_vector(3 downto 0);
        DATA_IN3    : in std_logic_vector(3 downto 0);
        DATA_IN4    : in std_logic_vector(3 downto 0);
        CAT         : out std_logic_vector(3 downto 0);
        AN          : out std_logic_vector(7 downto 0)
    );
    end component;
    

begin

    MMCM: clk_wiz_0
    port map(
        reset       => RST,
        clk_in1     => CLK,
        clk_out1    => MCLK,
        locked      => locked
    );
    
    -- s_tick generator
    BAUDRATE_GENERATOR : frcounter
    generic map(
        MAX_COUNT   => 250      -- 250 for 400 KHz with 100MHz input clock
    )
    port map(
        CLK         => MCLK,
        DATA_OUT    => open,
        TC          => s_tick
    );
    
    TX_TRIGGER_GENERATOR : frcounter
    generic map(
        MAX_COUNT   => 100000000      -- 1000000 for 100 Hz with 100MHz input clock
    )
    port map(
        CLK         => MCLK,
        DATA_OUT    => count,
        TC          => tx_tick
    );
    
    TX_UNIT : uart_tx
    generic map(
        DBIT              => 8,   -- Data bits
        SB_TICK           => 16   -- Ticks for stop bits
    )
    port map(
        CLK              => MCLK,
        RST              => GRST,
        DIN              => "01010101",
        TX_TRIGGER       => count(16),
        S_TICK           => s_tick,
        TX_DONE_TICK     => open,
        DOUT             => tx_rx
    );
    
    RX_UNIT : uart_rx
    generic map(
        DBIT              => 8,   -- Data bits
        SB_TICK           => 16   -- Ticks for stop bits
    )
    port map(
        CLK               => MCLK,
        RST               => GRST,
        DIN               => tx_rx,
        S_TICK            => s_tick,
        RX_DONE_TICK      => rx_done,
        DOUT              => data
    );
    
    data_reg <= data when rising_edge(MCLK) and rx_done = '1';
    
    DISP: display
    port map(
        CLK         => MCLK,
        DATA_IN1    => "0000",
        DATA_IN2    => "0000",
        DATA_IN3    => data_reg(3 downto 0),
        DATA_IN4    => data_reg(7 downto 4),
        CAT         => CAT,
        AN          => AN
    );

    GRST <= not locked;
    
end Behavioral;