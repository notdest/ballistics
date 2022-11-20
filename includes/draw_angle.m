function draw_angle(X,Y,angle)
    len = 1.1;  % ƒлина черты, самое логичное - равна базе велосипеда
    x1  = X - cos(angle)*len/2;
    x2  = X + cos(angle)*len/2;
    y1  = Y - sin(angle)*len/2;
    y2  = Y + sin(angle)*len/2;
    line([x1,x2],[y1,y2],'linestyle','-','color','r');
end