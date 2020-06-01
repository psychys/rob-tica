% Fichero de practica7
% Inicio del programa
TextOut(0,LCD_LINE1,'-- Practica 7 --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');
while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

% Definicion de constantes
SetSensorUltrasonic(IN_2); % Inicial el sonar
SetSensorLight(IN_1);   %Inicializa el sensor de luz
t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
tiempo = 120000; % Tiempo en milisegundos que debe durar el programa
OnFwd(OUT_A,randi(10));
OnFwd(OUT_C,randi(10));
bucle=0;
while( (CurrentTick()-t_ini) <= tiempo)
    
        u = SensorUS(IN_2); % Lee el sonar
        
        %Lector del sensor de luz

        l = Sensor(IN_1); % Lee el sensor de luz
        TextOut(1,LCD_LINE3,strcat('Dist: ',num2str(u)));
        TextOut(1,LCD_LINE2,strcat('Light: ',num2str(l))); % Muestra por pantalla lo que detecta el sensor de luz
        % Fin del sensor de luz
        
        while(u<20)&&(l~=79)
            bucle=1;
           Off(OUT_C); % Detiene el motor de la izuierda
           
           OnFwd(OUT_A,100);
           l = Sensor(IN_1); % Lee el sensor de luz
           u = SensorUS(IN_2); % Lee el sonar
        end
        
        while(u>200)&&(l~=79)
            bucle=1;
           Off(OUT_C); % Detiene el motor de la izuierda
           
           OnFwd(OUT_A,30);
           l = Sensor(IN_1); % Lee el sensor de luz
           u = SensorUS(IN_2); % Lee el sonar
        end
        
        if(bucle==1)
            Off(OUT_AC); % Detiene el motor 
            OnFwd(OUT_A,randi(10));
            OnFwd(OUT_C,randi(10));
            bucle=0;
        end
        if(l==79)
            Off(OUT_AC); % Detiene los motores 
            TextOut(1,LCD_LINE1,'Papelito encontroado');
            TextOut(1,LCD_LINE2,'Pulse de nuevo para continuar');
            StatusLight(0,0);
            while(~ButtonPressed(BTNCENTER))
                % Esperamos a que se pulse el boton central
            end
            StatusLight(3,0);
            OnFwd(OUT_A,randi(10));
            OnFwd(OUT_C,randi(10));
        end
        
    
    
    
end

Off(OUT_AC); % Detiene los motores
TextOut(1,LCD_LINE7,'--The end--');
