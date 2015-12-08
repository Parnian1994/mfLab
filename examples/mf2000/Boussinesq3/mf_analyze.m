%% Analyzing output of the model
% TO 100415 100916
 
load('name.mat') % loads name.mat, which only contains the variable "basename"
load(basename);  % having retrieved the baasename value, we can load
load underneath

%% load the unformatted head file
H=readDat([basename,'','.hds']);  % use readDAT to read the heads  output file
%H=maskHC(H,1000);                 % throws out HNOFLO and HDRY and inactive cells

iy = hit(gr.yGr,2500);

%% Plot bottom of aquifer and start heads
figure; hold on
xlabel('x [m]'); ylabel('elevation [m]'); grid on;
title('Aquifer bottom and head elevation on hill slope');

plot(gr.xm,gr.Z(iy,:,end),'color','k','linewidth',3); % plot bottom of aquifer thick
plot(gr.xm,STRTHD(iy,:,end),'r');                  % plot start heads in read

tts = sprintf('Boussinesq: k=%.1f m/d, Sy=%.1f, slope=1/%.0f, rch=%.3f m/d, t=%%.0f d',k,Sy,-1/slope,rch);
%% Plot heads at various times as head snapshots in gread

vidObj = VideoWriter(basename);
vidObj.FrameRate= 5;
vidObj.open();

for it=1:length(H)
    if it==1
       ht = title(sprintf(tts,H(it).time));
    else
        if it<=50, clr='g'; else clr='m'; end
        for iL=1:size(H(1).values,3)
            plot(gr.xm,H(it).values(iy,:,iL),clr);
        end
        set(ht,'string',sprintf(tts,H(it).time));
    end
    vidObj.writeVideo(getframe(gcf));
end
plot(gr.xm,H(end).values(iy,:,iL),'r');


%%
delete(gca);

hold on;
xlabel('x [m]'); ylabel('y [m]'); title('head (final) above base of sloping water table aquifer');
[~,hc] = contour(gr.xm,gr.ym,H(end).values-gr.ZBlay,1:40);
colorbar;

for it=1:length(H)
    if it==1
       ht = title(sprintf(tts,H(it).time));
    else
       set(ht,'string',sprintf(tts,H(it).time));
       set(hc,'zData',H(it).values-gr.ZBlay);
    end
    vidObj.writeVideo(getframe(gcf));
end

vidObj.close();

%% Read unformatted budget file and mask noflow cells if they exist

B=readBud([basename,'','.bgt']);
zonebudget(B)
