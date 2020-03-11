
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     debouncer - Behavioral
-- Dependencies:    frcounter.vhd, edge_detector.vhd, glitch_filter.vhd
-- Description:     Debouncer core for mechanical buttons filtering.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

entity debouncer is
  port (
    CLK         : in std_logic;
    RST         : in std_logic;
    CE          : in std_logic;
    BTN         : in std_logic;
    DOUT        : out std_logic
  );
end debouncer;

architecture Behavioral of debouncer is

    -- Signals
    signal level    : std_logic;
    signal tick     : std_logic;
	
	-- Edge Detector
	component edge_detector is
	   port (
	       CLK         :   in std_logic;
	       RST         :   in std_logic;
	       CE          :   in std_logic;
	       DATA_IN     :   in std_logic;
	       DATA_OUT    :   out std_logic
	   );
	end component edge_detector;
    
    -- Free Running Counter
    component frcounter is
        generic(
            MAX_COUNT   : natural
        );
        port(
            CLK         : in std_logic;
            DATA_OUT    : out std_logic_vector(natural(ceil(log2(real(MAX_COUNT)))) - 1 downto 0);
            TC          : out std_logic
        );
    end component;
    
    -- Glitch Filter
    component glitch_filter is
        port (
            CLK         : in std_logic;
            RST         : in std_logic;
            CE          : in std_logic;
            TICK        : in std_logic;
            DATA_IN     : in std_logic;
            DATA_OUT    : out std_logic
        );
    end component glitch_filter;
    
begin
    
    EDGE_DET: edge_detector
    port map(
        CLK         => CLK,
        RST         => RST,
        CE          => CE,
        DATA_IN     => level,
        DATA_OUT    => DOUT
    );
    
    COUNTER10ms: frcounter
        generic map(
            MAX_COUNT   => 1000000  -- For 10ms at FCLK = 100MHz
        )
        port map(
            CLK         => CLK,
            DATA_OUT    => open,
            TC          => tick
        );
    
    GLITCH_FILT: glitch_filter
    port map(
        CLK         => CLK,
        RST         => RST,
        CE          => CE,
        TICK        => tick,
        DATA_IN     => BTN,
        DATA_OUT    => level
    );
    
    
    
end Behavioral;
