% Showing the results (positon of the interface) of example 5
% TO 120927

load name            % get basename of this model
load(basename);      % load data for this model (generated in mf_adapt)

%%
H  =readDat([basename,'.HDS']);  % use only H.totim
ZTA=readBud([basename,'.ZTA']);  % get interface positions

[~,~,~,~,ISSTRAT]=getExcelData(basename,'MFLOW','vertical','ISTRAT');

%%
time = [H.totim]; NT = length(time);

%% Figure of rotating interface

figure;

if gr.Ny==1,
    ylim = [gr.zGr(end) gr.zGr(1)+5];
else
    ylim = gr.yc([end 1]);
end
    
set(gca,'nextplot','add','xgrid','on','ygrid','on','xlim',gr.xGr([1 end]),'ylim',ylim);
xlabel('x [m]'); ylabel('z [m]'); grid on;

%view(3);
set(gca,'cameraposition',[3875 -4150 200]);

%% plot all interface positions

vidObj = VideoWriter(basename);
vidObj.FrameRate = 10;
vidObj.Quality   = 80;
vidObj.open();

Nsurf = numel(ZTA(1).label);

h(gr.Nlay,Nsurf) = NaN;

tts1 = sprintf('%s, SWI ex4, well near coast. ISSRTAT=%d, NPLN=%d, T = %%.0f d',...
    basename,ISSTRAT,Nsurf);

for it=1:NT          % for all recoreds in bud file (and H-file)
    
    tts = sprintf(tts1,time(it));
    
    for iSurf=1:Nsurf  % we only have one layer in this case
        for iLay = 1:gr.Nlay
            if it==1
                ht = title(tts);
                if gr.Ny==1
                    h(iSurf,iLay) = plot(gr.xm,XS(ZTA(it).term{iSurf}(:,:,iLay)));
                else
                    h(iSurf,iLay) = surf(gr.xm,gr.ym,ZTA(it).term{iSurf}(:,:,iLay),'facealpha',0.3);
                end
            else
                set(ht     , 'string', tts);
                if gr.Ny==1
                    set(h(iSurf,iLay), 'ydata' , XS(ZTA(it).term{iSurf}(:,:,iLay)));
                else
                    set(h(iSurf,iLay), 'zdata' , ZTA(it).term{iSurf}(:,:,iLay));
                end
            end
        end
    end
    vidObj.writeVideo(getframe(gcf));
end
vidObj.close();
