
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     06/2020
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
    CAT         : out std_logic_vector(3 downto 0);
    AN          : out std_logic_vector(7 downto 0);
    PWM         : out std_logic
  );
end top;

architecture Behavioral of top is

    -- Signals
    signal MCLK             : std_logic;
    signal GRST             : std_logic;
    signal locked           : std_logic;
    signal pwm_reg          : std_logic;
    signal dc_reg           : std_logic_vector(21 downto 0);
    

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

    -- Inputs 
    GRST <= not locked;
    dc_reg <= std_logic_vector(unsigned("00000" & SW & "0000000000000") + to_unsigned(125000, 22));   -- SW * 2^13

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

    PWM_UNIT:
    entity work.pwm
    generic map(
        SIZE            => 22   -- Up to 4.194.304 -> Enough for 2.500.000 (20ms period)
    )
    port map(
        CLK             => CLK,
        SRST            => GRST,
        DUTY_CYCLE      => dc_reg,
        PERIOD          => std_logic_vector(to_unsigned(2500000, 22)),
        DOUT            => pwm_reg
    );
    
    PWM <= pwm_reg;
    
end Behavioral;
