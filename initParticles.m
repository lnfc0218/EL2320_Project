function [STATE,confidence]=initParticles(state_init,std_dev,num_particles)
confidence=1/num_particles*ones(1,num_particles);% PROPAGATE
STATE=randn(5,num_particles);
STATE=bsxfun(@times,STATE,std_dev);
STATE=bsxfun(@plus,STATE,state_init);
% for i=1:length(std_dev)
%     STATE(i,:)=state_init(i)+std_dev(i)*randn(1,num_particles);
% end
end
