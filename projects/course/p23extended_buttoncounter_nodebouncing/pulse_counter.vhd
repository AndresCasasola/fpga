----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 09:50:01 PM
-- Design Name: 
-- Module Name: pulse_counter - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pulse_counter is
    generic (
        SIZE        : natural
    );
    port (
        RST         : in std_logic;
        DATA_IN     : in std_logic;
        DATA_OUT    : out std_logic_vector(SIZE - 1 downto 0)
    );
end pulse_counter;

architecture Behavioral of pulse_counter is

    signal count : unsigned (SIZE - 1 downto 0);

begin

    process (DATA_IN , RST)
    begin
        if (RST = '1') then
            count <= (others => '0');
        elsif (DATA_IN'event and DATA_IN = '1') then
            count <= count + 1;
        end if;
    end process;

    DATA_OUT <= std_logic_vector(count);

end Behavioral;
