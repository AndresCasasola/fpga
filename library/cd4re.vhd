
----------------------------------------------------------------------------------
--
-- Engineer: 		Andres Casasola Dominguez
-- Github: 			AndresCasasola

-- Create Date: 	02/2020
-- Module Name: 	cd4re - Behavioral
-- Dependencies: 	None
-- Description: 	4-bit cascadable BCD up-counter with habilitation and synchronous reset.	
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cd4re is
    port (
        CLK         : in std_logic;
        SRST        : in std_logic;
        CE          : in std_logic;
        DATA_OUT    : out std_logic_vector(3 downto 0);
        CEO         : out std_logic;
        TC          : out std_logic
    );
end cd4re;

architecture Behavioral of cd4re is

    signal count, next_count : unsigned(3 downto 0);

begin

    -- Register
    process(CLK, SRST)
    begin
        if(CLK'event and CLK = '1') then
            if(SRST = '1') then
                count <= (others => '0');
            elsif(CE = '1') then
                count <= next_count;
            end if;
        end if;
    end process;

    -- Next state logic
    next_count <= count + 1;
    
    -- Output
    DATA_OUT <= std_logic_vector(count);
    TC <= '1' when count = "1111" else '0';
    CEO <= '1' when (count = "1111" and CE = '1') else '0';

end Behavioral;
