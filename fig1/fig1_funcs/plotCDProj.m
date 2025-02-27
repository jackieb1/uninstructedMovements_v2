function plotCDProj(allrez,rez,sav,plotmiss,plotaw,alignEvent)

clrs = getColors();
lw = 3.5;
alph = 0.1;

sample = mode(rez(1).ev.sample - rez(1).align);
delay = mode(rez(1).ev.delay - rez(1).align);


for i = 1:numel(allrez.cd_labels) % for each coding direction


    f = figure; hold on
%     f.Position = [680   748   396   230];
    ax = gca;
    %     ax = nexttile; hold on;
    tempdat = squeeze(allrez.cd_proj(:,:,i,:));
    tempmean = nanmean(tempdat,3);
    temperror = nanstd(tempdat,[],3)./sqrt(numel(rez));
    shadedErrorBar(rez(1).time,tempmean(:,1),temperror(:,1),{'Color',clrs.rhit,'LineWidth',lw},alph, ax)
    shadedErrorBar(rez(1).time,tempmean(:,2),temperror(:,2),{'Color',clrs.lhit,'LineWidth',lw},alph, ax)
    if plotmiss
        shadedErrorBar(rez(1).time,tempmean(:,3),temperror(:,3),{'Color',clrs.rhit*0.5,'LineWidth',lw},alph, ax)
        shadedErrorBar(rez(1).time,tempmean(:,4),temperror(:,4),{'Color',clrs.lhit*0.5,'LineWidth',lw},alph, ax)
    end
    if plotaw
        shadedErrorBar(rez(1).time,tempmean(:,5),temperror(:,5),{'Color',clrs.rhit_aw,'LineWidth',lw},alph, ax)
        shadedErrorBar(rez(1).time,tempmean(:,6),temperror(:,6),{'Color',clrs.lhit_aw,'LineWidth',lw},alph, ax)
    end

%     xlim([rez(1).time(1);rez(1).time(end)])
    xlim([rez(1).time(5);2])

    title(allrez.cd_labels{i})
    xlabel(['Time (s) from ' alignEvent])
    ylabel('Activity (a.u.)')
    ax.FontSize = 12;

    xline(sample,'k:','LineWidth',2)
    xline(delay,'k:','LineWidth',2)
    xline(0,'k:','LineWidth',2)

    curmodename = allrez.cd_labels{i};
    shadetimes = rez(1).time(allrez.cd_times.(curmodename));
    x = [shadetimes(1)  shadetimes(end) shadetimes(end) shadetimes(1)];
    y = [ax.YLim(1) ax.YLim(1) ax.YLim(2) ax.YLim(2)];
    %     y = [-60 -60 50 50];
    fl = fill(x,y,'r','FaceColor',[93, 121, 148]./255);
    fl.FaceAlpha = 0.3;
    fl.EdgeColor = 'none';
    ylim([y(1) y(3)]);

    if sav
        pth = 'C:\Users\munib\Documents\Economo-Lab\code\uninstructedMovements\fig1_v2\figs\cd1';
        fn = ['cd_' lower(fns{i}(3:end-7))];
        mysavefig(f,pth,fn,1);
        %         exportfig(f, fullfile(pth,fn),'Format','eps','Color','rgb')
    end

    hold off

end


end