% Una vez terminado la parte del robot, se leera los datos guardados y se
% calculará la odometria
fichero = 'DatosOnline';
fichDatosOffline = fopen(fichero,'r');
formatSpec = '%u\t%u\t%u';
A = fscanf(fichDatosOffline,formatSpec, [3 inf]);
fclose(fichDatosOffline);

rotl = A(1,:);
rotr = A(2,:);
t = A(3,:);
rotl0 = rotl(1);
rotr0 = rotr(1);
t0 = t(1);

x0 = 0;
y0 = 0;
theta0 = 0;

x = [x0];
y = [y0];
theta = [theta0];

for i = 1:size(rotl,2)
    [x0,y0,theta0] = odometry(x0,y0,theta0,t0,rotl0,rotr0,t(i),rotl(i),rotr(i)); 
    rotl0 = rotl(i);
    rotr0 = rotr(i);
    t0 = t(i);
    x = [x x0];
    y = [y y0];
    theta = [theta theta0];
end
u = x+cos(theta);
v = y+sin(theta);
hold on
plot(x,y,':o');
quiver(x,y,u,v,0.75);
hold off