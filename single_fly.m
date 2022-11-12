
angle       = 30;          	% ���� ������ � ��������
hit         = 0.5;       	% �������� ���� � ����, � ������ ������
speed      	= 7;            % �������� � �/� �� ����� ������
centerHeigt = 1;            % ������ ������ ������� �� ��������

G               = 9.807;            % ��������� ���������� �������
angleRad        = angle*pi/180;




hitSpeed        = sqrt(2*G*hit);        % �������� �� ������� � �����������, ��� �������� �����
verticalSpeed   = speed*sin(angleRad);  % ��������� ������������ ��������
horizontalSpeed = speed*cos(angleRad);  % ��������� �������������� ��������

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
title('��������� �����');

speeds  = speeds*3.6; % ��������� � ��/�
nexttile
plot(realXs,speeds,'b-');
title('�������� �����');
