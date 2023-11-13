-- Trabajo SED 23/24 Grupo 2
-- Entidad principal del despertador


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
library UNISIM;
use UNISIM.VComponents.all;

use work.my_components.all;



entity TOP is
    Port (
        SW : in std_logic_vector(15 downto 0);
        CLK100MHZ  : in std_logic;
        SEGMENT : out STD_LOGIC_VECTOR (6 downto 0);
        digctrl : out STD_LOGIC_VECTOR (7 downto 0);
		BTNU : in std_logic;
		BTNC : in std_logic;
		BTNL : in std_logic;
		BTNR : in std_logic;
		BTND : in std_logic;
		BUZZER : out std_logic
    );
end TOP;

architecture Structual of TOP is



	----------------------------------------------------------------------------
	--                     SEÑALES GENERALES
	----------------------------------------------------------------------------

	signal mode : std_logic_vector(3 downto 0) := "0000";
	signal UP : std_logic := '0';
	signal LEFT : std_logic := '0';
	signal RIGHT : std_logic := '0';
	signal DOWN : std_logic := '0';
	signal OK : std_logic := '0';

	signal buttons : std_logic_vector(3 downto 0);

	signal out_mode_12_24 : std_logic := '0';

    signal digits_0to3 : std_logic_vector(15 downto 0);
    signal digits_4to7 : std_logic_vector(15 downto 0);
    signal blink_ctrl : std_logic_vector(7 downto 0);

    signal alarma_1_on : std_logic;
    signal alarma_2_on : std_logic;

    signal selected_days_alm : std_logic_vector(6 downto 0);

    signal digits_0to3_0 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_0 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_1 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_1 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_2 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_2 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_3 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_3 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_4 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_4 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_5 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_5 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_6 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_6 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_7 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_7 : std_logic_vector(15 downto 0) := "1111111111111111";


    signal digits_0to3_8 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_8 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_9 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_9 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_10 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_10 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_11 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_11 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_12 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_12 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_13 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_13 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_14 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_14 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_0to3_15 : std_logic_vector(15 downto 0) := "1111111111111111";
    signal digits_4to7_15 : std_logic_vector(15 downto 0) := "1111111111111111";

    signal blink_ctrl_0 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_1 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_2 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_3 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_4 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_5 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_6 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_7 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_8 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_9 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_10 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_11 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_12 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_13 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_14 : std_logic_vector(7 downto 0) := "00000000";
    signal blink_ctrl_15 : std_logic_vector(7 downto 0) := "00000000";


begin
	

	buttons(3) <= UP;
	buttons(2) <= LEFT;
	buttons(1) <= RIGHT;
	buttons(0) <= DOWN;


	----------------------------------------------------------------------------
	--                  COMPONENTES GENERALES
	----------------------------------------------------------------------------

	displays_7seg: display
	    Port map (
	        digits_0to3 => digits_0to3,
	        digits_4to7 => digits_4to7,
	        blink_ctrl => blink_ctrl,
	        CLK => CLK100MHZ,
	        SEGMENT_CRTL => SEGMENT,
	        digctrl_CTRL => digctrl
	    );

	buttons_c : button_interface
		Port map(
	        CLK => CLK100MHZ,
			UP_SW => BTNU,
			LEFT_SW => BTNL,
			RIGHT_SW => BTNR,
			DOWN_SW => BTND,
			OK_SW => BTNC,
			UP => UP,
			LEFT => LEFT,
			RIGHT => RIGHT,
			DOWN => DOWN,
			OK => OK
		);

	contador : control_counter
		generic map(
			max_count => 7
		)
		Port map (
	        clk => CLK100MHZ,
	        counter_in => OK,
	        counter_out => mode
	    );

	alarma_sonora : alarma
		port map (
			clk => CLK100MHZ,
			on1 => alarma_1_on,
			on2 => alarma_2_on,
			buzzer => BUZZER,
			buttons_beep => buttons,
			mode_beep => OK
		);	


	mux16_0 : mux16_nc
	    generic map (
	        CHANEL_LENGTH => 16
	    )
	    PORT map(
	        in0 => digits_0to3_0,
	        in1 => digits_0to3_1,
	        in2 => digits_0to3_2,
	        in3 => digits_0to3_3,
	        in4 => digits_0to3_4,
	        in5 => digits_0to3_5,
	        in6 => digits_0to3_6,
	        in7 => digits_0to3_7,
	        in8 => digits_0to3_8,
	        in9 => digits_0to3_9,
	        in10 => digits_0to3_10,
	        in11 => digits_0to3_11,
	        in12 => digits_0to3_12,
	        in13 => digits_0to3_13,
	        in14 => digits_0to3_14,
	        in15 => digits_0to3_15,
	        select_c => mode,
	        out_c => digits_0to3
	    );

	mux16_1 : mux16_nc
	    generic map (
	        CHANEL_LENGTH => 16
	    )
	    PORT map(
	        in0 => digits_4to7_0,
	        in1 => digits_4to7_1,
	        in2 => digits_4to7_2,
	        in3 => digits_4to7_3,
	        in4 => digits_4to7_4,
	        in5 => digits_4to7_5,
	        in6 => digits_4to7_6,
	        in7 => digits_4to7_7,
	        in8 => digits_4to7_8,
	        in9 => digits_4to7_9,
	        in10 => digits_4to7_10,
	        in11 => digits_4to7_11,
	        in12 => digits_4to7_12,
	        in13 => digits_4to7_13,
	        in14 => digits_4to7_14,
	        in15 => digits_4to7_15,
	        select_c => mode,
	        out_c => digits_4to7
	    );



	mux16_2 : mux16_nc
	    generic map (
	        CHANEL_LENGTH => 8
	    )
	    PORT map(
	        in0 => blink_ctrl_0,
	        in1 => blink_ctrl_1,
	        in2 => blink_ctrl_2,
	        in3 => blink_ctrl_3,
	        in4 => blink_ctrl_4,
	        in5 => blink_ctrl_5,
	        in6 => blink_ctrl_6,
	        in7 => blink_ctrl_7,
	        in8 => blink_ctrl_8,
	        in9 => blink_ctrl_9,
	        in10 => blink_ctrl_10,
	        in11 => blink_ctrl_11,
	        in12 => blink_ctrl_12,
	        in13 => blink_ctrl_13,
	        in14 => blink_ctrl_14,
	        in15 => blink_ctrl_15,
	        select_c => mode,
	        out_c => blink_ctrl
	    );







	----------------------------------------------------------------------------
	--                    ESTADOS DEL SISTEMA
	----------------------------------------------------------------------------
	
	-- 0. Contador de hora
	
	
	-- 1. Contador de fecha
	
	
	-- 2. Contador de año
	
	
	-- 3. Alarma
	
	
	-- 4. Dias de la semana de la alarma
	selector_de_dias_alarma : day_alarm_selec
		generic map(
			MODE_NUM => "0100"
			);
		port map(
			moe => mode,
	        digits_0to3 => digits_0to3_4,
	        digits_4to7 => digits_4to7_4,
	        blink_ctrl => blink_ctrl_4,
	        CLK => CLK100MHZ,
	        buttons => buttons,
	        day_sel => selected_days_alm
		);
	
	-- 5. Cronometro
	
	
	-- 6. Cuenta atrás
	
	
	-- 7. Configuración 12/24h
	config_12_24 : display_12_24
		generic map(
			MODE_NUM => "0111"
			);
	    Port map (
            clk => CLK100MHZ,
            mode => mode,
	        buttons => buttons,
	        digits_0to3 => digits_0to3_7,
	        digits_4to7 => digits_4to7_7,
	        blink_ctrl => blink_ctrl_7,
	        out_mode => out_mode_12_24
	    );



end Structual;



