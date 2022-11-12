
angle       = 30;          	% Угол вылета в градусах
hit         = 0.5;       	% Желаемый удар в ноги, в метрах высоты
speed      	= 7;            % Скорость в м/с на кроке вылета
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
speeds  = res.speed.Data;

tiledlayout(2,1);

nexttile
plot(Xs,Ys,'b:');
hold on
plot(realXs,realYs,'b-');
axis image
hold off
title('Геометрия полёта');

speeds  = speeds*3.6; % переводим в км/ч
nexttile
plot(realXs,speeds,'b-');
title('Скорость полёта');
