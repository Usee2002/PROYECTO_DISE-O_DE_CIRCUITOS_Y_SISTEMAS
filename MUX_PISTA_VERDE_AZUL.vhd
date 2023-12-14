----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2023 12:12:21
-- Design Name: 
-- Module Name: MUX_PISTA_VERDE_AZUL - Behavioral
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

entity MUX_PISTA_VERDE_AZUL is
    Port ( BLANCO : in STD_LOGIC_VECTOR (3-1 downto 0);
           AZUL : in STD_LOGIC_VECTOR (3-1 downto 0);
           VERDE : in STD_LOGIC_VECTOR (3-1 downto 0);
           ROJO : in STD_LOGIC_VECTOR (3-1 downto 0);
           SEL : in STD_LOGIC_VECTOR (2-1 downto 0);
           PINTAR : out STD_LOGIC_VECTOR (3-1 downto 0));
end MUX_PISTA_VERDE_AZUL;

architecture Behavioral of MUX_PISTA_VERDE_AZUL is

begin
    PINTAR <= ROJO when SEL = "00" else 
              AZUL when SEL ="01" else
              VERDE when SEL ="10" else BLANCO;


end Behavioral;
