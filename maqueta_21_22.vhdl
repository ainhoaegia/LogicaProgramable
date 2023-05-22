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
que_ver: in std_logic_vector (1 downto 0);
servo_pwm: out std_logic
);

end entity;

architecture Behavioral of maqueta_21_22 is

signal sw: std_logic_vector (4 downto 0);
signal enable: std_logic;

signal distancia_cm: integer range 0 to 500;
signal salida: std_logic_vector (11 downto 0);

signal data_out_lsb: std_logic_vector (7 downto 0);
signal data_out_msb: std_logic_vector (3 downto 0);

signal consigna: std_logic_vector(5 downto 0);

signal dir: std_logic;

begin

led(1)<=FC2;
led(0)<=FC1;

calefactor<=FC1 or FC2;

sw <= sentido & speed;
work_pwm_motor_DC : entity work.pwm_motor_DC
port map (
clk => clk,
btn => inicio,
sw => sw,
pwm_motor_DC => pwm_motor_DC(0),
sentido_motor_DC => pwm_motor_DC(1)
);

consigna <= "011110";
process(que_ver, consigna, distancia_cm, sentido)
begin
if que_ver = "01" then
    if consigna < distancia_cm then
        dir <= '0';
    elsif consigna > distancia_cm then
        dir <= '1';
    end if;
else
    dir <= sentido;
end if;
end process;

enable <= '1' when speed > 0 else '0';
work_my_quimat : entity work.my_quimat
port map (
clk => clk,
reset => inicio,
enable => enable,
dir => dir,
enable_sal => enable_sal ,
dir_sal => dir_sal,
frecuencia_paso_paso => "00000" & speed,
step => step
);

work_my_servo_v1 : entity work.my_servo_v1
port map (
clk => clk,
inicio => inicio,
selector => speed,
servo_pwm => servo_pwm
);

process(que_ver)
begin
if que_ver = "00" then
    salida <= std_logic_vector(to_unsigned(distancia_cm, 12));
elsif que_ver = "01"  then
    salida <= consigna & std_logic_vector(to_unsigned(distancia_cm, 6));
elsif que_ver = "10" then
    salida <= "0000" & data_out_lsb;
else
    salida <= "000000000000";
    
end if;

end process;

instance_bin : entity work.bin_BCD
port map (
    clk => clk,
    tipo => que_ver,
    inicio => inicio,
    sw => salida,
    enable => '1',
    enable_seg => enable_seg,
    segmentos => segmentos
);

instance_HCSR4 : entity work.HC_SR04
port map (
    clk => clk, -- al ser con ARM es de 100 MHz, no de 125 MHz
    reset => inicio,
    echo => echo,
    trigger => trigger,
    distancia_cm => distancia_cm
);

work_sensTemp : entity work.sensTemp
port map (
  clk1m	=> clk,
  crc_en => crc_en,
  ds_data_bus => ds_data_bus,
  data_out_lsb => data_out_lsb,
  data_out_msb => data_out_msb
);

end Behavioral;
