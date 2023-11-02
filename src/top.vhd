library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity top is
    Port (
        digits_0to3 : in std_logic_vector(15 downto 0);
        digits_4to7 : in std_logic_vector(15 downto 0);
        blink_pairs : in std_logic_vector(3 downto 0);
        CLK100MHZ  : in std_logic;
        SEGMENT : out STD_LOGIC_VECTOR (6 downto 0);
        digctrl : out STD_LOGIC_VECTOR (7 downto 0)
    );
end top;





architecture Behavioral of top is
    
    component contador is
      Port (
        code : out std_logic_vector(2 downto 0)
      );
    end component;
    component decoder IS
        PORT (
        code : IN std_logic_vector(3 DOWNTO 0);
        led : OUT std_logic_vector(6 DOWNTO 0)
        );
    END component decoder;
    component mux8_4c IS
        PORT (
            in0 : IN std_logic_vector(3 DOWNTO 0);
            in1 : IN std_logic_vector(3 DOWNTO 0);
            in2 : IN std_logic_vector(3 DOWNTO 0);
            in3 : IN std_logic_vector(3 DOWNTO 0);
            in4 : IN std_logic_vector(3 DOWNTO 0);
            in5 : IN std_logic_vector(3 DOWNTO 0);
            in6 : IN std_logic_vector(3 DOWNTO 0);
            in7 : IN std_logic_vector(3 DOWNTO 0);
            select_c : IN std_logic_vector(2 DOWNTO 0);
            out_c : OUT std_logic_vector(3 DOWNTO 0)
        );
    END component mux8_4c;
    component anodo_decoder is
        port (
            digctrl : out std_logic_vector(2 downto 0);
            DIGISEL : in std_logic_vector(2 downto 0)
        );
    end component;

    signal contador_out : std_logic_vector(2 downto 0);
    signal code_display : std_logic_vector(3 downto 0);
    
begin


    -- contador
    contador_multiplexacion : contador port map (code => contador_out);


    -- multiplexor:
    mux : mux8_4c port map (
    in0 => digits_0to3(15 downto 12),
    in1 => digits_0to3(11 downto 8),
    in2 => digits_0to3(7 downto 4),
    in3 => digits_0to3(3 downto 0),
    in4 => digits_4to7(15 downto 12),
    in5 => digits_4to7(11 downto 8),
    in6 => digits_4to7(7 downto 4),
    in7 => digits_4to7(3 downto 0),
    select_c => contador_out,
    out_c => code_display
    );


    -- Anodos del display:
    decodificador_anodos : anodo_decoder port map (digctrl => digctrl, DIGISEL => code_display);


    -- Catodos del display:
    disp_decoder: decoder_disp port map (LED => SEGMENT, CODE => s3);


end Behavioral;

