%% Function to cross sectional region per k-plane
%% Inputs:
%     q  -> solution vector q
%     is -> starting i indices
%     ie -> ending i indices
%     js -> starting i indices
%     je -> ending j indices
% Outputs:
%     u, v, w -> velocity components within defined region
function [u,v,w,zr] = create_region(q,z,is,ie,js,je)

dims = size(q);

u = q(is:ie,js:je,:,2)./q(is:ie,js:je,:,1);
v = q(is:ie,js:je,:,3)./q(is:ie,js:je,:,1);
w = q(is:ie,js:je,:,4)./q(is:ie,js:je,:,1);

zr = z(is:ie,js:je,:);

u = reshape(u, [ie-is+1, je-js+1, dims(3)]);
v = reshape(v, [ie-is+1, je-js+1, dims(3)]);
w = reshape(w, [ie-is+1, je-js+1, dims(3)]);

