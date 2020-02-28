----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/27/2020 07:57:10 PM
-- Design Name: 
-- Module Name: fsm - Behavioral
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

entity fsm is
    port (
        CLK     : in std_logic;
        RST     : in std_logic;
        BTN     : in std_logic_vector(2 downto 0);
        LED     : out std_logic_vector(3 downto 0)
    );
end fsm;

architecture Behavioral of fsm is

    -- Aliases
    alias A     : std_logic is BTN(0);
    alias B     : std_logic is BTN(1);
    alias LED0  : std_logic is LED(0);
    alias LED1  : std_logic is LED(1);

    -- Signals
    type STATE is (S0, S1, S2);
    signal state_reg, state_next : STATE;

begin

    -- State register
    process
    begin
        wait until rising_edge(CLK);
        if (RST = '1') then
            state_reg <= S0;
        else
            state_reg <= state_next;
        end if;
    end process;
    
    -- Next state logic
    process (CLK, A, B)
    begin
        case state_reg is
            when S0 =>
                state_next <= S0;   -- Default assignment
                if (A = '0') then
                    state_next <= S0;   -- Redundant
                end if;
                if (A = '1' and B = '0') then
                    state_next <= S1;
                end if;
                if (A = '1' and B = '1') then
                    state_next <= S2;
                end if;
                
            when S1 =>
                state_next <= S0;   -- Default assignment
                if (A = '0') then
                    state_next <= S1;   -- Redundant
                end if;
                if (A = '1') then
                    state_next <= S0;
                end if;
                
            when S2 =>
                state_next <= S0;   -- Default assignment    
            
            when others =>
                state_next <= S0;   -- Default assignment   
        end case;
    end process;
    
    -- Moore output logic
    LED1 <= '1' when (state_reg = S0 or state_reg = S1) else '0';
    
    -- Mealy output logic
    LED0 <= '1' when (state_reg = S0 and A = '1' and B = '1') else '0';

    -- States visualization
    with state_reg select
        LED(3 downto 2) <= "01" when S0,
                           "10" when S1,
                           "11" when S2;

end Behavioral;
