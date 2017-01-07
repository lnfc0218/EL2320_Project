% Initialization
clear; close all;
fig=figure;
axis('image')
global key
key='';
mkdir('image')
drawParticlesFlag=1;
% vr = VideoReader('Person.wmv');
vr = VideoReader('chase.mp4');
state_init=[];
dt=1;
A=[1 0 dt 0 0;
   0 1 0 dt 0;
   0 0 1 0 0;
   0 0 0 1 0;
   0 0 0 0 1];
std_dev=[2;2;.5;.5;.1];
num_particles=100;
roi=[];

disp('-p: pause current frame and select a rectangular ROI ')
disp('-c: cancel tracking ')
disp('-d: draw particles ')
% Object Tracking by Particle Filter
ii=1;
while hasFrame(vr)
    frame=readFrame(vr);
    if isempty(roi)
        imshow(frame)
    else
        frameROI=frame;
        frameROI(1:size(roi,1),1:size(roi,2),:)=roi;
        imshow(frameROI)
    end
    set(gca,'dataAspectRatio',[1 1 1])
%     drawnow
fig.KeyPressFcn=@checkKey;
    if key=='c'
        disp('Tracking cancelled')
        break
    elseif key=='d'
        key='';
        drawParticlesFlag=~drawParticlesFlag;
    elseif key=='p'    % press 'p' to pause and specify a rectangular ROI
        key='';
        disp('pause to select state: ')
        rect=getrect;% SELECT
        rect=round(rect);
        rectangle('Position',rect,'EdgeColor','k') 
        state_init=[rect(1)+.5*rect(3);rect(2)+.5*rect(4);0;0;1];
        roi=frame(rect(2)+(0:rect(4)-1),rect(1)+(0:rect(3)-1),:);
        [STATE,confidence]=initParticles(state_init,std_dev,num_particles);
        targetSize=[rect(4),rect(3)];
        targetHist=rgbhist(roi,8,1);
    else
        if isempty(roi)
            continue
        end
        [L,STATE]=observeParticles(frame,targetSize,targetHist,STATE,drawParticlesFlag);
        [state_mean,~,STATE]=estimateParticles(A,std_dev,L,STATE);        
        if (state_mean(1)<0)||(state_mean(1)>vr.Width)||(state_mean(2)<0)||(state_mean(2)>vr.Height)
            [STATE,L]=redistriParticles(size(frame),num_particles);
            disp('redistribute particles to recover')
        end
        [targetSize,targetHist]=targetUpdate(frame,state_mean,targetSize,targetHist);        
    end
    drawnow
    path=['./image/im',sprintf('%03d',ii),'.png'];
    saveas(fig,path);
    ii=ii+1
    targetSize
end


