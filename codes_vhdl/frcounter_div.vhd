
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     frcounter_div - Behavioral
-- Dependencies:    None
-- Description:     Generic free running up-counter with divided count output.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity frcounter_div is
    generic(
        SIZE    : natural
    );
    port (
        CLK         : in std_logic;
        DATA_OUT    : out std_logic_vector(1 downto 0)
    );
end frcounter_div;

architecture Behavioral of frcounter_div is

    signal count_reg, count_next : unsigned(SIZE - 1 downto 0);

begin

    -- Register
    process(CLK)
    begin
        if(CLK'event and CLK = '1') then
            count_reg <= count_next;
        end if;
    end process;

    -- Next state logic
    count_next <= count_reg + 1;
    
    -- Output
    DATA_OUT <= std_logic_vector(count_reg(SIZE - 1 downto SIZE - 2));

end Behavioral;
