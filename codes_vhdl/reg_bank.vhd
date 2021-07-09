
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     reg_bank - Behavioral
-- Dependencies:    None
-- Description:     Registers bank memory.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg_bank is
    port (
        CLK         : in std_logic;
        SRST        : in std_logic;
        WE          : in std_logic;
        W_ADDR      : in std_logic_vector(1 downto 0);
        R_ADDR      : in std_logic_vector(1 downto 0);
        W_DATA      : in std_logic_vector(7 downto 0);
        R_DATA      : out std_logic_vector(7 downto 0) 
    );
end reg_bank;

architecture Behavioral of reg_bank is

    type mem_t is array (3 downto 0) of std_logic_vector(7 downto 0);
    
    signal mem : mem_t;

begin

    -- Register
    process(CLK, SRST)
    begin
        if (SRST = '1') then
            mem <= (others => (others => '0'));
        elsif rising_edge(CLK) then
            if (WE = '1') then
                mem(to_integer(unsigned(W_ADDR))) <= W_DATA;
            end if;
        end if;
    end process;
    
    -- Output
    R_DATA <= mem(to_integer(unsigned(R_ADDR)));

end Behavioral;
