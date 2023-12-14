----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2023 04:23:51
-- Design Name: 
-- Module Name: MUX_FONDO_O_PERSONAJES - Behavioral
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

entity MUX_FONDO_O_PERSONAJES is
    Port ( PACMAN : in STD_LOGIC_VECTOR (3-1 downto 0);
           FANTASMA : in STD_LOGIC_VECTOR (3-1 downto 0);
           PISTA : in STD_LOGIC_VECTOR (3-1 downto 0);
           SELECTOR : in STD_LOGIC_VECTOR (2-1 downto 0);
           SALIDA : out STD_LOGIC_VECTOR (3-1 downto 0));
end MUX_FONDO_O_PERSONAJES;

architecture Behavioral of MUX_FONDO_O_PERSONAJES is

begin

    SALIDA <= PACMAN when SELECTOR="10" else
              FANTASMA when SELECTOR="01" else PISTA;


end Behavioral;
