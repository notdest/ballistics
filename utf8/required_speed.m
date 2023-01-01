addpath('includes');


rampAngle       = 54;           % Угол вылета в градусах
landingAngle    = 20;           % Угол приземления в градусах
landingDistance = 5;            % Расстояние в метрах от вылета до приземления по горизонтали
rampHeight      = 2;          	% Высота кромки вылета над основанием, где измеряем скорость. метры
landingLevel    = -1;           % Высота точки приземления относительно точки вылета, метры
                                % Отрицательно если ниже

cHeigt          = 1;        	% Высота центра тяжести от покрытия


G           = 9.807;
angle       = rampAngle*pi/180;
aerodynamic	= aerodynamic_coefficient();
centerHeigt = 0;% Потом отдельно вычисляют траекторию подошвы, поэтому так
landingAngle = landingAngle*pi/180;
lastX       = landingDistance+sin(angle)*cHeigt+sin(landingAngle)*cHeigt;
lastY       = -50;

speed   = 8;    % случайно взяли начальную скорость
step    = 2;    % и какой-то шаг изменения

direction   = 0;
for i = 1:500
    res     = sim('flight_model');

    Xs      = res.realX.Data;
    Ys      = res.realY.Data;
    heihgt  = Ys(end);

    if heihgt > (landingLevel-cos(angle)*cHeigt+cos(landingAngle)*cHeigt)% Смотрим в какую сторону ошиблись
        newDirection = 1;
    else
        newDirection = -1;
    end
    
    if direction == 0
        direction = newDirection;
    elseif direction ~= newDirection	% Если в другую - уменьшаем шаг и идем туда
        if step > 0.01
            step     = step/4;
            direction = newDirection;
        else
           break 
        end
    end
    
    if direction > 0                    % Непосредственно меняем скорость
        speed   = speed - step;
    else
        speed   = speed + step;
    end
end

fprintf('\nТребуемая скорость на кромке: %.1f км/ч\n',speed*3.6)
speed   = sqrt(speed^2 + 2*G*rampHeight);
fprintf('Требуемая скорость у основания: %.1f км/ч\n',speed*3.6)
%------------------------------------------------------------------------
%---------------------- Отрисовку попирую из flight_details.m -----------
Xs      = res.X.Data - (sin(angle)*cHeigt);
Ys      = res.Y.Data + (cos(angle)*cHeigt);
realXs  = zeros(1,length(Xs));
realYs  = zeros(1,length(Xs));
speeds  = res.speed.Data;
angles  = res.angle.Data;

for i = 1:length(Xs)
    curAngle    = angle +((Xs(i)-Xs(1))/(Xs(end)-Xs(1)))*(-landingAngle-angle);
    realXs(i)   = Xs(i)+sin(curAngle)*cHeigt;
    realYs(i)   = Ys(i)-cos(curAngle)*cHeigt;
end


hitSpeed     = speeds(end)*sin(-angles(end)-landingAngle);
hit          = ((hitSpeed^2)/(2*G))*(2/(3-cos(landingAngle)));
fprintf('Удар в ноги: %.1f м\n',hit)


t               = tiledlayout(3,4);
t.TileSpacing   = 'compact';
t.Padding       = 'compact';

nexttile(2,[2 3]);
plot(Xs,Ys,'b:');
hold on
plot(realXs,realYs,'b-')
draw_angle(landingDistance,landingLevel,-landingAngle); % Отрисовка приземления
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
plot(Xs,speeds);

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
plot(Xs,res.tout);
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
