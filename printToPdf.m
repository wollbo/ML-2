function [ ] = printToPdf( h )
set(h,'Units','Inches');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
print(h,h.Name,'-dpdf','-r0')
end

