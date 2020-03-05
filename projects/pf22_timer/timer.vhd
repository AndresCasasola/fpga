----------------------------------------------------------------------------------
--
-- Engineer: Andres Casasola Dominguez
-- Github: AndresCasasola

-- Create Date: 02/2020
-- Module Name: timer - Behavioral
-- Dependencies: clk_wiz_0 ipcore, frcounter.vhd, cd4re.vhd, hex7seg.vhd, frcounter_v1.vhd
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity timer is
  port ( 
    CLK         : in std_logic;     -- Counts designed for 125MHz
    RST         : in std_logic;
    CAT         : out std_logic_vector(3 downto 0);
    AN          : out std_logic_vector(7 downto 0)
  );
end timer;

architecture Behavioral of timer is

    -- Signals
    signal MCLK         : std_logic;
    signal GRST         : std_logic;
    signal locked       : std_logic;
    
    signal frc_tc       : std_logic;
    signal Q1, Q2       : std_logic_vector(3 downto 0);
    signal ceo1         : std_logic;
    

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
	
	component frcounter is
        generic(
            MAX_COUNT   : natural
        );
        port (
            CLK         : in std_logic;
            DATA_OUT    : out std_logic_vector(natural(ceil(log2(real(MAX_COUNT)))) - 1 downto 0);
            TC          : out std_logic
        );
    end component frcounter;
    
    component cd4re is
        port (
            CLK         : in std_logic;
            SRST        : in std_logic;
            CE          : in std_logic;
            DATA_OUT    : out std_logic_vector(3 downto 0);
            CEO         : out std_logic;
            TC          : out std_logic
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
    
    FRCOUNT: frcounter
    generic map(
        MAX_COUNT   => 7812500      -- For 62.5ms tick with F_CLK = 125MHz, T_CLK = 8ns
    )
    port map(
        CLK         => MCLK,
        DATA_OUT    => open,
        TC          => frc_tc
    );
    
    BCD1: cd4re
    port map(
        CLK         => MCLK,
        SRST        => GRST,
        CE          => frc_tc,
        DATA_OUT    => Q1,
        CEO         => CEO1,
        TC          => open
    );
    
    BCD2: cd4re
    port map(
        CLK         => MCLK,
        SRST        => GRST,
        CE          => ceo1,
        DATA_OUT    => Q2,
        CEO         => open,
        TC          => open
    );
    
    DISP: display
    port map(
        CLK         => MCLK,
        DATA_IN1    => "0000",
        DATA_IN2    => "0000",
        DATA_IN3    => Q2,
        DATA_IN4    => Q1,
        CAT         => CAT,
        AN          => AN
    );

    GRST <= not locked; 
    
end Behavioral;
