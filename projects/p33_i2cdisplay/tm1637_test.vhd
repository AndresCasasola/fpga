
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     tm1637_test - Behavioral
-- Dependencies:    clk_wiz_0 (core), frcounter.vhd.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity tm1637_test is
  port ( 
    CLK         : in std_logic;
    RST         : in std_logic;
    TX          : in std_logic;
    SCL         : out std_logic;
    SDA         : out std_logic
  );
end tm1637_test;

architecture Behavioral of tm1637_test is

    -- Signals
    signal MCLK             : std_logic;
    signal GRST             : std_logic;
    signal locked           : std_logic;
    
    -- TM1637 driver signals
    signal display_1        : std_logic_vector(7 downto 0);
    signal display_2        : std_logic_vector(7 downto 0);
    signal display_3        : std_logic_vector(7 downto 0);
    signal display_4        : std_logic_vector(7 downto 0);
    signal display_5        : std_logic_vector(7 downto 0);
    signal display_6        : std_logic_vector(7 downto 0);
    signal pulse_width      : std_logic_vector(3 downto 0);
    signal state            : std_logic;
    --signal tx               : std_logic;
    

    component clk_wiz_0 is
        port (
            reset       : in std_logic;
            clk_in1     : in std_logic;
            clk_out1    : out std_logic;
            locked      : out std_logic
        );
    end component;
    
    component tm1637_driver is
        generic(
            DEPTH_BIT       : natural := 8
        );
        port ( 
            CLK             : in std_logic;
            RST             : in std_logic;
            DISPLAY_1       : in std_logic_vector(7 downto 0);
            DISPLAY_2       : in std_logic_vector(7 downto 0);
            DISPLAY_3       : in std_logic_vector(7 downto 0);
            DISPLAY_4       : in std_logic_vector(7 downto 0);
            DISPLAY_5       : in std_logic_vector(7 downto 0);
            DISPLAY_6       : in std_logic_vector(7 downto 0);
            PULSE_WIDTH     : in std_logic_vector(3 downto 0);
            STATE           : in std_logic;
            TX              : in std_logic;
            SDA             : out std_logic;
            SCL             : out std_logic;
            READY           : out std_logic
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
    
    DRIVER: tm1637_driver
        generic map(
            DEPTH_BIT       => 8
        )
        port map( 
            CLK             => MCLK,
            RST             => GRST,
            DISPLAY_1       => "00000000",
            DISPLAY_2       => "00000000",
            DISPLAY_3       => "00000000",
            DISPLAY_4       => "00000000",
            DISPLAY_5       => "00000000",
            DISPLAY_6       => "00000000",
            PULSE_WIDTH     => "0000",
            STATE           => '1',
            TX              => tx,
            SDA             => SDA,
            SCL             => SCL,
            READY           => open
        );

    GRST <= not locked;
    
end Behavioral;