----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.11.2023 22:21:32
-- Design Name: 
-- Module Name: CONTROL_PERSONAJE - Behavioral
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
use WORK.RACETRACK_PKG.ALL; -- incluye la pista

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONTROL_PERSONAJE is
    generic( Nbits : in natural 
             );
    Port ( 
           --In ports
           clk          : in STD_LOGIC;
           reset        : in STD_LOGIC;
           en           : in STD_LOGIC;
           btn          : in STD_LOGIC_VECTOR (3 downto 0);
           col          : in unsigned (10-1 downto 0);
           fila         : in unsigned (10-1 downto 0);
           --Out ports
           col_per      : out unsigned (4 downto 0);
           fila_per     : out unsigned (4 downto 0)
           );
end CONTROL_PERSONAJE;

architecture Behavioral of CONTROL_PERSONAJE is

    component contador_25Mhz  
          generic(
                  temp: in natural;
                  Nbits: in natural 
                  );                                
          Port( 
                  reset      : in STD_LOGIC;                                                                      
                  en   : in STD_LOGIC;                                                                   
                  clk      : in STD_LOGIC;             
                  clk_25Mhz  : out STD_LOGIC;           
                  periodo   : out unsigned (Nbits downto 0) 
                  ); 
    end component;
    
signal filas_personaje: unsigned (4 downto 0);
signal columnas_personaje: unsigned (4 downto 0);

signal salida_100ms: std_logic;
signal salida_500ms: std_logic;
signal jug_en_cir: std_logic;

begin

cuenta_100ms : contador_25Mhz 
           generic map ( temp     => 2500000-1,
                         Nbits    =>  24
                        )     
           port map ( clk        => clk,
                      reset      => reset,
                      clk_25Mhz  => salida_100ms,
                      en   => '1');

cuenta_500ms : contador_25Mhz 
           generic map ( temp     => 12500000-1,
                         Nbits    =>  24
                        )     
           port map ( clk        => clk,
                      reset      => reset,
                      clk_25Mhz  => salida_500ms,
                      en   => '1');

jug_en_cir <= pista(to_integer(filas_personaje))(to_integer(columnas_personaje));

process_MOVER: process(reset,jug_en_cir)
    begin
    if reset = '1' then
        filas_personaje <= "00100";
        columnas_personaje <= "00100";
    elsif jug_en_cir='1' then
        if rising_edge(salida_500ms) then
            if btn(0)= '1' then
                filas_personaje <= filas_personaje-1;
            elsif btn(1)= '1' then
                filas_personaje <= filas_personaje+1;
            elsif btn(2)= '1' then
                columnas_personaje <= columnas_personaje-1;
            elsif btn(3)= '1' then
                columnas_personaje <= columnas_personaje+1;
            else
                columnas_personaje <= columnas_personaje;
                filas_personaje <= filas_personaje;
            end if;
        end if;
    elsif jug_en_cir='0' then
        if rising_edge(salida_100ms) then
            if btn(0)= '1' then
                filas_personaje <= filas_personaje-1;
            elsif btn(1)= '1' then
                filas_personaje <= filas_personaje+1;
            elsif btn(2)= '1' then
                columnas_personaje <= columnas_personaje-1;
            elsif btn(3)= '1' then
                columnas_personaje <= columnas_personaje+1;
            else
                columnas_personaje <= columnas_personaje;
                filas_personaje <= filas_personaje;
            end if;
        end if; 
    end if;
end process;

col_per <= columnas_personaje;
fila_per <= filas_personaje;

end Behavioral;
