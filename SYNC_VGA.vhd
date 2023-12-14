----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2022 20:44:24
-- Design Name: 
-- Module Name: PLL - Behavioral
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

entity SYNC_VGA is
    Port ( 
           -- In ports  
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           -- Out ports 
           cols     : out UNSIGNED (9 downto 0);
           filas    : out UNSIGNED (9 downto 0);
           Visible  : out STD_LOGIC;
           HSYNC    : out STD_LOGIC;
           VSYNC    : out STD_LOGIC);
           
end SYNC_VGA;

architecture Behavioral of SYNC_VGA is
    
    component contador_25Mhz  
          generic(
                  temp: in natural;
                  Nbits: in natural :=25
                  );                                
          Port( 
                  reset      : in STD_LOGIC;                                                                      
                  en   : in STD_LOGIC;                                                                   
                  clk      : in STD_LOGIC;             
                  clk_25Mhz  : out STD_LOGIC;           
                  periodo   : out unsigned (Nbits downto 0) 
                  );                   
    end component;
    
    signal new_line     : std_logic; 
    signal new_frame    : std_logic;
    
    signal pxl_visible  : std_logic;
    signal line_visible : std_logic;
    
    signal  C : unsigned (9 downto 0); 
    signal  F : unsigned (9 downto 0);
    
begin

    conta_cols : contador_25Mhz generic map( temp => 799,
                                             Nbits => 9 )
                                port map  (  reset => rst,
                                             en => '1',
                                             clk => clk,
                                             clk_25Mhz => new_line,
                                             periodo => C );
                                       
    conta_filas : contador_25Mhz generic map ( temp => 524,
                                               Nbits => 9 ) 
                                 port map ( reset => rst,
                                            en => new_line,
                                            clk => clk,
                                            clk_25Mhz => new_frame,
                                            periodo => F );
     
     
    VSYNC   <= '0' when (F>489 and F<491) else '1';
    HSYNC   <= '0' when (C>655 and C<751) else '1';
    Visible <= '1' when (C<640 and F<480) else '0';                                                                         
    
    cols    <= C;
    filas   <= F;

end Behavioral;