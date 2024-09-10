% Shape-Modell Extend your function generateShape.m so that it allows rotation,
% scaling and translation of shapes according to the parameters r, s, x, y (hint:
% rotation matrix). Next to the parameter vector b, the extended function should have
% 4 additional parameters:
% p = (b, scaling, rotation, x−translation, y −translation). Similar to the first
% exercise, plot shapes for different values of scaling and rotation parameters. (7
% points)

% generateShape has been adjusted to work with scaling, rotation, x-translation and y-translation

%check out different parameters

clear all;
load handdata.mat;

nEigenvectors = 2;
theta = 2*pi/3; % radiant
b = zeros(nEigenvectors,1);
r = [cos(theta)   -sin(theta);
    sin(theta)  cos(theta) ];
s = 1;
x = 0;
y = 0;
[reconstruction,mean,eigenVect,stddeviation] = extendedGenerateShape(b,s,r,x,y);
stdeviation = stddeviation.';
b(1,1) = stddeviation(1,1);

% plot rotation
figure
subplot(1,2,1)
theta = 0; % radiant
r = [cos(theta)   -sin(theta);
    sin(theta)  cos(theta) ];
plotExtendedShape(mean,eigenVect,b,s,r,x,y);
title('Rotation of 0');

subplot(1,2,2)
theta = 2*pi/3; % radiant
r = [cos(theta)   -sin(theta);
    sin(theta)  cos(theta) ];
plotExtendedShape(mean,eigenVect,b,s,r,x,y);
title('Rotation of 2pi/3 ')

exportgraphics(gcf,'FigureRotation.png','Resolution',300)

%plot scaling
figure
subplot(1,2,1)
s = 1;
plotExtendedShape(mean,eigenVect,b,s,r,x,y);
title('Scaling of 1');

% + and minus same scaling results?
subplot(1,2,2)
s = 10;
plotExtendedShape(mean,eigenVect,b,s,r,x,y);
title('Scaling of 10');

exportgraphics(gcf,'FigureScaling.png','Resolution',300)

%plot translation
figure
subplot(1,2,1)
s = 1;
x = 50;
plotExtendedShape(mean,eigenVect,b,s,r,x,y);
title('X- Translation by 50');

% + and minus same scaling results?
subplot(1,2,2)
y = 50;
plotExtendedShape(mean,eigenVect,b,s,r,x,y);
title('x+y Translation by 50');

exportgraphics(gcf,'FigureTranslation.png','Resolution',300)