
----------------------------------------------------------------------------------
--
-- Engineer:        Andres Casasola Dominguez
-- Github:          AndresCasasola

-- Create Date:     05/2020
-- Module Name:     mult_16x16 - Behavioral
-- Dependencies:    None
-- Description:     16x16 multiplier with no habilitation and no initialization.
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity mult_16x16 is
    generic(
        WIDTH_A : integer := 16;
        WIDTH_B : integer := 16
    );
    port (
        A       : in  std_logic_vector(WIDTH_A - 1 downto 0);
        B       : in  std_logic_vector(WIDTH_B - 1 downto 0);
        DOUT    : out std_logic_vector(WIDTH_A + WIDTH_B - 1 downto 0)
    );
end mult_16x16;



architecture Behavioral of mult_16x16 is

    signal dout_reg : std_logic_vector(WIDTH_A + WIDTH_B - 1 downto 0);

    attribute use_dsp : string;
    attribute use_dsp of dout_reg: signal is "yes";

begin

    dout_reg <= A * B;
    DOUT <= dout_reg;
    
end Behavioral;
