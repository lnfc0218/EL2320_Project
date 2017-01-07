function [STATE,L]=redistriParticles(sz,num_particles)
lbound=[0;0;-.5;-.5;1];
ubound=[sz(2);sz(1);.5;.5;2];
L=ones(1,num_particles)/num_particles;
STATE=bsxfun(@times,rand(5,num_particles),ubound-lbound);
STATE=bsxfun(@plus,STATE,lbound);
end
