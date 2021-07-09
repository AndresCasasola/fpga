library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--    PWM: entity work.pwm
--    generic map(
--        SIZE            => SIZE
--    );  
--    port map(
--        CLK             => CLK,
--        SRST            => SRST,
--        DUTY_CYCLE      => DUTY_CYCLE,
--        PERIOD          => PERIOD,
--        DOUT            => DOUT
--    );

entity pwm is
    generic(
        SIZE            : integer := 14
    );  
    port(
        CLK             : in std_logic;
        SRST            : in std_logic;
        DUTY_CYCLE      : in std_logic_vector(SIZE - 1 downto 0);
        PERIOD          : in std_logic_vector(SIZE - 1 downto 0);
        DOUT            : out std_logic
    );
end pwm;

architecture Behavioral of pwm is
    
    signal count_reg    : unsigned(SIZE - 1 downto 0) := (others => '0');
    signal dout_reg     : std_logic := '0';
    
begin

    -- Registration process
    process
    begin
    wait until rising_edge(CLK);
        if (SRST = '1') then
            count_reg <= (others => '0');
            dout_reg <= '0';
        else
            if (count_reg = unsigned(PERIOD)) then
                count_reg <= (others => '0');
                dout_reg <= '0';    
            else
                count_reg <= count_reg + 1;
                if (count_reg < unsigned(DUTY_CYCLE)) then
                    dout_reg <= '1';
                else
                    dout_reg <= '0';
                end if;
            end if;
        end if;
    end process;
    
    -- Output
    DOUT <= dout_reg;
    

end Behavioral;
