
angle       = 30;          	% ���� ����� � ��������
hit         = 0.5;       	% �������� ���� � ����, � ������ ������
speed      	= 7;            % �������� � �/� �� ����� ������
start       = 3;            % X ������� � �������� ������������ ����
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
Angles  = res.angle.Data;

hold on
plot(Xs,Ys,'b:');
plot(realXs,realYs,'b-');

axis image
hold off
