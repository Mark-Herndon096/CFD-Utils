function [xi, eta, zeta, xjac] = compute_metrics(x,y,z)

ni = size(x,1);
nj = size(x,2);
nk = size(x,3);

xi   = zeros(ni,nj,nk,3);
eta  = zeros(ni,nj,nk,3);
zeta = zeros(ni,nj,nk,3);

xmet = zeros(ni,nj,nk,3);
ymet = zeros(ni,nj,nk,3);
zmet = zeros(ni,nj,nk,3);

% Derivatives of x in xi, eta, and zeta
[xmet(:,:,:,1)] = deriv(x,1);
[xmet(:,:,:,2)] = deriv(x,2);
[xmet(:,:,:,3)] = deriv(x,3);
% Derivatives of y in xi, eta, and zeta
[ymet(:,:,:,1)] = deriv(y,1);
[ymet(:,:,:,2)] = deriv(y,2);
[ymet(:,:,:,3)] = deriv(y,3);
% Derivatives of z in xi, eta, and zeta
[zmet(:,:,:,1)] = deriv(z,1);
[zmet(:,:,:,2)] = deriv(z,2);
[zmet(:,:,:,3)] = deriv(z,3);


xi(:,:,:,1)   = ymet(:,:,:,2).*zmet(:,:,:,3) - zmet(:,:,:,2).*ymet(:,:,:,3);
xi(:,:,:,2)   = zmet(:,:,:,2).*xmet(:,:,:,3) - xmet(:,:,:,2).*zmet(:,:,:,3);
xi(:,:,:,3)   = xmet(:,:,:,2).*ymet(:,:,:,3) - ymet(:,:,:,2).*xmet(:,:,:,3);
eta(:,:,:,1)  = ymet(:,:,:,3).*zmet(:,:,:,1) - zmet(:,:,:,3).*ymet(:,:,:,1);
eta(:,:,:,2)  = zmet(:,:,:,3).*xmet(:,:,:,1) - xmet(:,:,:,3).*zmet(:,:,:,1);
eta(:,:,:,3)  = xmet(:,:,:,3).*ymet(:,:,:,1) - ymet(:,:,:,3).*xmet(:,:,:,1);
zeta(:,:,:,1) = ymet(:,:,:,1).*zmet(:,:,:,2) - zmet(:,:,:,1).*ymet(:,:,:,2);
zeta(:,:,:,2) = zmet(:,:,:,1).*xmet(:,:,:,2) - xmet(:,:,:,1).*zmet(:,:,:,2);
zeta(:,:,:,3) = xmet(:,:,:,1).*ymet(:,:,:,2) - ymet(:,:,:,1).*xmet(:,:,:,2);
xjac(:,:,:)   = xmet(:,:,:,1).*xi(:,:,:,1)   + ymet(:,:,:,1).*xi(:,:,:,2) ...
                                             + zmet(:,:,:,1).*xi(:,:,:,3);
xi(:,:,:,1)   = xi(:,:,:,1)  ./ xjac(:,:,:); 
xi(:,:,:,2)   = xi(:,:,:,2)  ./ xjac(:,:,:); 
xi(:,:,:,3)   = xi(:,:,:,3)  ./ xjac(:,:,:); 
eta(:,:,:,1)  = eta(:,:,:,1) ./ xjac(:,:,:); 
eta(:,:,:,2)  = eta(:,:,:,2) ./ xjac(:,:,:); 
eta(:,:,:,3)  = eta(:,:,:,3) ./ xjac(:,:,:); 
zeta(:,:,:,1) = zeta(:,:,:,1)./ xjac(:,:,:); 
zeta(:,:,:,2) = zeta(:,:,:,2)./ xjac(:,:,:); 
zeta(:,:,:,3) = zeta(:,:,:,3)./ xjac(:,:,:); 
