library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_tx_tb is
end entity;

architecture behav of uart_tx_tb is

    -- Constants

    -- Signals
    signal CLK          : std_logic := '0';
    signal RST          : std_logic := '0';
    signal tx_trigger   : std_logic := '0';
    signal DOUT         : std_logic;
    
begin

DUT:
entity Work.uart_tx
generic map(
  DBIT          => 8,
  SB_TICK       => 16,
  BAUDRATE      => 9600
)
port map(
  CLK           => CLK,
  RST           => RST,
  DIN           => x"55",
  TX_TRIGGER    => tx_trigger,
  TX_DONE_TICK  => open,
  DOUT          => DOUT
);

    CLK   <= not(CLK) after 4 ns;
    RST <= '1', '1' after 10 ns, '0' after 28 ns;
    tx_trigger <= '0', '1' after 20000ns, '0' after 20008ns , '1' after 1200000ns, '0' after 1200008ns;
    
end architecture;