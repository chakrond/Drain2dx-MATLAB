function oneplot(xdat,ydat,xlb,ylb,xyax)

igridline=0;   % 0 - dotted, 1 - full
grey=[0.5882 0.5882 0.5882]; black=[0 0 0];

% Fig properties
  figNumber=figure( ...
   'Name','spectrum', ...
   'Units','centimeters', ...
   'Position',[10. 10. 14. 14],...
   'NumberTitle','off');      
  axh=axes( ... 
   'Units','centimeters', ...   
   'Fontname','Courier New',...
   'fontweight','light',...
   'FontSize',10, ...
   'Box','on');

dx=(xyax(2)-xyax(1))/5;
dy=(xyax(4)-xyax(3))/5;

set(gca,'xcolor',black); set(gca,'ycolor',black); 
set(gca,'XTick',[xyax(1):dx:xyax(2)])
set(gca,'YTick',[xyax(3):dy:xyax(4)])

axis(xyax);
xlabel(xlb); ylabel(ylb);
grid on; box on, if igridline==1; set(gca,'GridLineStyle','-'); end; 

figure(figNumber)
hold on
H_xx=plot(xdat,ydat);
set(H_xx, 'Color', [0.12 0.46 1.00], 'LineWidth', 2)
%hold off

return