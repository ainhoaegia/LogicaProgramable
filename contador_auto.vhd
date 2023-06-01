library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity contador_auto is
port(
clk: in std_logic;
inicio: in std_logic;
pulsador_suma: in std_logic;
pulsador_resta: in std_logic;
maximo: in std_logic_vector(1 downto 0);
contador: out std_logic_vector(1 downto 0)
);
end contador_auto;

architecture Behavioral of contador_auto is 

signal estado_suma: std_logic_vector (2 downto 0);
signal puls_sal_suma: std_logic;
signal estado_resta: std_logic_vector (2 downto 0);
signal puls_sal_resta: std_logic;
signal cont_filtro_suma: integer range 0 to 200000;
signal cont_espera_suma: integer range 0 to 25000000;

signal cont_filtro_resta: integer range 0 to 200000;
signal cont_espera_resta: integer range 0 to 25000000;

signal contador_aux: std_logic_vector(1 downto 0);

begin

contador <= contador_aux;

process(inicio, clk)
begin
if inicio='1' then
   	estado_suma <="000";
	cont_filtro_suma<=0;
	cont_espera_suma<=0;
elsif rising_edge(clk) then
case estado_suma is
when "000" =>
	cont_filtro_suma<=0;
	cont_espera_suma<=0;
	if pulsador_suma='0' then
		estado_suma<="000";
	else
		estado_suma<="001";
	end if;
when "001" => 
   	cont_filtro_suma<=cont_filtro_suma+1;
	cont_espera_suma<=0;
	if pulsador_suma ='0' then
		estado_suma<="000";
	elsif pulsador_suma ='1' and cont_filtro_suma>=100000 then
		estado_suma<="010";
	else
		estado_suma<="001";
	end if;
when "010" =>
	cont_filtro_suma<=0;
	cont_espera_suma<=0;
	if pulsador_suma ='0' then
		estado_suma<="011";
	else
		estado_suma<="010";
	end if;
when "011"=>
	cont_filtro_suma<=0;
	cont_espera_suma<=cont_espera_suma+1;
	if pulsador_suma='1' then
	   estado_suma<="000";
	elsif cont_espera_suma>=5000000 then
	   estado_suma<="100";
	else 
	   estado_suma<="011";
	end if;         
when "100" =>
	cont_filtro_suma<=0;
	cont_espera_suma<=cont_espera_suma+1;
    if pulsador_suma='1' then
        estado_suma<="101";
    elsif cont_espera_suma>=20000000 then
        estado_suma<="000";
    else
        estado_suma<="100";
    end if;        
when "101" =>
	cont_filtro_suma<=cont_filtro_suma+1;
	cont_espera_suma<=0;
	if pulsador_suma='0' then	--rebote
		estado_suma<="100";
	elsif pulsador_suma='1' and cont_filtro_suma>=100000 then
		estado_suma<="110";
	else
		estado_suma<="101";
	end if;
when "110" =>
	cont_filtro_suma<=0;
	cont_espera_suma<=0;
	if pulsador_suma='0' then
		estado_suma<="111";
	else
		estado_suma<="110";
	end if;
when "111" =>
	cont_filtro_suma<=0;
	cont_espera_suma<=0;
	estado_suma<="000";
when others =>
	cont_filtro_suma<=0;
	cont_espera_suma<=0;
    estado_suma<="000";
end case;
end if;
end process; 


process(inicio, clk)
begin
if inicio='1' then
   	estado_resta<="000";
	cont_filtro_resta<=0;
	cont_espera_resta<=0;
elsif rising_edge(clk) then
case estado_resta is
when "000" =>
	cont_filtro_resta<=0;
	cont_espera_resta<=0;
	if pulsador_resta='0' then
		estado_resta<="000";
	else
		estado_resta<="001";
	end if;
when "001" => 
   	cont_filtro_resta<=cont_filtro_resta+1;
	cont_espera_resta<=0;
	if pulsador_resta ='0' then
		estado_resta<="000";
	elsif pulsador_resta ='1' and cont_filtro_resta>=100000 then
		estado_resta<="010";
	else
		estado_resta<="001";
	end if;
when "010" =>
	cont_filtro_resta<=0;
	cont_espera_resta<=0;
	if pulsador_resta ='0' then
		estado_resta<="011";
	else
		estado_resta<="010";
	end if;
when "011"=>
	cont_filtro_resta<=0;
	cont_espera_resta<=cont_espera_resta+1;
	if pulsador_resta='1' then
	   estado_resta<="000";
	elsif cont_espera_resta>=5000000 then
	   estado_resta<="100";
	else 
	   estado_resta<="011";
	end if;         
when "100" =>
	cont_filtro_resta<=0;
	cont_espera_resta<=cont_espera_resta+1;
    if pulsador_resta='1' then
        estado_resta<="101";
    elsif cont_espera_resta>=20000000 then
        estado_resta<="000";
    else
        estado_resta<="100";
    end if;        
when "101" =>
	cont_filtro_resta<=cont_filtro_resta+1;
	cont_espera_resta<=0;
	if pulsador_resta='0' then	--rebote
		estado_resta<="100";
	elsif pulsador_resta='1' and cont_filtro_resta>=100000 then
		estado_resta<="110";
	else
		estado_resta<="101";
	end if;
when "110" =>
	cont_filtro_resta<=0;
	cont_espera_resta<=0;
	if pulsador_resta='0' then
		estado_resta<="111";
	else
		estado_resta<="110";
	end if;
when "111" =>
	cont_filtro_resta<=0;
	cont_espera_resta<=0;
	estado_resta<="000";
when others =>
	cont_filtro_resta<=0;
	cont_espera_resta<=0;
    estado_resta<="000";
end case;
end if;
end process;

process(estado_suma)
begin
case estado_suma is
when "000" => puls_sal_suma<='0';
when "001" => puls_sal_suma<='0';
when "010" => puls_sal_suma<='0';
when "011" => puls_sal_suma<='0';
when "100" => puls_sal_suma<='0';
when "101" => puls_sal_suma<='0';
when "110" => puls_sal_suma<='0';
when "111" => puls_sal_suma<='1';
when others => puls_sal_suma<='0';
end case;
end process;

process(estado_resta)
begin
case estado_resta is
when "000" => puls_sal_resta<='0';
when "001" => puls_sal_resta<='0';
when "010" => puls_sal_resta<='0';
when "011" => puls_sal_resta<='0';
when "100" => puls_sal_resta<='0';
when "101" => puls_sal_resta<='0';
when "110" => puls_sal_resta<='0';
when "111" => puls_sal_resta<='1';
when others => puls_sal_resta<='0';
end case;
end process;

process(inicio, clk)
begin
if inicio='1' then
contador_aux<="00";
elsif rising_edge(clk) then
	if puls_sal_suma='1' then
		if contador_aux=maximo then
         		contador_aux<=maximo;
     		else
         		contador_aux<=contador_aux+1;
      	end if;
      	elsif puls_sal_resta= '1' then
      	 if contador_aux="00" then
         		contador_aux<="00";
     		else
         		contador_aux<=contador_aux-1;
      	end if;
	end if;
end if;
end process;

end Behavioral;
