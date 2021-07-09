----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2020 10:30:04 PM
-- Design Name: 
-- Module Name: glitch_filter - Behavioral
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

entity glitch_filter is
    port (
        CLK         : in std_logic;
        RST         : in std_logic;
        CE          : in std_logic;
        TICK        : in std_logic;
        DATA_IN     : in std_logic;
        DATA_OUT    : out std_logic
    );
end glitch_filter;

architecture Behavioral of glitch_filter is

    type STATE is (ZERO, ONE, WAIT1_0, WAIT1_1, WAIT1_2, WAIT1_3, WAIT0_0, WAIT0_1, WAIT0_2, WAIT0_3);
    signal current_state, next_state : STATE;

begin

    -- State register
    process(CLK, RST)
    begin
        -- current_state <= ZERO;      -- Default assignment (This line caused an error: always return to ZERO state)
        if (RST = '1') then
            current_state <= ZERO;
        elsif (CLK'event and CLK = '1') then
            if (CE = '1') then
                current_state <= next_state;
            end if;
        end if;
    end process;
    
    -- Next state logic
    process(current_state, DATA_IN, TICK)
    begin
        case current_state is
            when ZERO =>
                --next_state <= ZERO;  -- Default assignment
                if (DATA_IN = '1') then
                    next_state <= WAIT1_0;
                else
                    next_state <= ZERO;
                end if;
            
            when WAIT1_0 =>
                --next_state <= WAIT1_0;  -- Default assignment
                if (DATA_IN = '1' and TICK = '1') then
                    next_state <= WAIT1_1;
                end if;
                if (DATA_IN = '1' and TICK = '0') then
                    next_state <= WAIT1_0;
                end if;
                if (DATA_IN = '0') then
                    next_state <= ZERO;
                end if;
            
            when WAIT1_1 =>
                --next_state <= WAIT1_1;  -- Default assignment
                if (DATA_IN = '1' and TICK = '1') then
                    next_state <= WAIT1_2;
                end if;
                if (DATA_IN = '1' and TICK = '0') then
                    next_state <= WAIT1_1;
                end if;
                if (DATA_IN = '0') then
                    next_state <= ZERO;
                end if;
            
            when WAIT1_2 =>
                --next_state <= WAIT1_2;  -- Default assignment
                if (DATA_IN = '1' and TICK = '1') then
                    next_state <= WAIT1_3;
                end if;
                if (DATA_IN = '1' and TICK = '0') then
                    next_state <= WAIT1_2;
                end if;
                if (DATA_IN = '0') then
                    next_state <= ZERO;
                end if;
            
            when WAIT1_3 =>
                --next_state <= WAIT1_3;  -- Default assignment
                if (DATA_IN = '1' and TICK = '1') then
                    next_state <= ONE;
                end if;
                if (DATA_IN = '1' and TICK = '0') then
                    next_state <= WAIT1_3;
                end if;
                if (DATA_IN = '0') then
                    next_state <= ZERO;
                end if;
            
            when ONE =>
                --next_state <= ONE;  -- Default assignment
                if (DATA_IN = '0') then
                    next_state <= WAIT0_0;
                else
                    next_state <= ONE;
                end if;
            
            when WAIT0_0 =>
                --next_state <= WAIT0_0;  -- Default assignment
                if (DATA_IN = '0' and TICK = '1') then
                    next_state <= WAIT0_1;
                end if;
                if (DATA_IN = '0' and TICK = '0') then
                    next_state <= WAIT0_0;
                end if;
                if (DATA_IN = '1') then
                    next_state <= ONE;
                end if;
            
            when WAIT0_1 =>
                --next_state <= WAIT0_1;  -- Default assignment
                if (DATA_IN = '0' and TICK = '1') then
                    next_state <= WAIT0_2;
                end if;
                if (DATA_IN = '0' and TICK = '0') then
                    next_state <= WAIT0_1;
                end if;
                if (DATA_IN = '1') then
                    next_state <= ONE;
                end if;
            
            when WAIT0_2 =>
                --next_state <= WAIT0_2;  -- Default assignment
                if (DATA_IN = '0' and TICK = '1') then
                    next_state <= WAIT0_3;
                end if;
                if (DATA_IN = '0' and TICK = '0') then
                    next_state <= WAIT0_2;
                end if;
                if (DATA_IN = '1') then
                    next_state <= ONE;
                end if;
            
            when WAIT0_3 =>
                --next_state <= WAIT0_3;  -- Default assignment
                if (DATA_IN = '0' and TICK = '1') then
                    next_state <= ZERO;
                end if;
                if (DATA_IN = '0' and TICK = '0') then
                    next_state <= WAIT0_3;
                end if;
                if (DATA_IN = '1') then
                    next_state <= ONE;
                end if;
            
            when OTHERS =>
                next_state <= ZERO;
                
        end case;
    end process;
    
    -- Output logic
    with current_state select
    DATA_OUT <= '1' when ONE | WAIT0_0 | WAIT0_1 | WAIT0_2 | WAIT0_3,
                '0' when ZERO | WAIT1_0 | WAIT1_1 | WAIT1_2 | WAIT1_3;
    
end Behavioral;
