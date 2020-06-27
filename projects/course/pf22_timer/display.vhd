----------------------------------------------------------------------------------
--
-- Engineer: Andres Casasola Dominguez
-- Github: AndresCasasola

-- Create Date: 02/2020
-- Module Name: display - Behavioral
-- Dependencies: hex7seg.vhd, frcounter_v1.vhd 
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display is
  port ( 
    CLK         : in std_logic;                     -- Counts designed for 125MHz
    DATA_IN1    : in std_logic_vector(3 downto 0);
    DATA_IN2    : in std_logic_vector(3 downto 0);
    DATA_IN3    : in std_logic_vector(3 downto 0);
    DATA_IN4    : in std_logic_vector(3 downto 0);
    CAT         : out std_logic_vector(3 downto 0);
    AN          : out std_logic_vector(7 downto 0)
  );
end display;

architecture Behavioral of display is

    -- Signals
    signal hexdata      : std_logic_vector(3 downto 0);
    signal demdata      : std_logic_vector(7 downto 0);
    signal sel          : std_logic_vector(1 downto 0);
    --signal MCLK         : std_logic;
    --signal locked       : std_logic;
    --signal rst          : std_logic;
    
    -- Constants
--    constant data1      : std_logic_vector(3 downto 0) := "0000";
--    constant data2      : std_logic_vector(3 downto 0) := "0001";
--    constant data3      : std_logic_vector(3 downto 0) := "0010";
--    constant data4      : std_logic_vector(3 downto 0) := "0011";

--    component clk_wiz_0 is
--        port (
--            reset       : in std_logic;
--            clk_in1     : in std_logic;
--            clk_50MHz   : out std_logic;
--            locked      : out std_logic
--        );
--    end component;

    component hex7seg is
		port (
            DATA_IN     : in std_logic_vector(3 downto 0);
            DATA_OUT    : out std_logic_vector(7 downto 0)
		);
	end component hex7seg;
	
	component frcounter_v1 is
        generic(
            SIZE    : natural
        );
        port (
            CLK         : in std_logic;
            DATA_OUT    : out std_logic_vector(1 downto 0)
        );
    end component frcounter_v1;
    
begin

--    MMCM: clk_wiz_0
--    port map(
--        reset       => BTN(3),
--        clk_in1     => CLK,
--        clk_50MHz   => MCLK,
--        locked      => locked
--    );

    DECODER: hex7seg
    port map(
        DATA_IN     => hexdata,
        DATA_OUT    => demdata
    );
    
    COUNTER : frcounter_v1
    generic map(
        SIZE => 19  -- 19 for 2 ms, 27 for 0.25s
    )
    port map(
        CLK         => CLK,
        DATA_OUT    => sel
    );

    -- Demux 2 to 4 for cathodes
    process (sel)
    begin
        case sel is
            when "00" =>
                --CAT <= "0111";  -- Turn on display 1
                CAT <= "1111";  -- Turn off all displays
            when "01" =>
                --CAT <= "1011";  -- Turn on display 2
                CAT <= "1111";  -- Turn off all displays
            when "10" =>
                CAT <= "1101";  -- Turn on display 3
            when "11" =>
                CAT <= "1110";  -- Turn on display 4
            when others => 
                CAT <= "1111";  -- Turn off all displays
        end case;
    end process;
    
    -- Mux 4 to 1 for anodes
    process (sel)
    begin
        case sel is
            when "00" =>
                hexdata <= DATA_IN1; 
            when "01" =>
                hexdata <= DATA_IN2;
            when "10" =>
                hexdata <= DATA_IN3;
            when "11" =>
                hexdata <= DATA_IN4;
            when others => 
                hexdata <= (others => '0');
        end case;
    end process;

    AN <= demdata;
    --rst <= not locked; 
    
end Behavioral;
