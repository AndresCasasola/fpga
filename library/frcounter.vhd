
----------------------------------------------------------------------------------
--
-- Engineer: 		Andres Casasola Dominguez
-- Github:			AndresCasasola

-- Create Date: 	02/2020
-- Module Name: 	frcounter - Behavioral
-- Dependencies: 	None
-- Description: 	Generic free running up-counter with no habilitation and no initialization.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;

use IEEE.NUMERIC_STD.ALL;

entity frcounter is
    generic(
        MAX_COUNT   : natural
    );
    port (
        CLK         : in std_logic;
        DATA_OUT    : out std_logic_vector(natural(ceil(log2(real(MAX_COUNT)))) - 1 downto 0);
        TC          : out std_logic
    );
end frcounter;

architecture Behavioral of frcounter is

    signal count_reg, count_next : unsigned (natural(ceil(log2(real(MAX_COUNT)))) - 1 downto 0);

begin

    -- State register
    count_reg <= count_next when rising_edge(CLK);

    -- Next state logic
    count_next <= count_reg + 1 when count_reg /= MAX_COUNT else (others => '0');
    
    -- Output logic
    TC  <= '1' when count_reg = MAX_COUNT else '0';
    
    -- Output
    DATA_OUT <= std_logic_vector(count_reg);

end Behavioral;
