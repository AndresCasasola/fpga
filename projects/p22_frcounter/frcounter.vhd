----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2020 11:27:42 AM
-- Design Name: 
-- Module Name: frcounter - Behavioral
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

entity frcounter is
    generic(
        SIZE    : natural
    );
    port (
        CLK         : in std_logic;
        CE          : in std_logic;
        DATA_OUT    : out std_logic_vector(SIZE - 1 downto 0);
        TC          : out std_logic;
        CEO         : out std_logic
    );
end frcounter;

architecture Behavioral of frcounter is

    signal count_reg, count_next : unsigned(SIZE - 1 downto 0);
    constant max_count           : natural := (2**SIZE); 

begin

    -- Registro
    process(CLK)
    begin
        if(CLK'event and CLK = '1') then
            count_reg <= count_next;
        end if;
    end process;

    -- Logica de estado siguiente
    count_next <= count_reg + 1;
    
    -- Logica de salida
    TC  <= '1' when count_reg = max_count - 1 else '0';
    CEO <= '1' when (count_reg = max_count - 1 and CE = '1') else '0';
    
    -- Salida
    DATA_OUT <= std_logic_vector(count_reg);

end Behavioral;
