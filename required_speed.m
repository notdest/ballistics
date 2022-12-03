addpath('includes');


rampAngle       = 54;           % ���� ������ � ��������
landingAngle    = 20;           % ���� ����������� � ��������
landingDistance = 5;            % ���������� � ������ �� ������ �� ����������� �� �����������
landingLevel    = -1;           % ������ ����� ����������� ������������ ����� ������, �����
                                % ������������ ���� ����


centerHeigt = 1;            % ������ ������ ������� �� ��������

angle       = rampAngle*pi/180;
lastX       = landingDistance;
lastY       = -50;
aerodynamic	= aerodynamic_coefficient();

speed   = 8;    % �������� ����� ��������� ��������
step    = 2;    % � �����-�� ��� ���������


direction   = 0;
for i = 1:500
    res     = sim('flight_model');

    Xs      = res.realX.Data;
    Ys      = res.realY.Data;
    heihgt  = Ys(end);

    if heihgt > landingLevel            % ������� � ����� ������� ��������
        newDirection = 1;
    else
        newDirection = -1;
    end
    
    if direction == 0
        direction = newDirection;
    elseif direction ~= newDirection	% ���� � ������ - ��������� ��� � ���� ����
        if step > 0.01
            step     = step/4;
            direction = newDirection;
        else
           break 
        end
    end
    
    if direction > 0                    % ��������������� ������ ��������
        speed   = speed - step;
    else
        speed   = speed + step;
    end
end
fprintf('\n��������� �������� %.1f ��/�\n',speed*3.6)

plot(Xs,Ys);
draw_angle(landingDistance,landingLevel,-landingAngle*pi/180);
axis image
