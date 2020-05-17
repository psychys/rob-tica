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

kp=1;
ki=0.8;
kd=0.8;

BLANCO = 70;
% parte blanca del circuito de granada = 79
blanco = 79;

NEGRO = 35;
%parte negra del circuito de granada = 8
negro =8;
SetSensorLight(IN_1);   %Inicializa el sensor de luz
t_ini = CurrentTick();     % Obtiene el tiempo de simulacion actual
tiempo = 5000; % Tiempo en milisegundos que debe durar el programa

while( (CurrentTick()-t_ini) <= tiempo)
    %Lector del sensor de luz

    l = Sensor(IN_1); % Lee el sensor de luz
    TextOut(1,LCD_LINE2,strcat('Light: ',num2str(l))); % Muestra por pantalla lo que detecta el sensor de luz
    
    lectura_recta = (l*(BLANCO-NEGRO)/(blanco-negro))+((-negro*(BLANCO-NEGRO))+(NEGRO*(blanco-negro)))/(blanco-negro);
    media_bn = BLANCO+NEGRO/2;
    error_lectura = l - lectura_recta - media_bn; 
    
    % Fin del sensor de luz
    
        
    
    %Controlador PID
    
    G=kp+kd*s+(ki/s);
    
    % Parte integral
    
    integral = integral + error_lectura;
    
    turn = kp*error_lectura + ki*integral;
    
end
