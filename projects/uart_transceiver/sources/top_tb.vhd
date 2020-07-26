library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_tb is
--  Port ( );
end top_tb;

architecture Behavioral of top_tb is

    -- Signals
    signal CLK          : std_logic := '0';
    signal RST          : std_logic := '0';
    signal SW           : std_logic_vector(3 downto 0) := (others => '0');
    signal BTN          : std_logic_vector(3 downto 0) := (others => '0');
    signal UART_TX      : std_logic;
    signal UART_RX      : std_logic;

begin

    DUT:
    entity Work.top
    port map( 
        CLK         => CLK,
        RST         => RST,
        SW          => SW,
        BTN         => BTN,
        UART_RX     => UART_RX,
        UART_TX     => UART_TX
    );

    BTN(0)      <= '0', '1' after 20us, '0' after 21us , '1' after 1200us, '0' after 1201us; 
    CLK         <= not(CLK) after 4 ns;
    RST         <= '1', '1' after 10 ns, '0' after 28 ns;
    SW          <= "0100";

end Behavioral;
