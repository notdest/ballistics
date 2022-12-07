addpath('includes');


angle       = 45;             	% Угол вылет в градусах
speed       = 43;               % Скорость в км/ч у основания трамплина
error       = 3;                % отклонение скорости, км/ч
hit         = 0.4;              % удар приземления, метры, эквивалент прыжка с высоты
errorHit    = 1;                % удар на ошибочных траекториях, м
centerHeigt = 1;                % Высота центра тяжести от покрытия, м
rampHeight  = 2;                % Высота кромки вылета над основанием, где измеряли скорость. метры

lastX       = 1000;             % После этой дистанции модель останавливается
lastY       = -2;               % Ниже этой высоты модель останавливается
drawLen     = 2.4;              % Сколько последних метров полёта рисуем углы
drawStep    = 0.4;              % С каким шагом рисуем углы
aerodynamic = aerodynamic_coefficient();

speed       = speed/3.6;
error       = error/3.6;
hits        = [errorHit,hit,errorHit];
StartSpeeds = [speed-error,speed,speed+error];

G        	= 9.807;            % Ускорение свободного падения
angle    	= angle*pi/180;

refreshed = false;
for n = 1:length(StartSpeeds)
    speed  	= StartSpeeds(n);
    hit     = hits(n);

    speed       = sqrt(speed^2-2*G*rampHeight); % Падение скорости на трамплине
    hitSpeed	= sqrt(2*G*hit);        % Скорость по нормали к приземлению, даёт ощущение удара

    res     = sim('flight_model');

    Xs      = res.realX.Data;
    Ys      = res.realY.Data;
    angles  = res.angle.Data;
    speeds  = res.speed.Data;
    start   = Xs(end)- drawLen;

    plot(Xs,Ys);
    if not(refreshed)
       refreshed = true;
       hold on
    end

    if hit > 0
        for i=1:length(Xs)
            if Xs(i)>start
                ang = asin(hitSpeed/speeds(i)) + angles(i);
                draw_angle_text(Xs(i),Ys(i),ang);

                start   = start + drawStep;
            end
        end
    end
end
axis image

xl      = xlim();
yl      = ylim();
rangeX  = max(xl) - min(xl);
rangeY  = max(yl) - min(yl);
padding = max(rangeX,rangeY)*0.07;
xlim([xl(1)-padding,xl(2)+padding]);
ylim([yl(1)-padding,yl(2)+padding]);

title('Геометрия полёта');
xlabel('Дистанция(м)')
ylabel('Высота(м)')
hold off
