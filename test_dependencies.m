% Скрипт считает вклад аэродинамики в метрах от длинны полёта
angle       = 45;          	% Угол вылета в градусах
centerHeigt = 1;            % Высота центра тяжести от покрытия

lastX       = 1000;      	% После этой дистанции модель останавливается
lastY       = -0.01;        % Ниже этой высоты модель останавливается

G         	= 9.807;
angle       = angle*pi/180;

limit   = 80;
Xs      = zeros(1,limit);
Ys      = zeros(1,limit);
for i=1:limit
    aerodynamic = aerodynamic_coefficient();
    speed    	= i/3.6;
    res     = sim('flight_model');       	% Запуск модели
    length1 = res.realX.Data(end);

    if length1>0
        Xs(i)	= length1;
    end
    
    aerodynamic = 0;
    res     = sim('flight_model');       	% Запуск модели
    length2 = res.realX.Data(end);

    if length2>0
        Ys(i) 	= length2-length1;
    end
end
plot(Xs,Ys);