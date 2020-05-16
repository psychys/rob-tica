TextOut(0,LCD_LINE1,'-- Ejercicio 2b--');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');
while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

SetSensorLight(IN_1);      % Inicia el sensor de luz
SetSensorUltrasonic(IN_2); % Inicial el sonar
ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha

iteracionesMaximas = 3;
potenciaActual = 10;
tiempo = 5000; % Tiempo en milisegundos que debe durar el programa
contador=0;
objetivoRotaciones = 860;
rot_A_Pot_m = 0.1074; % Pendiente "m" de la recta calculada (y=m*x+a) para pasar de rotaciones por segundo a potencia
rot_A_Pot_a = -0.9325; % Variable "a" de la recta calculada (y=m*x+a) para pasar de rotaciones por segundo a potencia

Potencia = [];
DiferenciaRotacion = [];
RotacionObjetivo = [];
RotacionActual = [];

while(contador < iteracionesMaximas)
    t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
    OnFwd(OUT_AC,potenciaActual);
    
    while((CurrentTick()-t_ini) <= tiempo)

        t = CurrentTick()-t_ini;
        ra = MotorRotationCount(OUT_A); % Lee el encoder del motor izquierdo
        rc = MotorRotationCount(OUT_C); % Lee el encoder del motor derecho
        
        TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(t)));
        TextOut(1,LCD_LINE2,strcat('Deg A: ',num2str(ra)));
        TextOut(1,LCD_LINE3,strcat('Deg C: ',num2str(rc)));
    
        Wait(50); % Espera 50 ms para continuar, haciendo que este sea el periodo
              % de ejecucion del bucle
    end

    Off(OUT_AC); % Detiene los motores
    
    Wait(500);
    
    difRA = objetivoRotaciones-ra;    
    difRC = objetivoRotaciones-rc;
    difR = (difRA + difRC)/2; % Va en linea recta en nuestro caso y por lo tanto difRA 
                              % difRC deberian ser iguales, pero en la simulacion puede 
                              % haber una pequeña diferencia entre ellas
                              
    Potencia = [Potencia ; potenciaActual];
    DiferenciaRotacion = [DiferenciaRotacion ; difR];
    RotacionObjetivo = [RotacionObjetivo ; objetivoRotaciones];
    RotacionActual = [RotacionActual ; (ra+rc)/2];
    
    potenciaActual = (difR/(tiempo/1000))*rot_A_Pot_m + rot_A_Pot_a; % Traduce la diferencia de rotaciones a diferencia de velocidad
    
    if(potenciaActual<-100)
        potenciaActual = -100;
    elseif(potenciaActual>100)
        potenciaActual = 100;
    end
    
    contador=contador+1;
end 

T = table(Potencia, DiferenciaRotacion, RotacionObjetivo, RotacionActual)

Off(OUT_AC); % Detiene los motores
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);