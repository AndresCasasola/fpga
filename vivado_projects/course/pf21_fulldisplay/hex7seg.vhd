----------------------------------------------------------------------------------
--
-- Engineer: Andres Casasola Dominguez
-- Github: AndresCasasola

-- Create Date: 02/2020
-- Module Name: hex7seg - Behavioral
-- Dependencies:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex7seg is
  Port (
    DATA_IN     : in std_logic_vector(3 downto 0);
    DATA_OUT    : out std_logic_vector(7 downto 0)
  );
end hex7seg;

architecture Behavioral of hex7seg is

begin

    process(DATA_IN)
    begin
        case DATA_IN is
            when "0000" => DATA_OUT <= "11111100";  -- 0    -- Format is "abcdefgp"
            when "0001" => DATA_OUT <= "01100000";  -- 1
            when "0010" => DATA_OUT <= "11011010";  -- 2
            when "0011" => DATA_OUT <= "11110010";  -- 3
            when "0100" => DATA_OUT <= "01100110";  -- 4
            when "0101" => DATA_OUT <= "10110110";  -- 5
            when "0110" => DATA_OUT <= "10111110";  -- 6
            when "0111" => DATA_OUT <= "11100000";  -- 7
            when "1000" => DATA_OUT <= "11111110";  -- 8
            when "1001" => DATA_OUT <= "11110110";  -- 9
            when "1010" => DATA_OUT <= "11101110";  -- A
            when "1011" => DATA_OUT <= "00111110";  -- b
            when "1100" => DATA_OUT <= "10011100";  -- C
            when "1101" => DATA_OUT <= "01111010";  -- d
            when "1110" => DATA_OUT <= "10011110";  -- E
            when "1111" => DATA_OUT <= "10001110";  -- F
            when others => DATA_OUT <= "00000000";  -- Default
        end case;
    end process;


end Behavioral;