----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 01:54:26
-- Design Name: 
-- Module Name: MUX_PACMAN_COLOR - Behavioral
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

entity MUX_PACMAN_COLOR is
--  Port ( );
end MUX_PACMAN_COLOR;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.12.2023 23:22:56
-- Design Name: 
-- Module Name: MUX_PISTA_PACMAN_FANTASMA - Behavioral
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

entity MUX_PERSONAJES_COLORES is
    Port ( ROJO : in STD_LOGIC_vector (3-1 downto 0);
           VERDE : in STD_LOGIC_vector (3-1 downto 0);
           AZUL : in STD_LOGIC_vector (3-1 downto 0);
           BLANCO : in STD_LOGIC_vector (3-1 downto 0);
           AMARILLO : in STD_LOGIC_vector (3-1 downto 0);
           MAGENTA : in STD_LOGIC_vector (3-1 downto 0);
           CYAN : in STD_LOGIC_vector (3-1 downto 0);
           fondo : in STD_LOGIC_vector (3-1 downto 0);
           SEL : in STD_LOGIC_VECTOR (3-1 downto 0);
           PINTAR_PERSONAJE_COLOR : out STD_LOGIC_vector(3-1 downto 0));
end MUX_PERSONAJES_COLORES;

architecture Behavioral of MUX_PERSONAJES_COLORES is

begin

    PINTAR_PERSONAJE_COLOR <= ROJO when SEL = "100" else 
                             VERDE when SEL ="010" else
                             AZUL when SEL ="001" else 
                             AMARILLO when SEL ="110" else 
                             MAGENTA when SEL ="101" else 
                             CYAN when SEL ="011" else fondo;



end Behavioral;