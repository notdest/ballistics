
angle       = 70;          	% ���� ������ � ��������
speed      	= 40;           % �������� � ��/� �� ����� ������
centerHeigt = 1;            % ������ ������ ������� �� ��������

lastX       = 1000;      	% ����� ���� ��������� ������ ���������������
lastY       = -1;        	% ���� ���� ������ ������ ���������������


G         	= 9.807;
angle       = angle*pi/180;
speed    	= speed/3.6;

res     = sim('flight_model');       	% ������ ������

Xs      = res.X.Data;
Ys      = res.Y.Data;
realXs	= res.realX.Data;
realYs 	= res.realY.Data;
speeds  = res.speed.Data;

t               = tiledlayout(3,4);     % ����� ��������� ��������
t.TileSpacing	= 'compact';
t.Padding       = 'compact';

nexttile(2,[2 3]);
plot(Xs,Ys,'b:');
hold on
plot(realXs,realYs,'b-')
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
