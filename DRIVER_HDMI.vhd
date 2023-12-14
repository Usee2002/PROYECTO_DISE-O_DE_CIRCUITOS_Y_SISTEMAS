----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2023 16:43:34
-- Design Name: 
-- Module Name: DRIVER_HDMI - Behavioral
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

entity Driver_HDMI is
    Port ( ------ Entradas -------
           clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           BTN      : in STD_LOGIC_VECTOR(3 downto 0);
           ------ Salidas ---------
           clk_p    : out STD_LOGIC;
           clk_n    : out STD_LOGIC;
           data_p   : out STD_LOGIC_VECTOR(2 downto 0);
           data_n   : out STD_LOGIC_VECTOR(2 downto 0) );
end Driver_HDMI;

architecture Behavioral of Driver_HDMI is    
    component hdmi_rgb2tmds generic (                                                 
                                SERIES6 : boolean := false                            
                            );                                                        
                            port(
                                -- reset and clocks
                                rst             : in std_logic;
                                pixelclock      : in std_logic; 
                                serialclock     : in std_logic;
                                -- video signals
                                video_data      : in std_logic_vector(23 downto 0);
                                video_active    : in std_logic;
                                hsync           : in std_logic;
                                vsync           : in std_logic;
                                 -- tmds output ports
                                clk_p           : out std_logic;
                                clk_n           : out std_logic;
                                data_p          : out std_logic_vector(2 downto 0);
                                data_n          : out std_logic_vector(2 downto 0) );                                                        
    end component;
    
    component clock_gen generic (                                                
                        CLKIN_PERIOD    : real := 8.000;   -- input clock period (8ns)
                        CLK_MULTIPLY    : integer := 8;    -- multiplier               
                        CLK_DIVIDE      : integer := 1;    -- divider                    
                        CLKOUT0_DIV     : integer := 8;    -- serial clock divider      
                        CLKOUT1_DIV     : integer := 40 ); -- pixel clock divider                                                        
                        port(                                                    
                        clk_i   : in std_logic;            -- input clock                     
                        rst     : in std_logic;                      
                        clk0_o  : out std_logic;           -- serial clock                  
                        clk1_o  : out std_logic );         -- pixel clock                                       
     end component; 
                                                                            
    component PINTA_FONDO Port (   
                             -- In ports   
                             rst          : in std_logic;
                             clk          : in std_logic;                          
                             visible      : in std_logic;                         
                             col          : in unsigned(10-1 downto 0);           
                             fila         : in unsigned(10-1 downto 0);
                             col_per      : in unsigned (4 downto 0); 
                             fila_per     : in unsigned (4 downto 0);
                            col_fantasma : in unsigned (4 downto 0);
                            fila_fantasma: in unsigned (4 downto 0);      
                             -- Out ports                                      
                             rojo         : out std_logic_vector(8-1 downto 0);   
                             verde        : out std_logic_vector(8-1 downto 0);   
                             azul         : out std_logic_vector(8-1 downto 0)    
                           );                                                     
    
    end component;
    
    component SYNC_VGA Port ( 
                             -- In ports 
                             clk       : in STD_LOGIC;               
                             rst        : in STD_LOGIC;  
                             -- Out ports               
                             cols       : out UNSIGNED (9 downto 0);  
                             filas      : out UNSIGNED (9 downto 0); 
                             Visible    : out STD_LOGIC;           
                             HSYNC      : out STD_LOGIC;             
                             VSYNC      : out STD_LOGIC);   
    end component;
    
    component CONTROL_PERSONAJE 
                        generic( Nbits : in natural :=22
                         );
                        Port ( 
                               --In ports
                               clk          : in STD_LOGIC;
                               reset        : in STD_LOGIC;
                               en           : in STD_LOGIC;
                               btn          : in STD_LOGIC_VECTOR (3 downto 0);
                               --Out ports
                               col_per      : out unsigned (4 downto 0);
                               fila_per     : out unsigned (4 downto 0)
                               );  
    end component;
    
    component FANTASMA_MAQUINA_ESTADOS 
                        Port (                                       
                        rst             : in std_logic;              
                        clk             : in std_logic;              
                                                                     
                        fila_Fantasma   : out unsigned (4 downto 0); 
                        col_Fantasma    : out unsigned (4 downto 0));
    end component;
    
    -- Pinta
    signal VRGB : std_logic_vector (23 downto 0);   --bien
     
    -- clock_gen                       
    signal clk1 : std_logic;        --bien                  
    signal clk2 : std_logic;        --bien          
     
    -- SYNC_VGA                         
    signal  cols    : unsigned (9 downto 0);        --bien
    signal  fils   : unsigned (9 downto 0);         --bien
    signal Visible_s  :  STD_LOGIC;                 --bien
    signal HSYNC_s    : STD_LOGIC;                  --bien
    signal VSYNC_s    : STD_LOGIC;                  --bien
    
    -- CONTROL_PERSONAJE
    signal COLUMNA_PERSONAJE : unsigned (4 downto 0);
    signal FILA_PERSONAJE : unsigned (4 downto 0);
    
    --CONTROL_FANTASMA
    signal COLUMNA_FANTASMA : unsigned (4 downto 0);
    signal FILA_FANTASMA : unsigned (4 downto 0);    
                                  
begin

SYNC : SYNC_VGA port map(   clk => clk2, 
                            rst => rst,   
                            cols => cols, 
                            filas => fils,
                            Visible => Visible_s,
                            HSYNC =>HSYNC_s,     
                            VSYNC =>VSYNC_s            
                            );            
                            
PLL : clock_gen port map(                                   
                         clk_i => clk, 
                         rst => rst,    
                         clk0_o => clk1, 
                         clk1_o => clk2  
                         );  

PINTA : PINTA_FONDO port map(  
                               rst => rst,
                               clk => clk2,
                               col_fantasma => COLUMNA_FANTASMA,
                               fila_fantasma => FILA_FANTASMA,                                
                               visible => Visible_s,                  
                               col => cols,        
                               fila  => fils,
                               col_per => COLUMNA_PERSONAJE,                                    
                               fila_per => FILA_PERSONAJE,                                    
                               rojo => VRGB(23 downto 16),       
                               verde => VRGB(15 downto 8),       
                               azul => VRGB(7 downto 0)
                               );
                              
TDMS : hdmi_rgb2tmds port map(                                                                                                       
                                rst => rst,                                               
                                pixelclock => clk2,                
                                serialclock => clk1,                                                  
                                video_data => VRGB,                   
                                video_active => Visible_s,                                     
                                hsync => HSYNC_s,                                             
                                vsync => VSYNC_s,                                             
                                clk_p  => clk_p,                       
                                clk_n  => clk_n,                       
                                data_p => data_p,                       
                                data_n => data_n );     
                                
CTRL_PERSONAJE : CONTROL_PERSONAJE port map(                                                                                                       
                                                reset => rst,                                               
                                                clk => clk2,                
                                                en => '1',                                               
                                                btn => BTN,                   
                                                col_per => COLUMNA_PERSONAJE,                                     
                                                fila_per => FILA_PERSONAJE); 

CTRL_FANTASMA : FANTASMA_MAQUINA_ESTADOS port map(     
                                                    rst => rst,                                                                                                  
                                                    clk => clk2,                                                                              

                                                    fila_Fantasma => COLUMNA_FANTASMA, 
                                                    col_Fantasma => FILA_FANTASMA);

end Behavioral;                                                    
