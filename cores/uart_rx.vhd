
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     uart_rx - Behavioral
-- Dependencies:    None
-- Description:     UART receiver.
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_rx is
    generic(
      DBIT          : integer := 8;     -- Data bits
      SB_TICK       : integer := 16;    -- Ticks for stop bits
      BAUDRATE      : integer := 9600   -- Baudrate
    );
    port(
      CLK           : in std_logic;
      RST           : in std_logic;
      DIN           : in std_logic;
      RX_DONE_TICK  : out std_logic;
      DOUT          : out std_logic_vector(DBIT - 1 downto 0)
    );
end uart_rx ;


architecture arch of uart_rx is
    
    -- Types:
    type state_type is (idle, start, data, stop);
    
    -- Constants:
   constant T_BAUDRATE              : integer := 125000000 / (16 * BAUDRATE);   -- Periodo de 16 * baudrate. Sobremuestreo x16.
    
    --Signals:
    signal tick                     : std_logic;
    signal baudrate_counter         : unsigned(19 downto 0);    -- Up to 1.048.576. Enough for 921.600?
    signal state_reg, state_next: state_type;
    signal s_reg, s_next: unsigned(3 downto 0);
    signal n_reg, n_next: unsigned(2 downto 0);
    signal b_reg, b_next: std_logic_vector(7 downto 0);
    
begin
   
    -- Baudrate generator
    process(CLK, RST)
    begin
        if(RST = '1') then
            baudrate_counter <= (others => '0');
        elsif(CLK'event and CLK = '1') then
            if (baudrate_counter = T_BAUDRATE) then
                baudrate_counter <= (others => '0');
            else
                baudrate_counter <= baudrate_counter + 1;
            end if; 
        end if;
    end process;
    
    tick <= '1' when baudrate_counter = T_BAUDRATE else '0';
   
    -- FSMD state & data registers
    process(CLK, RST)
    begin
        if RST='1' then
            state_reg <= idle;
            s_reg <= (others=>'0');
            n_reg <= (others=>'0');
            b_reg <= (others=>'0');
        elsif (CLK'event and CLK='1') then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;
   
    -- next-state logic & data path functional units/routing
    process(state_reg,s_reg,n_reg,b_reg,tick,DIN)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        RX_DONE_TICK <='0';
        
        case state_reg is
            when idle =>
                if DIN='0' then
                    state_next <= start;
                    s_next <= (others=>'0');
                end if;
            when start =>
            if (tick = '1') then
               if s_reg=7 then
                    state_next <= data;
                    s_next <= (others=>'0');
                    n_next <= (others=>'0');
               else
                  s_next <= s_reg + 1;
               end if;
            end if;
            when data =>
                if (tick = '1') then
                    if s_reg=15 then
                        s_next <= (others=>'0');
                        b_next <= DIN & b_reg(7 downto 1) ;
                        if n_reg=(DBIT-1) then
                            state_next <= stop ;
                        else
                            n_next <= n_reg + 1;
                        end if;
                    else
                      s_next <= s_reg + 1;
                    end if;
                end if;
            when stop =>
                if (tick = '1') then
                    if s_reg=(SB_TICK-1) then
                        state_next <= idle;
                        RX_DONE_TICK <='1';
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;
        end case;
    end process;
   
   DOUT <= b_reg;
   
end arch;




