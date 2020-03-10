
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     02/2020
-- Module Name:     tm1637_driver - Behavioral
-- Dependencies:    frcounter.vhd.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.NUMERIC_STD.ALL;

entity tm1637_driver is
    generic(
        DEPTH_BIT       : natural := 8
    );
    port ( 
        CLK             : in std_logic;
        RST             : in std_logic;
        DISPLAY_1       : in std_logic_vector(7 downto 0);
        DISPLAY_2       : in std_logic_vector(7 downto 0);
        DISPLAY_3       : in std_logic_vector(7 downto 0);
        DISPLAY_4       : in std_logic_vector(7 downto 0);
        DISPLAY_5       : in std_logic_vector(7 downto 0);
        DISPLAY_6       : in std_logic_vector(7 downto 0);
        PULSE_WIDTH     : in std_logic_vector(3 downto 0);
        STATE           : in std_logic;
        TX              : in std_logic;
        SDA             : inout std_logic;
        SCL             : inout std_logic;
        READY           : out std_logic
    );
end tm1637_driver;

architecture Behavioral of tm1637_driver is

    -- FSMD signals
    type state_t is (idle, start, data, ack, stop);
    signal state_reg, state_next    : state_t;
    signal s_reg, s_next            : unsigned(3 downto 0);
    signal n_reg, n_next            : unsigned(3 downto 0);
    signal s_tick                   : std_logic;
    signal sda_reg, sda_next        : std_logic;
    signal scl_reg, scl_next        : std_logic;

    type mem_t is array(8 downto 0) of std_logic_vector(7 downto 0);
    
    --signal packets                  : mem_t := ("10001111","01111111","01111111","01111111","01111111","01111111","01111111","11001111","01000000");
    signal packets                  : mem_t := ("Z000ZZZZ","000ZZZZZ","000ZZZZZ","000ZZZZZ","000ZZZZZ","000ZZZZZ","000ZZZZZ","ZZ00ZZZZ","0Z000000");
    signal count_reg, count_next    : unsigned(3 downto 0);

    component frcounter is
        generic(
            MAX_COUNT   : natural
        );
        port (
            CLK         : in std_logic;
            DATA_OUT    : out std_logic_vector(natural(ceil(log2(real(MAX_COUNT)))) - 1 downto 0);
            TC          : out std_logic
        );
    end component;
    
begin
    
    -- # S_TICK GENERATOR
    BAUDRATE_GENERATOR : frcounter
    generic map(
        MAX_COUNT   => 250      -- # 250 for 400 KHz with 100MHz input clock 
    )
    port map(
        CLK         => CLK,
        DATA_OUT    => open,
        TC          => s_tick
    );
    
    -- FSDM state & data registers
    process(CLK, RST)
    begin
        if(RST = '1') then
            state_reg <= idle;
            s_reg <= (others => '0'); 
            n_reg <= (others => '0');
            sda_reg <= '0';
            scl_reg <= '0';
            count_reg <= (others=>'0');
        elsif(CLK'event and CLK = '1') then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            sda_reg <= sda_next;
            scl_reg <= scl_next;
            count_reg <= count_next;
        end if;
    end process;
    
    -- Next state logic & data path functional units/routing
    process(state_reg, s_reg, n_reg, s_tick, tx)
    begin
        -- Default assignment
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        sda_next <= sda_reg;
        scl_next <= scl_reg;
        count_next <= count_reg;
        
        ready <= '0';
        
        case state_reg is
            when idle =>
                sda_next <= 'Z';    -- # Should be 'Z'
                scl_next <= 'Z';    -- # Should be 'Z'
                if(s_tick = '1' and tx = '1') then
                        state_next <= start;
                        s_next <= (others => '0');
                        n_next <= (others => '0');
                        sda_next <= '0'; -- Moore next state output
                end if;
            when start =>
                sda_next <= '0';    -- Moore output
                if(s_tick = '1') then
                    s_next <= s_reg + 1;
                    case to_integer(s_reg) is
                        when 0 =>   -- 1/4 TBIT
                            scl_next <= '0';
                        when 1 =>   -- 2/4 TBIT
                            sda_next <= packets(to_integer(count_reg))(DEPTH_BIT - 1);
                            n_next <= n_reg + 1;
                            s_next <= (others => '0');
                            state_next <= data;
                        when others =>
                            state_next <= state_reg;
                    end case;
                end if;
            when data =>
                if(s_tick = '1') then
                    s_next <= s_reg + 1;
                    case to_integer(s_reg) is
                        when 0 =>   -- 1/4 TBIT
                            scl_next <= 'Z'; -- # Should be 'Z'
--                        when 1 =>   -- 2/4 TBIT
                        when 2 =>   -- 3/4 TBIT
                            scl_next <= '0';
                        when 3 =>   -- 4/4 TBIT
                            --sda_next <= packet(DEPTH_BIT - 1 - to_integer(n_reg));
                            s_next <= (others => '0');                            
                            if(n_reg = DEPTH_BIT) then
                                state_next <= ack;
                                n_next <= (others => '0');
                            else
                                sda_next <= packets(to_integer(count_reg))(DEPTH_BIT - 1 - to_integer(n_reg));
                                state_next <= data;
                                n_next <= n_reg + 1;
                            end if;
                        when others =>
                            state_next <= state_reg;
                    end case;
                end if;
            when ack =>
                sda_next <= 'Z'; -- # Should be 'Z' Moore output
                if(s_tick = '1') then
                    s_next <= s_reg + 1;
                    case to_integer(s_reg) is
                        when 0 =>   -- 1/4 TBIT
                            scl_next <= 'Z';    -- # Should be 'Z'
                        when 2 =>   -- 3/4 TBIT
                            scl_next <= '0'; 
                            s_next <= s_reg + 1;
                        when 3 =>   -- 4/4 TBIT
                            count_next <= count_reg + 1;
                            if(count_reg = 0 or count_reg = 7 or count_reg = 8) then
                                state_next <= stop;
                                sda_next <= '0';
                            else
                                --state_next <= idle;
                                state_next <= data;
                                sda_next <= packets(to_integer(count_reg+1))(DEPTH_BIT - 1);
                                n_next <= n_reg + 1;
                            end if;
                            s_next <= (others => '0');
                        when others =>
                            state_next <= state_reg;
                    end case;
                end if;
            when stop =>
                if(s_tick = '1') then
                    s_next <= s_reg + 1;
                    case to_integer(s_reg) is
                        when 0 =>   -- 1/4 TBIT
                            scl_next <= 'Z'; -- # Should be 'Z'
                        when 1 =>   -- 2/4 TBIT
                            sda_next <= 'Z'; -- # Should be 'Z'
                            if (count_reg = 9) then
                                count_next <= (others=>'0');
                            end if;
                            state_next <= idle;
                            s_next <= (others => '0');
                        when others =>
                            state_next <= state_reg;
                    end case;
                end if;
            when others =>
                state_next <= state_reg;
        end case;
    end process;
    
    SDA <= sda_reg;
    SCL <= scl_reg;
    
end Behavioral;








