function [omega] = compute_vorticity(u,v,xi,eta)

%% Computes z-vorticity

uxi = deriv(u,1);
vxi = deriv(v,1);
uet = deriv(u,2);
vet = deriv(v,2);

omega = zeros(size(u,1),size(u,2),size(u,3));

omega(:,:,:) =  xi(:,:,:,1).*vxi(:,:,:) + eta(:,:,:,1).*vet(:,:,:) - ...
			   (xi(:,:,:,2).*uxi(:,:,:) + eta(:,:,:,2).*uet(:,:,:));

