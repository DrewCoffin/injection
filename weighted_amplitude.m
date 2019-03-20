clear all
close all
clf;

species1='sp';
species2='s3p';
param='DENS';
%testFolder='neutral+fehAmplify';
testCase='1';
folder1 = dir(strcat('/home/dcoffin/2D_Model-master/plots/data/',species1,'/',param,'/*_3D.dat'));
folder2 = dir(strcat('/home/dcoffin/2D_Model-master/plots/data/',species2,'/',param,'/*_3D.dat')); 
peak=0.2;

lng=12;
rad=12;

len=length(folder1);

for day = 1:len
    days(day)=day-1;
    data1=load(folder1(day).name);
    data2=load(folder2(day).name);
    for ring=1:rad
       ringStart=(lng+1)*(ring-1)+1;
       ringEnd=(lng+1)*ring;
%        for long=1:lng
%            intensity(long)=data1(ringStart-1+long,2)/TEMPsp(ringStart-1+long,2);      
%        end
%        amp(day,ring)=0.5*(max(intensity(:))-min(intensity(:)))/max(DENSsp(:,2)./TEMPsp(:,2)); 
       amp1(day,ring)=0.5*(max(data1(ringStart:ringEnd,2))-min(data1(ringStart:ringEnd,2)))/max(data1(:,2)); 
       amp2(day,ring)=0.5*(max(data2(ringStart:ringEnd,2))-min(data2(ringStart:ringEnd,2)))/max(data2(:,2)); 
    end
    GaussDens(day)=peak*exp(-((day-249.0)/30.0)^2);
    GaussElec(day)=peak*exp(-((day-279.0)/60.0)^2);
end

ampmax=max(max(max(amp1(:,:))), max(max(amp2(:,:))));
if (ampmax < peak && strcmp(param,'MIXR'))  ampmax=peak; end

figure(1)
set(gcf, 'visible', 'off');
plotnum=6;
for ring=1:plotnum
    hold all;
    radius(ring)=data1((ring-1)*(lng+1)+1,3);
    ax(ring)=subplot(plotnum,1,ring);
    height=(0.8/plotnum);
    bottom=0.92-(height*ring);
    set(ax(ring), 'pos', [0.125 bottom 0.85 height]);
%     if ring<=rad/2
%       ax(ring)=subplot(ceil(rad/2),2,(ring*2)-1);
%     end
%     if ring>rad/2
%         ax(ring)=subplot(ceil(rad/2),2,ring*2-floor(rad/2)*2);
%     end
    if (ring == 1 && strcmp(param,'MIXR'))
        plot(ax(ring),days(10:len-1),amp1(10:len-1,ring), '--', days(10:len-1), amp2(10:len-1,ring), days, GaussDens(:), days, GaussElec(:), 'linewidth', 1.15);
    else
        plot(ax(ring),days(10:len-1),amp1(10:len-1,ring), '--', days(10:len-1), amp2(10:len-1,ring), 'linewidth', 1.15);
    end
    if ring==plotnum
        legend('S^+', 'S^{+++}', 'Location', 'northwest', 'orientation', 'horizontal');
    end
    %hold on;
    %plot(ax(ring),days,ampMIXRs3p(:,ring), 'linewidth', 1.15);
    %title(ax(ring),strcat('Radius = ', num2str(radius(ring)) , ' Rj'));  
    xlim([0 len-1]);
    set(ax(ring), 'ylim', [0 1.0*ampmax]) %ceil(ampmax*10)/10]);
    set(ax(ring), 'xlim', [10 len-1]) 
    set(ax(ring), 'XTickLabel',{})
    set(ax(ring), 'XTick',10:50:len-1)
    set(ax(ring), 'yTick',0.05:0.05:1.3*ampmax)
    if ring==ceil(plotnum/2)
        if param=='MIXR'
            ylabel(ax(ring), 'Normalized Amplitude of Mixing Ratios', 'fontsize', 13, 'position', get(get(ax(ring),'ylabel'),'position')-[0 0.1 0])
        elseif param=='DENS'
            ylabel(ax(ring), 'Normalized Amplitude of Densities', 'fontsize', 13, 'position', get(get(ax(ring),'ylabel'),'position')-[0 0.1 0])
        elseif param=='TEMP'
            ylabel(ax(ring), 'Normalized Amplitude of Temperature', 'fontsize', 13, 'position', get(get(ax(ring),'ylabel'),'position')-[0 0.1 0])
        end
    end
    %ax2(ring) = axes;
    ax2(ring) = copyobj(ax(ring), figure(1));
    set(ax2(ring),'yaxislocation','right','ytick',[],'xtick',[], 'visible', 'off')
    ylabel(ax2(ring), strcat('R = ',num2str(radius(ring),'%3.1f'), ' R_J'), 'fontsize', 9, 'rotation', 0, 'position', get(get(ax2(ring),'ylabel'),'position')-[44 -0.04 0], 'visible', 'on')
    %set(ax(ring), 'xminortick', 'on')
    set(ax(ring), 'ygrid', 'on','fontsize', 9)
end
xlabel(ax(plotnum), 'Time in Days', 'fontsize', 14)
if param=='TEMP'
  title(ax(1), 'Temperature Amplitude Variations', 'fontsize', 16)
elseif param=='MIXR'
  title(ax(1), 'Mixing Ratios Amplitude Variations', 'fontsize', 16)
elseif param=='DENS'
  title(ax(1), 'Density Amplitude Variations', 'fontsize', 16)
end
set(ax(ring), 'XTickLabel',100:50:len-1)
%opfig(strcat('2D_Model-master/Eruption/weightedIndividual',param,testCase,'.pdf'), 4.0, 7.0, [0,1,0]);
filename1 = strcat('2D_Model-master/Eruption/weightedIndividual',param,testCase,'.pdf');
saveas(gcf,filename1)
    
figure(2)
set(gcf, 'visible', 'off');
%plot(275:320, sum(amp(275:320,1:rad), 2));
plot(days, mean(amp1(:,1:rad), 2), days, mean(amp2(:,1:rad), 2), 'linewidth', 1.25);
legend('S^+', 'S^{+++}', 'Location', 'northeast', 'orientation', 'horizontal');
set(gca, 'xlim', [275 330]) 
set(gca, 'xgrid', 'on');
set(gca, 'ygrid', 'on');
set(gca, 'XTick', 0:5:len-1)
if param=='MIXR'
  title('Mixing Ratio Amplitude Following Eruption', 'fontsize', 18);
  ylabel('Mixing Ratio Amplitude', 'fontsize', 12);
elseif param=='DENS'
  title('Density Amplitude Following Eruption', 'fontsize', 18);
  ylabel('Density Amplitude', 'fontsize', 12);
elseif param=='TEMP'
  title('Temperature Amplitude Following Eruption', 'fontsize', 18);
  ylabel('Temperature Amplitude', 'fontsize', 12);
end
xlabel('Time in Days', 'fontsize', 12);
%opfig(strcat('2D_Model-master/Eruption/weightedTotal',param,testCase,'.pdf'), 7.5, 4.5, [0,1,0]);
filename2 = strcat('2D_Model-master/Eruption/weightedTotal',param,testCase,'.pdf');
saveas(gcf,filename2)