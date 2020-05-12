TextOut(0,LCD_LINE1,'-- Seguimiento de lineas --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar');
while(~ButtonPressed(BTNCENTER))
    
end 
ClearScreen();

R = 40;
U = 5;
P = 5;
tiempo = 60000; % Tiempo en milisegundos que debe durar el programa
manejador = [];
tamano = 50000;
fichero = 'Datos';
CreateFile(fichero, tamano, manejador);


t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
SetSensorLight(IN_1);      % Inicia el sensor de luz
SetSensorUltrasonic(IN_2); % Inicial el sonar
ResetRotationCount(OUT_A); % Establece a 0 los encoder de los dos motores
ResetRotationCount(OUT_C); % A izquierda, C derecha

OnFwd(OUT_AC, P); % Arranca ambos motores con potencia P

while( (CurrentTick()-t_ini) <= tiempo)
    
    t = CurrentTick()-t_ini; % Tiempo transcurrido desde que se comenzo en milisegundos
    l = Sensor(IN_1); % Lee el sensor de luz [0,100]
    
    TextOut(1,LCD_LINE1,strcat('Tiempo: ',num2str(t)));
    TextOut(1,LCD_LINE2,strcat('Iluminacion: ',num2str(l)));
    WriteLnString(manejador, sprintf('%u\t%u',t, l), tamano);
    
    error = R-l;
    if(error < -U)
        OnFwd(OUT_A,-P);
        OnFwd(OUT_C,P);
    elseif(error > U)
        OnFwd(OUT_A,P);
        OnFwd(OUT_C,-P);
    else
        OnFwd(OUT_AC, P);
    end
    Wait(50); % Espera 50 ms para continuar, haciendo que este sea el periodo
              % de ejecucion del bucle
end

CloseFile(manejador);
Off(OUT_AC); % Detiene los motores
TextOut(1,LCD_LINE7,'--Terminado--');
Wait(3000);

