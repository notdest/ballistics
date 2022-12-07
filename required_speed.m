addpath('includes');


rampAngle       = 54;           % Угол вылета в градусах
landingAngle    = 20;           % Угол приземления в градусах
landingDistance = 5;            % Расстояние в метрах от вылета до приземления по горизонтали
landingLevel    = -1;           % Высота точки приземления относительно точки вылета, метры
                                % Отрицательно если ниже


centerHeigt = 1;            % Высота центра тяжести от покрытия

G           = 9.807;
angle       = rampAngle*pi/180;
lastX       = landingDistance;
lastY       = -50;
aerodynamic	= aerodynamic_coefficient();

speed   = 8;    % случайно взяли начальную скорость
step    = 2;    % и какой-то шаг изменения


direction   = 0;
for i = 1:500
    res     = sim('flight_model');

    Xs      = res.realX.Data;
    Ys      = res.realY.Data;
    heihgt  = Ys(end);

    if heihgt > landingLevel            % Смотрим в какую сторону ошиблись
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
fprintf('\nТребуемая скорость: %.1f км/ч\n',speed*3.6)

%------------------------------------------------------------------------
%---------------------- Отрисовку попирую из flight_details.m -----------
Xs      = res.X.Data;
Ys      = res.Y.Data;
realXs  = res.realX.Data;
realYs  = res.realY.Data;
speeds  = res.speed.Data;
angles  = res.angle.Data;


landingAngle = landingAngle*pi/180;
hitSpeed     = (2/(3-cos(landingAngle)))*speeds(end)*sin(-angles(end)-landingAngle);
hit          = (hitSpeed^2)/(2*G);
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
