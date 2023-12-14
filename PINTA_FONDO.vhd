--------------------------------------------------------------------------------
-- Felipe Machado Sanchez
-- Departameto de Tecnologia Electronica
-- Universidad Rey Juan Carlos
-- http://gtebim.es/~fmachado
--
-- Pinta barras para la XUPV2P

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PINTA_FONDO is
  Port (
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
end PINTA_FONDO;

architecture behavioral of PINTA_FONDO is

--PERSONAJES DE UN SOLO COLOR
--component ROM1b_1f_imagenes16_16x16_bn   
--  port ( clk  : in  std_logic;          
--         addr : in  unsigned(8-1 downto 0);      
--         dout : out unsigned(16-1 downto 0)); 
--  end component;


--PERSONAJES DE COLORES MULTIPLES   
component ROM1b_1f_red_imagenes16_16x16   
  port ( clk  : in  std_logic;          
         addr : in  unsigned(8-1 downto 0);      
         dout : out unsigned(16-1 downto 0)); 
  end component;
  
component ROM1b_1f_green_imagenes16_16x16   
  port ( clk  : in  std_logic;          
         addr : in  unsigned(8-1 downto 0);      
         dout : out unsigned(16-1 downto 0)); 
  end component;
  
component ROM1b_1f_blue_imagenes16_16x16   
  port ( clk  : in  std_logic;          
         addr : in  unsigned(8-1 downto 0);      
         dout : out unsigned(16-1 downto 0)); 
  end component;  
  
    
--PISTA EN BLANCO Y NEGRO
--component ROM1b_1f_racetrack_1   
--  port ( clk  : in  std_logic;          
--         addr : in  unsigned(5-1 downto 0);      
--         dout : out unsigned(32-1 downto 0)); 
--  end component;  
  
  
--PISTA DE VARIOS COLORES  
component ROM1b_1f_green_racetrack_1   
  port ( clk  : in  std_logic;          
         addr : in  unsigned(5-1 downto 0);      
         dout : out unsigned(32-1 downto 0)); 
  end component;
  
component ROM1b_1f_blue_racetrack_1   
  port ( clk  : in  std_logic;          
         addr : in  unsigned(5-1 downto 0);      
         dout : out unsigned(32-1 downto 0)); 
  end component;
  
  
--MULTIPLEXORES PARA COLORES DE PERSONAJES Y PISTA  
component MUX_PISTA_VERDE_AZUL is
    Port ( BLANCO : in STD_LOGIC_VECTOR (3-1 downto 0);
           AZUL : in STD_LOGIC_VECTOR (3-1 downto 0);
           VERDE : in STD_LOGIC_VECTOR (3-1 downto 0);
           ROJO : in STD_LOGIC_VECTOR (3-1 downto 0);
           SEL : in STD_LOGIC_VECTOR (2-1 downto 0);
           PINTAR : out STD_LOGIC_VECTOR (3-1 downto 0));
end component;

component MUX_PERSONAJES_COLORES is
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
end component;


component MUX_FONDO_O_PERSONAJES is
    Port ( PACMAN : in STD_LOGIC_vector (3-1 downto 0);
           FANTASMA : in STD_LOGIC_vector (3-1 downto 0);
           PISTA : in STD_LOGIC_vector (3-1 downto 0);
           SELECTOR : in STD_LOGIC_vector (2-1 downto 0);
           SALIDA : out STD_LOGIC_vector(3-1 downto 0));
end component;

signal col_int : unsigned (3 downto 0);
signal fila_int : unsigned (3 downto 0); 
signal col_ext : unsigned (5 downto 0);
signal fila_ext : unsigned (5 downto 0); 

 
signal  dir_fantasma    : unsigned (8-1 downto 0)  := ("0100" & fila_int);
--signal dout_fantasma    : unsigned(16-1 downto 0);  

signal  dir_pacman    : unsigned (8-1 downto 0)  := ("0011" & fila_int);
--signal dout_pacman    : unsigned(16-1 downto 0); 

signal  dir_pista    : unsigned (5-1 downto 0); 
--signal dout_pista    : unsigned(32-1 downto 0); 

signal dout_pista_verde    : unsigned(32-1 downto 0); 
signal dout_pista_azul    : unsigned(32-1 downto 0); 

signal dout_pacman_rojo    : unsigned(16-1 downto 0); 
signal dout_pacman_verde    : unsigned(16-1 downto 0); 
signal dout_pacman_azul    : unsigned(16-1 downto 0); 


signal dout_fantasma_rojo    : unsigned(16-1 downto 0); 
signal dout_fantasma_verde    : unsigned(16-1 downto 0); 
signal dout_fantasma_azul    : unsigned(16-1 downto 0); 

--signal rojo_2  :  std_logic_vector(8-1 downto 0);
--signal verde_2 :  std_logic_vector(8-1 downto 0);
--signal azul_2  :  std_logic_vector(8-1 downto 0);

constant ROJO_COLOR :  std_logic_vector(3-1 downto 0)    := "100";
constant VERDE_COLOR :  std_logic_vector(3-1 downto 0)    := "010";
constant AZUL_COLOR  :  std_logic_vector(3-1 downto 0)    := "001";
constant BLANCO_COLOR  :  std_logic_vector(3-1 downto 0)    := "111";
constant AMARILLO_COLOR :  std_logic_vector(3-1 downto 0)    := "110";
constant MAGENTA_COLOR  :  std_logic_vector(3-1 downto 0)    := "101";
constant CYAN_COLOR  :  std_logic_vector(3-1 downto 0)    := "011";

--constant CAMINO : std_logic_vector (3-1 downto 0)  := "111";
--constant FONDO : std_logic_vector (3-1 downto 0)  := "000";
signal PINTAR_PISTA : std_logic_vector (3-1 downto 0);
signal PINTAR_PACMAN : std_logic_vector (3-1 downto 0);
signal PINTAR_FANTASMA : std_logic_vector (3-1 downto 0);
signal PINTA_FINAL : std_logic_vector (3-1 downto 0);

signal SEL : unsigned(5-1 downto 0); --señal de seleccion para pintar la pista, pacman y fantasma
--signal SEL2 : std_logic;
signal SEL_PISTA : std_logic_vector (2-1 downto 0);
signal SEL_PACMAN : std_logic_vector (3-1 downto 0);
signal SEL_FANTASMA : std_logic_vector (3-1 downto 0);
signal SELECTOR_1 :  std_logic;
signal SELECTOR_2 :  std_logic;
signal SELECTOR : std_logic_vector (2-1 downto 0);


begin
--PISTA BLANCO Y NEGRO
--PISTA : ROM1b_1f_racetrack_1 port map (clk => clk,
--                                       addr => dir_pista,
--                                       dout => dout_pista);
--PISTA DE COLORES
PISTA_VERDE : ROM1b_1f_green_racetrack_1 port map (clk => clk,
                                                   addr => dir_pista,
                                                   dout => dout_pista_verde);
                                       
PISTA_AZUL : ROM1b_1f_blue_racetrack_1 port map (clk => clk,
                                                 addr => dir_pista,
                                                 dout => dout_pista_azul);                                                                              
--PACMAN DE UN SOLO COLOR
--PACMAN : ROM1b_1f_imagenes16_16x16_bn port map( clk  => clk,
--                                                addr => dir_pacman,
--                                                dout => dout_pacman); 
--PACMAN DE VARIOS COLORES                                   
PACMAN_ROJO : ROM1b_1f_red_imagenes16_16x16 port map( clk  => clk,
                                                      addr => dir_pacman,
                                                      dout => dout_pacman_rojo); 
                                   
PACMAN_VERDE : ROM1b_1f_green_imagenes16_16x16 port map( clk  => clk,
                                                         addr => dir_pacman,
                                                         dout => dout_pacman_verde); 
                                   
PACMAN_AZUL : ROM1b_1f_blue_imagenes16_16x16 port map( clk  => clk,
                                                       addr => dir_pacman,
                                                       dout => dout_pacman_azul);
--FANTASMA DE VARIOS COLORES                                                       
FANTASMA_ROJO : ROM1b_1f_red_imagenes16_16x16 port map( clk  => clk,
                                                      addr => dir_fantasma,
                                                      dout => dout_fantasma_rojo); 
                                   
FANTASMA_VERDE : ROM1b_1f_green_imagenes16_16x16 port map( clk  => clk,
                                                         addr => dir_fantasma,
                                                         dout => dout_fantasma_verde); 
                                   
FANTASMA_AZUL : ROM1b_1f_blue_imagenes16_16x16 port map( clk  => clk,
                                                       addr => dir_fantasma,
                                                       dout => dout_fantasma_azul);      
--FANTASMA DE UN SOLO COLOR
--FANTASMA : ROM1b_1f_imagenes16_16x16_bn port map( clk  => clk,
--                                                  addr => dir_fantasma,
--                                                  dout => dout_fantasma); 
--MULTIPLEXOR PARA PISTA DE VARIOS COLORES                               
PISTA_AZUL_O_VERDE : MUX_PISTA_VERDE_AZUL port map (BLANCO => BLANCO_COLOR,
                                                    AZUL => AZUL_COLOR,
                                                    VERDE => VERDE_COLOR,
                                                    ROJO => ROJO_COLOR,
                                                    SEL => SEL_PISTA,
                                                    PINTAR => PINTAR_PISTA);
--MULTIPLEXOR PARA PACMAN DE VARIOS COLORES                                                     
PACMAN_COLOR : MUX_PERSONAJES_COLORES port map (BLANCO => BLANCO_COLOR, 
                                            AZUL => AZUL_COLOR,     
                                            VERDE => VERDE_COLOR,   
                                            ROJO => ROJO_COLOR,
                                            AMARILLO => AMARILLO_COLOR,
                                            MAGENTA => MAGENTA_COLOR,
                                            CYAN => CYAN_COLOR,
                                            fondo => PINTAR_PISTA,      
                                            SEL => SEL_PACMAN,
                                            PINTAR_PERSONAJE_COLOR => PINTAR_PACMAN);
--MULTIPLEXOR PARA FANTASMA DE VARIOS COLORES                                                     
FANTASMA_COLOR : MUX_PERSONAJES_COLORES port map (BLANCO => BLANCO_COLOR, 
                                                AZUL => AZUL_COLOR,     
                                                VERDE => VERDE_COLOR,   
                                                ROJO => ROJO_COLOR,
                                                AMARILLO => AMARILLO_COLOR,
                                                MAGENTA => MAGENTA_COLOR,
                                                CYAN => CYAN_COLOR,
                                                fondo => PINTAR_PISTA,     
                                                SEL => SEL_FANTASMA,
                                                PINTAR_PERSONAJE_COLOR => PINTAR_FANTASMA); 
PINTA_TODO : MUX_FONDO_O_PERSONAJES port map (PACMAN => PINTAR_PACMAN, 
                                               FANTASMA => PINTAR_FANTASMA,     
                                               PISTA => PINTAR_PISTA, 
                                               SELECTOR => SELECTOR,   
                                               SALIDA => PINTA_FINAL);                                                                                                                                                       
                                                    
SEL_PISTA <= dout_pista_verde(to_integer(SEL))&dout_pista_azul(to_integer(SEL)); --selector de color de pista                                                                             
SEL_PACMAN <= dout_pacman_rojo(to_integer(col_int))&dout_pacman_verde(to_integer(col_int))&dout_pacman_azul(to_integer(col_int)); --selector de color de pacman                                                                                                                                                 
SEL_FANTASMA <= dout_fantasma_rojo(to_integer(col_int))&dout_fantasma_verde(to_integer(col_int))&dout_fantasma_azul(to_integer(col_int)); --selector de color de fantasma                                                                             
SELECTOR_1 <= '1' when (col_ext = col_per AND fila_ext = fila_per) else '0';                                                                   
SELECTOR_2 <= '1' when (col_ext = fila_fantasma AND fila_ext = col_fantasma) else '0';
SELECTOR <= SELECTOR_1&SELECTOR_2;                                                                 
--SEL2 <= '0' when dout_pista(to_integer(SEL))= '1' else '1';       --selector de pista blanco y negro
col_int<=col(3 downto 0);
fila_int<=fila(3 downto 0);
col_ext<=col(9 downto 4);
fila_ext<=fila(9 downto 4);

dir_pista <=fila (8 downto 4); 
SEL <= col (8 downto 4);


  P_pinta: Process (visible,col,fila)
  begin
    rojo   <= (others=>'0');
    verde  <= (others=>'0');
    azul   <= (others=>'0');
    
    if visible = '1' then
        rojo   <= (others=>PINTA_FINAL(2)); 
        verde  <= (others=>PINTA_FINAL(1)); 
        azul   <= (others=>PINTA_FINAL(0));  
        
        if col>512 then
            rojo   <= (others=>'0');
            verde  <= (others=>'0');
            azul   <= (others=>'0');
        end if;
     else 
        rojo   <= (others=>'0');
        verde  <= (others=>'0');
        azul   <= (others=>'0');
    end if;
    
  end process;

end Behavioral;
