//Aqui irá el contenido de la memoria sobre la practica 3


Esta práctica consiste en que el robot de lego pueda seguir el borde del mapa de granada tomando las medidas del sensor de luz que tiene incorporado y mediante estas, obtener la integral, con las medidas realizadas hasta el momento, la derivada del error cometido, y el error actual.

Para empezar, tenemos que calibrar el sensor de luz tomando los valores máximos de blanco y negro. Una vez hecho, se comienza el programa con los valores que hemos obtenido en la calibración para el blanco y el negro máximo.

El programa entrará en un bucle el cual, leerá del sensor de luz, la luminosidad que hay en ese momento, luego, se escala y normaliza respecto a los valores teóricos de blanco y negro, para más tarde restarle la media entre el blanco y negro teórico. Esto último se hace para calcular el "error", el cual indica si se está llendo más al blanco o más al negro para luego corregir esa desviación y volver a la luminosidad objetivo, que en realidad es la media usada al calcular el error. 

Una vez hecho todo esto, se calcula la integral haciendo la sumatoria de los errores hasta el momento, y se calcula también la derivada, la cual se hace con otra sumatoria que se calcula restando los errores anteriores al momento actual. Después de calcularlos, se usa una fórmula la cual relaciona la integral junto al error actual y a la derivada, los cuales representarían el pasado, presente y futuro de los errores cometidos. La fórmula sería: 

    turn = kp * error_lectura + ki * integral + kd * derivada; 

Siendo kp, ki y kd, constantes. 

Si turn fuese mayor de un umbral llamado WINDUP, de tal manera que turn estuviese fuera del rango [-WINDUP, WINDUP], entonces la fórmula cambiará y será:

    turn = kp * error_lectura + kd * derivada;

Y la integral quitará su último valor añadido para que no se acumule el error.

Una vez obtenido el turn, se usará para darle más o menos potencia a los motores y así girar o hacer que siga en línea recta el robot.
