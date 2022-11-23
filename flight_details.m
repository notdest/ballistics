
angle       = 70;          	% Угол вылета в градусах
speed      	= 40;           % Скорость в км/ч на кроке вылета
centerHeigt = 1;            % Высота центра тяжести от покрытия

lastX       = 1000;      	% После этой дистанции модель останавливается
lastY       = -1;        	% Ниже этой высоты модель останавливается


G         	= 9.807;
angle       = angle*pi/180;
speed    	= speed/3.6;

res     = sim('flight_model');       	% Запуск модели

Xs      = res.X.Data;
Ys      = res.Y.Data;
realXs	= res.realX.Data;
realYs 	= res.realY.Data;
speeds  = res.speed.Data;

t               = tiledlayout(3,4);     % Далее отрисовка графиков
t.TileSpacing	= 'compact';
t.Padding       = 'compact';

nexttile(2,[2 3]);
plot(Xs,Ys,'b:');
hold on
plot(realXs,realYs,'b-')
axis image
                                        % здесь делаю padding для графика
rangeX  = max(max(Xs),max(realXs)) - min(min(Xs),min(realXs));
rangeY  = max(max(Ys),max(realYs)) - min(min(Ys),min(realYs));
padding = max(rangeX,rangeY)*0.07;
yl      = ylim();
xl      = xlim();
xl      = [xl(1)-padding,xl(2)+padding];
ylim([yl(1)-padding,yl(2)+padding]);
xlim(xl);

legend({'Центр тяжести','Подошва'},'Location','northeast')
xlabel('Дистанция(м)')
ylabel('Высота(м)')
hold off
title('Геометрия полёта');

speeds  = speeds*3.6; % переводим в км/ч
nexttile(10,[1 3])
yyaxis left
plot(realXs,speeds);

rangeY  = max(max(speeds),max(speeds)) - min(min(speeds),min(speeds));
padding = rangeY*0.07;
yl      = ylim();
yl      = [yl(1)-padding,yl(2)+padding];
ylim(yl);
xlim(xl);

xlabel('Дистанция(м)')
ylabel('Скорость(км/ч)')


yyaxis right
hold on
plot(realXs,res.tout);
hold off
ylabel('Время(сек)')
title('Параметры полёта');
legend({'Скорость','Время'},'Location','southeast')

nexttile(9)
Ys  = linspace(yl(1),yl(2),50);
Xs  = ((Ys/3.6).^2)/(2*G);
plot(Xs,Ys);
ylim(yl);
xlim([min(Xs),max(Xs)]);
xlabel('Высота(м)')
ylabel('Скорость(км/ч)')
title('Эквивалентная высота');
