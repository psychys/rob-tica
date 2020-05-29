TextOut(0,LCD_LINE1,'-- Practica 5 --');
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

potRecta = 50;
potGiroMotorA = 0;
potGiroMotorC = 100;

tiempo = 20000; % Tiempo en milisegundos que debe durar el programa
t_ini = CurrentTick();
tiempo_recta = 1000;
tiempo_giro = 299; % 299 hace el giro con mas de 90º hacia la izquierda, 300 hace el giro con menos de 90º
t_max = 0;

boolGiroRecta = true; % true recta, false giro
    
while((CurrentTick()-t_ini) <= tiempo)
    
    t_comienzo_movimiento = CurrentTick();
    
    if(boolGiroRecta)
        t_max = tiempo_recta;
        if((t_comienzo_movimiento - t_ini) + t_max > tiempo)
            t_max = tiempo;
            t_comienzo_movimiento = t_ini;
        end
        OnFwd(OUT_A,potRecta);
        OnFwd(OUT_C,potRecta);
    else
        t_max = tiempo_giro;
        if((t_comienzo_movimiento - t_ini) + t_max > tiempo)
            t_max = tiempo;
            t_comienzo_movimiento = t_ini;
        end
        OnFwd(OUT_A,potGiroMotorA);
        OnFwd(OUT_C,potGiroMotorC);
    end

    while((CurrentTick() - t_comienzo_movimiento) <= t_max)
        %Espera a que pase el tiempo que debe moverse
        t = CurrentTick()-t_ini;
        ra = MotorRotationCount(OUT_A); % Lee el encoder del motor izquierdo
        rc = MotorRotationCount(OUT_C); % Lee el encoder del motor derecho
        
        TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(t)));
        TextOut(1,LCD_LINE2,strcat('Deg A: ',num2str(ra)));
        TextOut(1,LCD_LINE3,strcat('Deg C: ',num2str(rc)));
    end
    
    boolGiroRecta = not(boolGiroRecta);
    
    Wait(50); % Espera 50 ms para continuar, haciendo que este sea el periodo
              % de ejecucion del bucle
end

Off(OUT_AC); % Detiene los motores
TextOut(1,LCD_LINE7,'--The end--');
Wait(3000);