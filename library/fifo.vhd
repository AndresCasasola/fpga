
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     fifo - Behavioral
-- Dependencies:    None
-- Description:     Fifo memory.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.math_real.all;

entity fifo is
  generic(
    B         : natural := 2;       -- Bus size
    W         : natural := 4        -- Width size
  );
  port ( 
    CLK         : in std_logic;
    RST         : in std_logic;
    DIN         : in std_logic_vector(W-1 downto 0);
    PUSH        : in std_logic;
    FULL        : out std_logic;
    DOUT        : out std_logic_vector(W-1 downto 0);
    POP         : in std_logic;
    EMPTY       : out std_logic
  );
end fifo;

architecture Behavioral of fifo is

    type mem_t is array ((2**B)-1 downto 0) of std_logic_vector(W-1 downto 0);
    
    signal mem                      : mem_t := (x"0",x"0",x"0",x"0");
    --signal waddr, raddr             : unsigned(B-1 downto 0);
    signal we, re                   : std_logic;
    signal wptr, rptr               : unsigned(B-1 downto 0);
    signal count                    : unsigned(B downto 0);
    signal full_reg, empty_reg      : std_logic;
    
begin
    
    -- Write
    mem(to_integer(unsigned(wptr))) <= DIN when (rising_edge(CLK) and we = '1');
    -- Read
    DOUT <= mem(to_integer(unsigned(rptr))) when re = '1';
    
    -- Write/Read enable logic
    we <= '1' when (PUSH = '1' and full_reg = '0') else '0';
    re <= '1' when (POP = '1' and empty_reg = '0') else '0';
    
    -- Pointers and count
    process
    begin
        wait until rising_edge(CLK);
        if (RST = '1') then
            -- Reset pointers and count
            wptr <= (others => '0');
            rptr <= (others => '0');
            count <= (others => '0');
        else
            -- Pointers and count increment
            if (we = '1') then
                wptr <= wptr + 1;
            end if;
            if (re = '1') then
                rptr <= rptr + 1;
            end if;
            if (we = '1' and re = '0') then
                count <= count + 1;
            end if;
            if (we = '0' and re = '1') then
                count <= count - 1;
            end if;
        end if;
    end process;
    
    -- State
    empty_reg <= '1' when count = 0 else '0';
    full_reg <= '1' when count = ((2**B)) else '0';
    
    -- Output
    EMPTY <= empty_reg;
    FULL <= full_reg;
    
end Behavioral;