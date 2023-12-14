----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2023 18:44:27
-- Design Name: 
-- Module Name: FANTASMA_MAQUINA_ESTADOS - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity FANTASMA_MAQUINA_ESTADOS is
    Port (
    rst             : in std_logic; 
    clk             : in std_logic; 

    fila_Fantasma   : out unsigned (4 downto 0);  
    col_Fantasma    : out unsigned (4 downto 0)); 
    
end FANTASMA_MAQUINA_ESTADOS;

architecture Behavioral of FANTASMA_MAQUINA_ESTADOS is
 type estados is (abajo_izquierda_h, arriba_izquierda_h, arriba_derecha_h, abajo_derecha_h,abajo_izquierda_anti, arriba_izquierda_anti, arriba_derecha_anti, abajo_derecha_anti);
 
 component contador_25Mhz  generic( temp : in natural;                                                                 
                                 Nbits : in natural); 
                        Port ( 
                               reset : in STD_LOGIC;         
                               en : in STD_LOGIC;      
                               clk : in STD_LOGIC;         
                               clk_25Mhz : out std_logic);   
 end component; 
 
 signal eact, esig                    : estados;
 signal ms100                         : std_logic;              
 signal c_Fantasma                    : unsigned (4 downto 0);                                                      
 signal f_Fantasma                    : unsigned (4 downto 0); 
 constant c_max                       : natural := 31;                                                     
 constant f_max                       : natural := 29;                                                     

begin

    cuenta_100ms : contador_25Mhz 
        generic map ( temp     => 2500000-1,
                      Nbits    =>  25
                     )     
           port map ( clk      => clk,
                      reset      => rst,
                      clk_25Mhz  => ms100,
                      en   => '1');

    P_SEC_FMS : process(clk,rst)
    begin
        if rst = '1' then
            eact <= abajo_derecha_h;
        elsif rising_edge(clk) then
            eact <= esig;
        end if;    
    end process;


    P_COMB_FMS : process (ms100,rst)
    begin
        if rst = '1' then 
            f_Fantasma <= "00000";
            c_Fantasma <= "00000";
        elsif rising_edge(ms100) then
            case eact is

                when abajo_izquierda_h =>
                    if f_Fantasma = f_max then
                        esig <= arriba_izquierda_h; 
                    elsif c_Fantasma = 0 then
                        esig <= abajo_derecha_anti;                  
                    else 
                        f_Fantasma <= f_Fantasma + 1;
                        c_Fantasma <= c_Fantasma - 1;
                    end if;

                when arriba_izquierda_h =>
                    if c_Fantasma = 0 then
                        esig <= arriba_derecha_h;  
                    elsif f_Fantasma = 0 then
                        esig <= abajo_izquierda_anti;                  
                    else f_Fantasma <= f_Fantasma - 1;
                         c_Fantasma <= c_Fantasma - 1;
                    end if;  

                when arriba_derecha_h =>
                    if f_Fantasma = 0 then
                        esig <= abajo_derecha_h;
                    elsif c_Fantasma = c_max then
                        esig <= arriba_izquierda_anti;
                    else f_Fantasma <= f_Fantasma - 1;
                         c_Fantasma <= c_Fantasma + 1;
                    end if;

                when abajo_derecha_h =>
                    if c_Fantasma = c_max then
                        esig <= abajo_izquierda_h;
                    elsif f_Fantasma = f_max then
                        esig <= arriba_derecha_anti;
                    else f_Fantasma <= f_Fantasma + 1;
                         c_Fantasma <= c_Fantasma + 1;
                    end if;
                    
                when abajo_izquierda_anti =>
                    if f_Fantasma = f_max then
                        esig <= arriba_izquierda_h; 
                    elsif c_Fantasma = 0 then
                        esig <= abajo_derecha_anti;                  
                    else 
                        f_Fantasma <= f_Fantasma + 1;
                        c_Fantasma <= c_Fantasma - 1;
                    end if;

                when arriba_izquierda_anti =>
                    if c_Fantasma = 0 then
                        esig <= arriba_derecha_h;  
                    elsif f_Fantasma = 0 then
                        esig <= abajo_izquierda_anti;                  
                    else f_Fantasma <= f_Fantasma - 1;
                         c_Fantasma <= c_Fantasma - 1;
                    end if;  

                when arriba_derecha_anti =>
                    if f_Fantasma = 0 then
                        esig <= abajo_derecha_h;
                    elsif c_Fantasma = c_max then
                        esig <= arriba_izquierda_anti;
                    else f_Fantasma <= f_Fantasma - 1;
                         c_Fantasma <= c_Fantasma + 1;
                    end if;

                when abajo_derecha_anti =>
                    if f_Fantasma = f_max then
                        esig <= arriba_derecha_anti;
                    elsif c_Fantasma = c_max then
                        esig <= abajo_izquierda_h;
                    else f_Fantasma <= f_Fantasma + 1;
                         c_Fantasma <= c_Fantasma + 1;
                    end if;                    
            end case;
        else 
             f_Fantasma <= f_Fantasma;
             c_Fantasma <= c_Fantasma;
        end if;
    end process;
col_Fantasma <= c_Fantasma; 
fila_Fantasma <= f_Fantasma;

end Behavioral;