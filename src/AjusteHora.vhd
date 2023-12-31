

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity AjusteHora is
    generic (
    codeState : std_logic_vector (7 downto 0) := "10000000"   --Estado de funcionamiento (ajuste o alarma)
    );
    Port ( buttons      : in STD_LOGIC_VECTOR (3 downto 0);
           format12_24  : in STD_LOGIC;
           clk          : in STD_LOGIC;
           stateActive  : in STD_LOGIC_VECTOR (7 downto 0);
           digits0to3   : out STD_LOGIC_VECTOR (15 downto 0);
           digits4to7   : out STD_LOGIC_VECTOR (15 downto 0);
           blinkControl : out STD_LOGIC_VECTOR (7 downto 0));
end AjusteHora;

architecture Behavioral of AjusteHora is
    --S0 = decHoras; S1 = udsHora; S2 = decMins; S3 = udsMins;
    type STATES is (S0,S1,S2,S3);
    signal currentState: STATES := S0; 
    signal nextState: STATES;
    
    signal udsMin : std_logic_vector (3 downto 0) := "0000";
    signal decMin : std_logic_vector (3 downto 0) := "0000";
    signal udsHora : std_logic_vector (3 downto 0):= "0000";
    signal decHora : std_logic_vector (3 downto 0):= "0000";
    
    signal salidaSecs : std_logic_vector(7 downto 0) := "00000000";
    signal salidaNoUse : std_logic_vector(7 downto 0) := "11111111";
    
    signal blink_s : std_logic_vector (7 downto 0):="11111111";

    
    --MAXIMO DE HORAS INICIALMENTE 24
    signal maxUdsHora : std_logic_vector(3 downto 0) := "0011";
    signal maxDecHora : std_logic_vector(3 downto 0) := "0010";
begin
    --Paso a siguiente estado
    process (clk)
    begin
        if stateActive = codeState then
            if rising_edge (clk) then
                currentState <= nextState;              
            end if;
        end if;
    end process;
    
    --Cambio de estado
    process(buttons, currentState, clk)
    begin
        if stateActive = codeState then
            nextState <= currentState;
            case currentState is
                when S0 =>
                    if buttons = "0010" then
                        nextState <= S3;
                    elsif buttons = "0100" then
                        nextState <= S1;
                    end if;
                when S1 =>
                    if buttons = "0010" then
                        nextState <= S0;
                    elsif buttons = "0100" then
                        nextState <= S2;
                    end if;
                when S2 =>
                    if buttons = "0010" then
                        nextState <= S1;
                    elsif buttons = "0100" then
                        nextState <= S3;
                    end if;                   
                when S3 =>
                    if buttons = "0010" then
                        nextState <= S2;
                    elsif buttons = "0100" then
                        nextState <= S0;
                    end if;
                when others =>
            end case;
        end if;                
    end process;

--Logica de estados
    process (currentState, clk)
    begin    
        if stateActive = codeState and rising_edge(clk) then
            case currentState is
                when S0 =>  --DEC HORAS
                    --si boton arriba suma uno o da la vuelta si esta en max
                    if buttons = "0001" then
                        if decHora = maxDecHora then
                            decHora <= "0000";
                        else
                             decHora <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(decHora)) + 1, decHora'length));
                        end if;
                    end if;
                    --si boton abajo resta uno o da la vuelta si esta en 0
                    if buttons = "1000" then
                        if decHora = "0000" then
                            decHora <= maxDecHora;
                        else
                             decHora <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(decHora)) - 1, decHora'length));
                        end if;
                    end if;
                    if decHora = maxDecHora and udsHora > maxUdsHora then
                        udsHora <= maxUdsHora;
                    end if;
                    
                    blink_s <= "00100000";
                when S1 =>  --UDS HORAS
                    --si boton arriba suma uno o da la vuelta si esta en 9 o dec max y uds max
                    if buttons = "0001" then
                        if udsHora = "1001" or (decHora = maxDecHora and udsHora = maxUdsHora) then 
                            udsHora <= "0000";
                        else 
                            udsHora <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(udsHora)) + 1, udsHora'length));
                        end if;
                    end if;
                    
                    --si boton abajo resta uno o va a 9 si esta en 0 o al max uds
                    if buttons = "1000" then 
                        if udsHora = "0000" and decHora = maxDecHora then 
                            udsHora <= maxUdsHora;
                        elsif udsHora = "0000" then
                            udsHora <= "1001";
                        else 
                            udsHora <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(udsHora)) - 1, udsHora'length));
                        end if;
                    end if;
                    
                     blink_s <= "00010000";
                when S2 =>  --DEC MINS
                    --si boton arriba suma uno o da la vuelta si esta en 5
                    if buttons = "0001" then
                        if decMin = "0101" then
                            decMin <= "0000";
                        else
                            decMin <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(decMin)) + 1, decMin'length));
                        end if;
                    end if;
                    --si boton abajo resta uno o da la vuelta si esta en 0
                    if buttons = "1000" then
                        if decMin = "0000" then
                            decMin <= "0101";
                        else
                            decMin <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(decMin)) - 1, decMin'length));
                        end if;
                    end if;
                    
                     blink_s <= "00001000";          
                when S3 => --UDS MINS
                    --si boton arriba suma uno o da la vuelta si esta en 9
                    if buttons = "0001" then
                        if udsMin = "1001" then
                            udsMin <= "0000";
                        else
                            udsMin <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(udsMin)) + 1, udsMin'length));
                        end if;
                    end if;
                    --si boton abajo resta uno o da la vuelta si esta en 0
                    if buttons = "1000" then
                        if udsMin = "0000" then
                            udsMin <= "1001";
                        else
                            udsMin <= std_logic_vector(to_unsigned(TO_INTEGER(unsigned(udsMin)) - 1, udsMin'length));
                        end if;
                    end if;
                    
                     blink_s <= "00000100";                           
                when others =>
            end case;
        end if;
    end process; 
    
    digits0to3 <= decMin & udsMin & salidaSecs;
    digits4to7 <= salidaNoUse & decHora & udsHora;
    blinkControl <= blink_s;
    
end Behavioral;
