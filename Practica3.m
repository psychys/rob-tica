% Fichero de practica3
% Inicio del programa
TextOut(0,LCD_LINE1,'-- Practica 3 --');
TextOut(0,LCD_LINE2,'Presione el boton central para');
TextOut(0,LCD_LINE3,'comenzar con la prueba');
while(~ButtonPressed(BTNCENTER))
    % Esperamos a que se pulse el boton central
end 
ClearScreen();

% Definicion de constantes
kp=0.65;
ki=0.8;
kd=0.8;
integral=0;
derivada=0;
ultimo_error=0;
WINDUP = 20;
potBase = 25;

BLANCO = 70;
% parte blanca del circuito de granada = 80
blanco = 80;

NEGRO = 35;
%parte negra del circuito de granada = 7
negro =7;
SetSensorLight(IN_1);   %Inicializa el sensor de luz
t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
tiempo = 30000; % Tiempo en milisegundos que debe durar el programa


while( (CurrentTick()-t_ini) <= tiempo)
    %Lector del sensor de luz

    l = Sensor(IN_1); % Lee el sensor de luz
    TextOut(1,LCD_LINE2,strcat('Light: ',num2str(l))); % Muestra por pantalla lo que detecta el sensor de luz
    
    lectura_recta = (l*(BLANCO-NEGRO)/(blanco-negro))+((-negro*(BLANCO-NEGRO))+(NEGRO*(blanco-negro)))/(blanco-negro);
    media_bn = (BLANCO+NEGRO)/2;
    error_lectura = lectura_recta - media_bn;
    
    % Fin del sensor de luz
    
    %Controlador PID
    
    integral = integral + error_lectura;
    derivada = error_lectura-ultimo_error;
    
    turn = kp*error_lectura + ki*integral + kd*derivada;
    
    if(turn > WINDUP || turn < -WINDUP)
        turn = kp*error_lectura + kd*derivada;
        integral = integral - error_lectura;
    end
    
    potA = potBase + turn;
    potC = potBase - turn;
    
    OnFwd(OUT_A,potA);
    OnFwd(OUT_C,potC);
    
    ultimo_error=error_lectura;
    
end

Off(OUT_AC); % Detiene los motores
TextOut(1,LCD_LINE7,'--The end--');
