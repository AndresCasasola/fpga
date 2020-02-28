----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2020 04:41:09 PM
-- Design Name: 
-- Module Name: test - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test is
  port ( 
    jd_p    : out std_logic_vector(3 downto 0);
    jd_n    : out std_logic_vector(3 downto 0);
    je      : out std_logic_vector(7 downto 0);
    SW      : in std_logic_vector(3 downto 0)    
  );
end test;

architecture Behavioral of test is

    -- Signals
    signal data_out : std_logic_vector(7 downto 0);


    component hex7seg is
		port (
            DATA_IN     : in std_logic_vector(3 downto 0);
            DATA_OUT    : out std_logic_vector(7 downto 0)
		);
	end component hex7seg;

    -- Alias
    alias d3    : std_logic is jd_p(1);
    alias d4    : std_logic is jd_p(3);
    alias f     : std_logic is jd_n(1);
    alias a     : std_logic is jd_n(3);
    alias c     : std_logic is je(0);
    alias point : std_logic is je(1);
    alias b     : std_logic is je(2);
    alias d2    : std_logic is je(3);
    alias e     : std_logic is je(4);
    alias d1    : std_logic is je(5);
    alias d     : std_logic is je(6);
    alias g     : std_logic is je(7);
    

begin

    DECODER: hex7seg
    port map(
        DATA_IN     => SW,
        DATA_OUT    => data_out
    );

    d1 <= '1';
    d2 <= '1';
    d3 <= '1';
    d4 <= '0';  -- Turn on display 4

    a <= data_out(7);
    b <= data_out(6);
    c <= data_out(5);
    d <= data_out(4);
    e <= data_out(3);
    f <= data_out(2);
    g <= data_out(1);
    point <= data_out(0);
    
end Behavioral;
