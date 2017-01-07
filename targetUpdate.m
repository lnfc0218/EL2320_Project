function [targetSize,targetHist]=targetUpdate(frame,state_mean,targetSize,targetHist)
h=targetSize(1);
w=targetSize(2);
% target=zeros(size(state_mean));
% redistriFlag=0;
alpha=0.2;

scale=max(0.1,state_mean(5));
width=round(scale*w);
height=round(scale*h);
targetSize=[height,width];

xStart=max(round(state_mean(1)-width/2),1);
xEnd=min(xStart+width-1,size(frame,2));
yStart=max(round(state_mean(2)-height/2),1);
yEnd=min(yStart+height-1,size(frame,1));

meanStateHist=rgbhist(frame(yStart:yEnd,xStart:xEnd,:),8,1);
Bcoeff=compareHists(targetHist,meanStateHist);% ÓÃÀ´»­Í¼
meanConfidence=exp(20*(Bcoeff-1));

% if meanConfidence>.1    
%     targetHist=(1-alpha)*targetHist+alpha*meanStateHist;
%     targetHist=targetHist./sum(targetHist);
% end

% »­Í¼
if meanConfidence>.1
    rectangle('Position',[xStart yStart w h],'EdgeColor','g')
elseif meanConfidence>.025
    rectangle('Position',[xStart yStart w h],'EdgeColor','y')
else
    rectangle('Position',[xStart yStart w h],'EdgeColor','r')
end

end