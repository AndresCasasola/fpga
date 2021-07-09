
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     06/2020
-- Module Name:     top - Behavioral
-- Dependencies:    clk_wiz_0 (core), display.vhd (core).
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity top is
  port ( 
    CLK         : in std_logic;     -- Counts designed for 125MHz
    RST         : in std_logic;
    CAT         : out std_logic_vector(3 downto 0);
    AN          : out std_logic_vector(7 downto 0)
  );
end top;

architecture Behavioral of top is

    -- Signals
    signal MCLK         : std_logic;
    signal GRST         : std_logic;
    signal locked       : std_logic;
    

    component clk_wiz_0 is
        port (
            reset       : in std_logic;
            clk_in1     : in std_logic;
            clk_out1    : out std_logic;
            locked      : out std_logic
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
    
    DISP: display
    port map(
        CLK         => MCLK,
        DATA_IN1    => "0001",
        DATA_IN2    => "0010",
        DATA_IN3    => "0100",
        DATA_IN4    => "1000",
        CAT         => CAT,
        AN          => AN
    );

    GRST <= not locked; 
    
end Behavioral;
