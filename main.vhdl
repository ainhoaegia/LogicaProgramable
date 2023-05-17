----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.05.2023 16:46:26
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
Port ( 
clk: in std_logic; -- al ser con ARM es de 100 MHz, no de 125 MHz
reset: in std_logic;
echo: in std_logic;
trigger: out std_logic;

tipo: in std_logic_vector (1 downto 0);
inicio: in std_logic;
sw: in std_logic_vector (11 downto 0);
enable: in std_logic;
led: out std_logic_vector (11 downto 0);
enable_seg: out std_logic_vector (3 downto 0);
segmentos: out std_logic_vector (6 downto 0)
);

end main;

architecture Behavioral of main is
signal distancia_cm: integer range 0 to 500;
signal salida_cm: std_logic_vector (11 downto 0);
begin

process(tipo)
begin
if tipo = "00" then
    salida_cm <= std_logic_vector(to_unsigned(distancia_cm, sw'length));
elsif tipo = "01"  then
    salida_cm <= "010100" & std_logic_vector(to_unsigned(distancia_cm, 6));
else
    salida_cm <= "000000000000";
end if;

end process;

instance_bin : entity work.bin_BCD
port map (
    clk => clk,
    tipo => tipo,
    inicio => inicio,
    sw => salida_cm,
    enable => enable,
    enable_seg => enable_seg,
    segmentos => segmentos
);

instance_HCSR4 : entity work.HC_SR04
port map (
    clk => clk, -- al ser con ARM es de 100 MHz, no de 125 MHz
    reset => reset,
    echo => echo,
    trigger => trigger,
    distancia_cm => distancia_cm
);

end Behavioral;
