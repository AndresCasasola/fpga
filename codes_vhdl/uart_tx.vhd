
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

--UART_TX_UNIT:
--entity Work.uart_tx
--generic map(
--  DBIT          => 8,
--  SB_TICK       => 16,
--  BAUDRATE      => 9600
--)
--port map(
--  CLK           => CLK,
--  RST           => RST,
--  DIN           => DIN,
--  TX_TRIGGER    => TX_TRIGGER,
--  TX_DONE_TICK  => TX_DONE_TICK,
--  DOUT          => DOUT
--);

entity uart_tx is
   generic(
      DBIT          : integer := 8;         -- Data bits
      SB_TICK       : integer := 16;        -- Ticks for stop bits
      BAUDRATE      : integer := 9600       -- Baudrate
   );
   port(
      CLK           : in std_logic;
      RST           : in std_logic;
      DIN           : in std_logic_vector(DBIT - 1 downto 0);
      TX_TRIGGER    : in std_logic;
      TX_DONE_TICK  : out std_logic;
      DOUT          : out std_logic
   );
end uart_tx;


architecture arch of uart_tx is
   
   -- Types:
   type state_t is (idle, synch, start, data, stop);
   
   -- Constants:
   constant T_BAUDRATE              : integer := 125000000 / (16 * BAUDRATE);   -- Periodo de 16 * baudrate. Sobremuestreo x16.
   
   -- Signals:
    signal tick                     : std_logic;
    signal baudrate_counter         : unsigned(19 downto 0);    -- Up to 1.048.576. Enough for 921.600?
    signal state_reg, state_next    : state_t;
    signal s_reg, s_next            : unsigned(3 downto 0);
    signal n_reg, n_next            : unsigned(3 downto 0);
    signal din_reg, din_next        : std_logic_vector(DBIT - 1 downto 0);
    signal dout_reg, dout_next      : std_logic;
   
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
        if (RST = '1') then
            state_reg <= idle;
            n_reg <= (others=>'0');
            s_reg <= (others=>'0');
            din_reg <= (others=>'0');
            dout_reg <= '0';
        elsif (CLK'event and CLK = '1') then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            din_reg <= din_next;
            dout_reg <= dout_next;
      end if;
    end process;
    
    -- next-state logic & data path functional units/routing
    process(state_reg, TX_TRIGGER, tick, s_reg, n_reg, din_reg)
    begin
        state_next <= state_reg;
        n_next <= n_reg;
        s_next <= s_reg;
        din_next <= din_reg;
        TX_DONE_TICK <='0';
          
        case state_reg is
            when idle =>
                dout_next <= '1';
                if (TX_TRIGGER = '1') then
                    state_next <= synch;
                end if;
            when synch =>
                dout_next <= '1';
                if (tick = '1') then
                    din_next <= DIN;
                    s_next <= (others=>'0');
                    n_next <= (others=>'0');
                    state_next <= start;
                end if;
            
            when start =>
                dout_next <= '0';
                if (tick = '1') then
                    if (s_reg = 15) then
                        state_next <= data;
                        dout_next <= din_reg(to_integer(n_reg));
                        n_next <= n_reg + 1;
                        s_next <= (others=>'0');
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;
            
            when data =>
                if (tick = '1') then
                    if (s_reg = 15) then
                        s_next <= (others => '0');
                        --dout_next <= din_reg(to_integer(n_reg));
                        if (n_reg = (DBIT)) then
                            dout_next <= '1';
                            state_next <= stop;
                        else
                            dout_next <= din_reg(to_integer(n_reg));
                            n_next <= n_reg + 1;
                        end if;
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;
            
            when stop =>
                dout_next <= '1';
                if (tick = '1') then
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
    
    -- Outputs
    DOUT <= dout_reg;

end arch;




