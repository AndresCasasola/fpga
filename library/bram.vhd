
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     bram - Behavioral
-- Dependencies:    None
-- Description:     BRAM memory.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bram is
    generic(
        DEPTH       : natural;
        WIDTH       : natural
    );
    port (
        CLK         : in std_logic;
        CE          : in std_logic;
        WE          : in std_logic;
        RST         : in std_logic;
        ADDR        : in std_logic_vector(DEPTH-1 downto 0);
        DIN         : in std_logic_vector(WIDTH-1 downto 0);
        DOUT        : out std_logic_vector(WIDTH-1 downto 0)
    );
end bram;

architecture Behavioral of bram is

    type mem_t is array ((2**DEPTH)-1 downto 0) of std_logic_vector(WIDTH-1 downto 0);
    
    signal mem : mem_t;

begin

    -- Register
    process(CLK)
    begin
        if rising_edge(CLK) then
            if (CE = '1') then
                if (WE = '1') then
                    mem(to_integer(unsigned(ADDR))) <= DIN;    -- Write
                end if;
                if (RST = '1') then
                    DOUT <= (others => '0');
                else
                    DOUT <= mem(to_integer(unsigned(ADDR)));   -- Read
                end if;
            end if; 
        end if;
    end process;

end Behavioral;
