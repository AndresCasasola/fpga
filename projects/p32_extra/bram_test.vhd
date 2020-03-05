
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     bram_test - Behavioral
-- Dependencies:    debouncer.vhd (core), bram.vhd, display.vhd (core).
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity bram_test is
  port ( 
    CLK             : in std_logic;     -- Counts designed for 125MHz
    RST             : in std_logic;
    SW              : in std_logic_vector(3 downto 0);          
    BTN_ADDR        : in std_logic;
    BTN_WRITE       : in std_logic;
    BTN_READ        : in std_logic;
    CAT             : out std_logic_vector(3 downto 0);
    AN              : out std_logic_vector(7 downto 0)
  );
end bram_test;

architecture Behavioral of bram_test is

    -- Signals
    signal MCLK         : std_logic;
    signal GRST         : std_logic;
    signal locked       : std_logic;
    
    signal addr_reg     : std_logic_vector(3 downto 0);
    signal dout         : std_logic_vector(3 downto 0);
    signal fbtn_addr    : std_logic;
    signal fbtn_write   : std_logic;
    

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

    component bram is
        generic(
            DEPTH       : natural := 4;
            WIDTH       : natural := 8
        );
        port (
            CLK         : in std_logic;
            CE          : in std_logic;
            WE          : in std_logic;
            RST         : in std_logic;
            ADDR        : in std_logic_vector(DEPTH-1 downto 0);
            DIN         : in std_logic_vector(WIDTH-1 downto 0);
            DOUT        : out std_logic_vector(WIDTH-1 downto 0)
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

    addr_reg <= SW when rising_edge(MCLK) and fbtn_addr = '1';

    MMCM: clk_wiz_0
    port map(
        reset       => RST,
        clk_in1     => CLK,
        clk_out1    => MCLK,
        locked      => locked
    );
    
    DEBOUNCER_ADDR: debouncer 
    port map(
        CLK         => MCLK,
        RST         => GRST,
        CE          => '1',
        BTN         => BTN_ADDR,
        DOUT        => fbtn_addr
    );
    
    DEBOUNCER_WRITE: debouncer 
    port map(
        CLK         => MCLK,
        RST         => GRST,
        CE          => '1',
        BTN         => BTN_WRITE,
        DOUT        => fbtn_write
    );
    
    BLOCKRAM: bram
        generic map(
            DEPTH   => 4,
            WIDTH   => 4
        )
        port map(
            CLK     => MCLK,
            CE      => '1',
            WE      => fbtn_write,
            RST     => GRST,
            ADDR    => addr_reg,
            DIN     => SW,
            DOUT    => dout
        );
    
    DISP: display
        port map(
            CLK         => MCLK,
            DATA_IN1    => "0000",
            DATA_IN2    => "0000",
            DATA_IN3    => "0000",
            DATA_IN4    => dout,
            CAT         => CAT,
            AN          => AN
        );

    GRST <= not locked; 
    
end Behavioral;
