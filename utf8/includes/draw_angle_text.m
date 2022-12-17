function draw_angle_text(X,Y,angle,Heght)
    len = 1.1;  % Длина черты, самое логичное - равна базе велосипеда

    % отладочный перпендикуляр, чтобы сопоставить ЦТ и подошву
    %line([X,X+sin(angle)*Heght],[Y,Y-cos(angle)*Heght],'linestyle','-','color','r');

    X   = X + sin(angle)*Heght;
    Y   = Y - cos(angle)*Heght;

    x1  = X - cos(angle)*len/2;
    x2  = X + cos(angle)*len/2;
    y1  = Y - sin(angle)*len/2;
    y2  = Y + sin(angle)*len/2;
    line([x1,X],[y1,Y],'linestyle','-','color','r');
    line([X,x2],[Y,y2],'linestyle','-','color','r');

    angle   = -angle*180/pi;
    text(x2+0.05,y2,strcat(num2str(angle,3),'°'));
end