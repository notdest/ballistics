addpath('includes');


rampAngle       = 54;           % ���� ������ � ��������
landingAngle    = 20;           % ���� ����������� � ��������
landingDistance = 5;            % ���������� � ������ �� ������ �� ����������� �� �����������
landingLevel    = -1;           % ������ ����� ����������� ������������ ����� ������, �����
                                % ������������ ���� ����


centerHeigt = 1;            % ������ ������ ������� �� ��������

G           = 9.807;
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

%------------------------------------------------------------------------
%---------------------- ��������� ������� �� flight_details.m -----------
Xs      = res.X.Data;
Ys      = res.Y.Data;
realXs  = res.realX.Data;
realYs  = res.realY.Data;
speeds  = res.speed.Data;

t               = tiledlayout(3,4);
t.TileSpacing   = 'compact';
t.Padding       = 'compact';

nexttile(2,[2 3]);
plot(Xs,Ys,'b:');
hold on
plot(realXs,realYs,'b-')
draw_angle(landingDistance,landingLevel,-landingAngle*pi/180); % ��������� �����������
axis image
                                        % ����� ����� padding ��� �������
rangeX  = max(max(Xs),max(realXs)) - min(min(Xs),min(realXs));
rangeY  = max(max(Ys),max(realYs)) - min(min(Ys),min(realYs));
padding = max(rangeX,rangeY)*0.07;
yl      = ylim();
xl      = xlim();
xl      = [xl(1)-padding,xl(2)+padding];
ylim([yl(1)-padding,yl(2)+padding]);
xlim(xl);

legend({'����� �������','�������'},'Location','northeast')
xlabel('���������(�)')
ylabel('������(�)')
hold off
title('��������� �����');

speeds  = speeds*3.6; % ��������� � ��/�
nexttile(10,[1 3])
yyaxis left
plot(realXs,speeds);

rangeY  = max(max(speeds),max(speeds)) - min(min(speeds),min(speeds));
padding = rangeY*0.07;
yl      = ylim();
yl      = [yl(1)-padding,yl(2)+padding];
ylim(yl);
xlim(xl);

xlabel('���������(�)')
ylabel('��������(��/�)')


yyaxis right
hold on
plot(realXs,res.tout);
hold off
ylabel('�����(���)')
title('��������� �����');
legend({'��������','�����'},'Location','southeast')

nexttile(9)
Ys  = linspace(yl(1),yl(2),50);
Xs  = ((Ys/3.6).^2)/(2*G);
plot(Xs,Ys);
ylim(yl);
xlim([min(Xs),max(Xs)]);
xlabel('������(�)')
ylabel('��������(��/�)')
title('������������� ������');
