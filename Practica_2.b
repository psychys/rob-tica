TextOut(0,LCD_LINE1,'-- Ejercicio 2b--');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');
while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
SetSensorLight(IN_1);      % Inicia el sensor de luz
SetSensorUltrasonic(IN_2); % Inicial el sonar
ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha

OnFwd(OUT_AC,5); % Arranca ambos motores con potencia = 5
difRA=5;
tiempo = 5000; % Tiempo en milisegundos que debe durar el programa
contador=0;
while(contador < 5)
        
    while( (CurrentTick()-t_ini) <= tiempo)

        t = CurrentTick()-t_ini;
        l = Sensor(IN_1); % Lee el sensor de luz
        u = SensorUS(IN_2); % Lee el sonar
        ra = MotorRotationCount(OUT_A); % Lee el encoder del motor izquierdo
        rc = MotorRotationCount(OUT_C); % Lee el encoder del motor derecho
        
        TextOut(1,LCD_LINE4,strcat('Deg A: ',num2str(ra)));
        TextOut(1,LCD_LINE5,strcat('Deg C: ',num2str(rc)));
    
        Wait(50); % Espera 50 ms para continuar, haciendo que este sea el periodo
              % de ejecucion del bucle
    end

    Off(OUT_AC); % Detiene los motores
    
    Wait(500);
  %*  
    %-1490 ---> -28.42 diferencia
    %2448
    %-1421
    %2248
    if(ra>0)
    difRA=((((ra)*15)/850)-15);
    difRC=((((rc)*15)/850)-15);
    else
        difRA=((((ra)*15)/850)+15);
        difRC=((((rc)*15)/850)+15);
    end
    
    
    difRA=abs(difRA)+((abs(ra)*15)/850);
    difRC=abs(difRC)+((abs(rc)*15)/850);
    
    if(difRA>100)||(difRA<(-100))
        difRA=100; 
    end
    
    if(difRC>100)|| (difRC<(-100))
        difRC=100;
    end
    
    if(mod(contador,2)==0)
        difRA=-difRA;
        difRC=-difRC;
    end
        

    OnFwd(OUT_A,difRA);
    OnFwd(OUT_C,difRC);
    contador=contador+1;
    tiempo=tiempo+5000;
end 

Off(OUT_AC); % Detiene los motores
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);
