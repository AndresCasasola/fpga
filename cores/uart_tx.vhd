
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     uart_tx - Behavioral
-- Dependencies:    None
-- Description:     UART transmitter.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uart_tx is
   generic(
      DBIT: integer         := 8;   -- Data bits
      SB_TICK: integer      := 16   -- Ticks for stop bits
   );
   port(
      CLK           : in std_logic;
      RST           : in std_logic;
      DIN           : in std_logic_vector(DBIT - 1 downto 0);
      TX_TRIGGER    : in std_logic;
      S_TICK        : in std_logic;
      TX_DONE_TICK  : out std_logic;
      DOUT          : out std_logic
   );
end uart_tx;


architecture arch of uart_tx is
   
    type state_t is (idle, start, data, stop);
    signal state_reg, state_next     : state_t;
    signal s_reg, s_next             : unsigned(3 downto 0);
    signal n_reg, n_next             : unsigned(3 downto 0);
    signal din_reg, din_next         : std_logic_vector(DBIT - 1 downto 0);
   
begin
    
    -- FSMD state & data registers
    process(CLK, RST)
    begin
        if (RST = '1') then
            state_reg <= idle;
            n_reg <= (others=>'0');
            s_reg <= (others=>'0');
            din_reg <= (others=>'0');
        elsif (CLK'event and CLK = '1') then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            din_reg <= din_next;
      end if;
    end process;
    
    -- next-state logic & data path functional units/routing
    process(state_reg, TX_TRIGGER, S_TICK, s_reg, n_reg, din_reg)
    begin
        state_next <= state_reg;
        n_next <= n_reg;
        s_next <= s_reg;
        din_next <= din_reg;
        TX_DONE_TICK <='0';
          
        case state_reg is
            when idle =>
                DOUT <= '1';
                if (S_TICK = '1' and TX_TRIGGER = '1') then
                    din_next <= DIN;
                    s_next <= (others=>'0');
                    n_next <= (others=>'0');
                    state_next <= start;
                end if;
            
            when start =>
                DOUT <= '0';
                if (S_TICK = '1') then
                    if (s_reg = 15) then
                        state_next <= data;
                        DOUT <= din_reg(0);
                        n_next <= n_reg + 1;
                        s_next <= (others=>'0');
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;
            
            when data =>
                if (S_TICK = '1') then
                    if (s_reg = 15) then
                        s_next <= (others => '0');
                        DOUT <= din_reg(to_integer(n_reg));
                        if (n_reg = (DBIT-1)) then
                            state_next <= stop;
                        else
                            n_next <= n_reg + 1;
                        end if;
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;
            
            when stop =>
                if (S_TICK = '1') then
                   if (s_reg = (SB_TICK-1)) then
                      state_next <= idle;
                      TX_DONE_TICK <= '1';
                   else
                      s_next <= s_reg + 1;
                   end if;
                end if;
            
            when others =>
                state_next <= state_reg;
            
        end case;
    end process;

end arch;




