addpath('includes');


rampAngle       = 54;           % Угол вылета в градусах
landingAngle    = 20;           % Угол приземления в градусах
landingDistance = 5;            % Расстояние в метрах от вылета до приземления по горизонтали
landingLevel    = -1;           % Высота точки приземления относительно точки вылета, метры
                                % Отрицательно если ниже


centerHeigt = 1;            % Высота центра тяжести от покрытия

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
fprintf('\nТребуемая скорость %.1f км/ч\n',speed*3.6)

plot(Xs,Ys);
draw_angle(landingDistance,landingLevel,-landingAngle*pi/180);
axis image
