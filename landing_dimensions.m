addpath('includes');


angle       = 45;             	% ���� ����� � ��������
speed       = 43;               % �������� � ��/� � ��������� ���������
error       = 3;                % ���������� ��������, ��/�
hit         = 0.4;              % ���� �����������, �����, ���������� ������ � ������
errorHit    = 1;                % ���� �� ��������� �����������, �
centerHeigt = 1;                % ������ ������ ������� �� ��������, �
rampHeight  = 2;                % ������ ������ ������ ��� ����������, ��� �������� ��������. �����

lastX       = 1000;             % ����� ���� ��������� ������ ���������������
lastY       = -2;               % ���� ���� ������ ������ ���������������
drawLen     = 2.4;              % ������� ��������� ������ ����� ������ ����
drawStep    = 0.4;              % � ����� ����� ������ ����
aerodynamic = aerodynamic_coefficient();

speed       = speed/3.6;
error       = error/3.6;
hits        = [errorHit,hit,errorHit];
StartSpeeds = [speed-error,speed,speed+error];

G        	= 9.807;            % ��������� ���������� �������
angle    	= angle*pi/180;

refreshed = false;
for n = 1:length(StartSpeeds)
    speed  	= StartSpeeds(n);
    hit     = hits(n);

    speed       = sqrt(speed^2-2*G*rampHeight); % ������� �������� �� ���������
    hitSpeed	= sqrt(2*G*hit);        % �������� �� ������� � �����������, ��� �������� �����

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

title('��������� �����');
xlabel('���������(�)')
ylabel('������(�)')
hold off
