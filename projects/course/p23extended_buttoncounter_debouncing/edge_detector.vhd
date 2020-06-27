----------------------------------------------------------------------------------
-- Company: 
-- Engineer:
-- 
-- Create Date: 02/28/2020 09:14:08 PM
-- Design Name: 
-- Module Name: edge_detector - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity edge_detector is
    port (
        CLK         : in std_logic;
        RST         : in std_logic;
        CE          : in std_logic;
        DATA_IN     : in std_logic;
        DATA_OUT    : out std_logic
    );
end edge_detector;

architecture Behavioral of edge_detector is

    type state is (ZERO, ONE);
    signal state_reg, state_next : state;

begin

    -- State register
    process
    begin
        wait until rising_edge(CLK);
        state_reg <= ZERO;  -- Default assignment
        if (RST = '1') then
            state_reg <= ZERO;
        elsif (CE = '1') then
            state_reg <= state_next;
        end if; 
    end process;
    
    -- Next state logic
    process (state_reg, DATA_IN)
    begin
        state_next <= ZERO;   -- Default assignment
        case state_reg is
            when ZERO =>
                if (DATA_IN = '1') then
                    state_next <= ONE;
                else
                    state_next <= ZERO;
                end if;
            when ONE => 
                if (DATA_IN = '1') then
                    state_next <= ONE;
                else
                    state_next <= ZERO;
                end if;
            when OTHERS =>
                state_next <= ZERO;
        end case;
    end process;
    
    -- Mealy output logic
    DATA_OUT <= '1' when (state_reg = ZERO and DATA_IN = '1') else '0';
        
end Behavioral;
