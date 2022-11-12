
angle       = 30;          	% Угол вылет в градусах
hit         = 0.5;       	% Желаемый удар в ноги, в метрах высоты
speed      	= 7;            % Скорость в м/с на кроке вылета
start       = 3;            % X начиная с которого отрисовывать углы
centerHeigt = 1;            % Высота центра тяжести от покрытия

G               = 9.807;            % Ускорение свободного падения
angleRad        = angle*pi/180;




hitSpeed        = sqrt(2*G*hit);        % Скорость по нормали к приземлению, даёт ощущение удара
verticalSpeed   = speed*sin(angleRad);  % Начальная вертикальная скорость
horizontalSpeed = speed*cos(angleRad);  % Начальная горизонтальная скорость

res     = sim('single_flight');

Xs      = res.X.Data;
Ys      = res.Y.Data;
realXs	= res.realX.Data;
realYs 	= res.realY.Data;
Angles  = res.angle.Data;

hold on
plot(Xs,Ys,'b:');
plot(realXs,realYs,'b-');

axis image
hold off
