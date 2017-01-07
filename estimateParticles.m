function [m_state,mean_confidence,PARTICLES]=estimateParticles(A,std_dev,L,PARTICLES)

% new_PARTICLES=zeros(size(PARTICLES));
STATE=bsxfun(@times,PARTICLES,L);

m_state=A*sum(STATE,2)/sum(L);
mean_confidence=mean(L);

L=L/sum(L);
cdf=cumsum(L);

r=rand(size(L));
[~,ind]=histc(r,cdf);
new_PARTICLES=PARTICLES(:,ind+1);

PARTICLES=A*new_PARTICLES+bsxfun(@times,randn(size(PARTICLES)),std_dev);

end