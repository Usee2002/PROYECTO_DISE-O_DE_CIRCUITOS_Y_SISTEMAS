----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.10.2023 15:43:29
-- Design Name: 
-- Module Name: contador_1m - Behavioral
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

entity contador_25Mhz is
    generic( Nbits : in natural :=25;
             temp : in natural
             );
    Port ( 
           --In ports
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           en : in STD_LOGIC;
           --Out ports
           clk_25Mhz : out STD_LOGIC;
           periodo : out unsigned (Nbits downto 0)
           );
end contador_25Mhz;

architecture Behavioral of contador_25Mhz is

signal cuenta_40ns: unsigned (Nbits downto 0);
signal salida_40ns: std_logic;

begin

process_contar_40ns: process(reset,clk)
    begin
        if reset = '1' then
            cuenta_40ns <= (others => '0');
        elsif clk'event and clk = '1' then
            if en = '1' then
                if salida_40ns = '1' then
                    cuenta_40ns <= (others => '0');
                else
                    cuenta_40ns <= cuenta_40ns + 1;
                end if;
            end if;
        end if;
end process;

salida_40ns <= '1' when cuenta_40ns = temp else '0';
clk_25Mhz <= salida_40ns;
periodo <= cuenta_40ns;

end Behavioral;
