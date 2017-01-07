% function L=observeParticles(frame,roi,STATE)
function [L,STATE]=observeParticles(frame,targetSize,targetHist,STATE,drawParticlesFlag)
% OBSERVE
% kernel(); 
% [h,w,~]=size(roi);
h=targetSize(1);
w=targetSize(2);
[Width,Height,~]=size(frame);
L=zeros(1,size(STATE,2));
% targetHist=rgbhist(roi,8,1);
hold on

for i=1:size(STATE,2)
    Sn=STATE(:,i);
    x=Sn(1);
    y=Sn(2);
    scale=max(0.1,Sn(5));
    STATE(5,i)=scale;
    scaleH=min(round(scale*h),Height);
    yStart=max(ceil(y-.5*scaleH),1);
    yEnd=min(yStart+scaleH-1,Width);
    scaleW=min(round(scale*w),Height);
    xStart=max(ceil(x-.5*scaleW),1);
    xEnd=min(xStart+scaleW-1,Height);
    SnHist=rgbhist(frame(yStart:yEnd,xStart:xEnd,:),8,1);
    Bcoeff=compareHists(targetHist,SnHist);
    if Bcoeff==0
        L(i)=0;
    else
        L(i)=exp(20*(Bcoeff-1));
        if drawParticlesFlag
        rectangle('Position',[xStart yStart scaleW scaleH],'EdgeColor','b') 
        end
    end
end
hold off
end



