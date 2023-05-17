library IEEE;

use IEEE.STD_LOGIC_1164.ALL;


entity main is

port(

reset: in std_logic; -- button es el reset activo por nivel alto

clk: in std_logic; -- clk es el reloj de 125 MHz que da el propio Zynq/Zybo

enable: in std_logic; -- para habilitar el motor

paso_paso: out std_logic_vector (3 downto 0); --control del motor paso a paso con la secuencia

sentido: in std_logic --Control de sentido de stepper

);

end main;


architecture Behavioral of main is


signal frecuencia_paso_paso: integer range 0 to 250000; --para generar la frecuencia de 50 Hz

signal paso_paso_aux: std_logic_vector (3 downto 0); --para generar la salida


begin


process(clk, reset)

begin

if rising_edge(clk) then

    if reset='1' then

        frecuencia_paso_paso<=0;

    else

        if frecuencia_paso_paso=250000 then --0 then

            frecuencia_paso_paso<=0;

        else

            frecuencia_paso_paso<=frecuencia_paso_paso+1;

        end if;

    end if;

end if;

end process;


process(clk, reset)

begin

if rising_edge(clk) then

    if reset='1' then

        paso_paso_aux<="1100";

    else

        if enable='1' then

            if frecuencia_paso_paso=0 then
          
                if sentido = '1' then
               
                    paso_paso_aux<=paso_paso_aux(0)&paso_paso_aux(3 downto 1);
               else
               
                    paso_paso_aux<=paso_paso_aux(2 downto 0)&paso_paso_aux(3);
                    
               end if;

            end if;

        end if;

    end if;

end if;

end process;


paso_paso<=paso_paso_aux;


end Behavioral;
