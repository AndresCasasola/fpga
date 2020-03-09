
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     generic_top - Behavioral
-- Dependencies:    clk_wiz_0 (core), display.vhd (core).
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity fifo_test is
  port ( 
    CLK         : in std_logic;     -- Counts designed for 125MHz
    RST         : in std_logic;
    BTN_PUSH    : in std_logic;
    BTN_POP     : in std_logic;
    SW          : in std_logic_vector(3 downto 0);
    CAT         : out std_logic_vector(3 downto 0);
    AN          : out std_logic_vector(7 downto 0)
  );
end fifo_test;

architecture Behavioral of fifo_test is

    -- Signals
    signal MCLK         : std_logic;
    signal GRST         : std_logic;
    signal locked       : std_logic;
    
    signal data         : std_logic_vector(3 downto 0);
    signal fbtn_push    : std_logic;
    signal fbtn_pop     : std_logic;

    component clk_wiz_0 is
        port (
            reset       : in std_logic;
            clk_in1     : in std_logic;
            clk_out1    : out std_logic;
            locked      : out std_logic
        );
    end component;
    
    component debouncer is
    port (
        CLK         : in std_logic;
        RST         : in std_logic;
        CE          : in std_logic;
        BTN         : in std_logic;
        DOUT        : out std_logic
    );
    end component;
    
    component fifo is
      generic(
        B         : natural := 2;       -- Bus size
        W         : natural := 4        -- Width size
      );
      port ( 
        CLK         : in std_logic;
        RST         : in std_logic;
        DIN         : in std_logic_vector(W-1 downto 0);
        PUSH        : in std_logic;
        FULL        : out std_logic;
        DOUT        : out std_logic_vector(W-1 downto 0);
        POP         : in std_logic;
        EMPTY       : out std_logic
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
    
    DEBOUNCER_PUSH: debouncer 
    port map(
        CLK         => MCLK,
        RST         => GRST,
        CE          => '1',
        BTN         => BTN_PUSH,
        DOUT        => fbtn_push
    );
    
    DEBOUNCER_POP: debouncer 
    port map(
        CLK         => MCLK,
        RST         => GRST,
        CE          => '1',
        BTN         => BTN_POP,
        DOUT        => fbtn_pop
    );
    
    FIFO1: fifo
      generic map(
        B         => 2,
        W         => 4
      )
      port map( 
        CLK         => MCLK,
        RST         => GRST,
        DIN         => SW,
        PUSH        => fbtn_push,
        FULL        => open,
        DOUT        => data,
        POP         => fbtn_pop,
        EMPTY       => open
      );
    
    DISP: display
    port map(
        CLK         => MCLK,
        DATA_IN1    => "0000",
        DATA_IN2    => "0000",
        DATA_IN3    => "0000",
        DATA_IN4    => data,
        CAT         => CAT,
        AN          => AN
    );

    GRST <= not locked; 
    
end Behavioral;
