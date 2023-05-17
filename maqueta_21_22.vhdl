library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;

entity maqueta_21_22 is
port(
clk: in std_logic;
inicio: in std_logic;
segmentos: out std_logic_vector (6 downto 0);
enable_seg: out std_logic_vector (3 downto 0);
FC1: in std_logic;
FC2: in std_logic;
calefactor: out std_logic;
led: out std_logic_vector (1 downto 0);
sentido: in std_logic;
pwm_motor_DC: out std_logic_vector(1 downto 0);
sensor_hall_verde: in std_logic;
sensor_hall_azul: in std_logic;
rpm_salida: out std_logic_vector (7 downto 0);
sentido_salida: out std_logic;
dir_sal: out std_logic;
step: out std_logic;
enable_sal: out std_logic;
echo: in std_logic; 
trigger: out std_logic;
crc_en	: OUT		STD_LOGIC;
ds_data_bus	: INOUT	STD_LOGIC;
speed: in std_logic_vector (3 downto 0);
que_ver: in std_logic_vector (1 downto 0)
);

end entity;

architecture Behavioral of maqueta_21_22 is
signal sw: std_logic_vector (4 downto 0);
begin
sw <= sentido & speed;
aa : entity work.pwm_motor_DC
port map (
clk => clk,
btn => inicio,
sw => sw,
pwm_motor_DC => pwm_motor_DC(0),
sentido_motor_DC => pwm_motor_DC(1)
);
end Behavioral;
