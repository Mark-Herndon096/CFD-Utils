% Take derivative in direction of opdir
% opdir = 1 --> i-direction
% opdir = 2 --> j-direction
% opdir = 3 --> k-direction
function [dx] = deriv(x,opdir)
dx = zeros(size(x,1),size(x,2),size(x,3));
if opdir == 1
	dx(1,:,:)       = (x(2,:,:) - x(1,:,:));
	dx(2:end-1,:,:) = 0.5*(x(3:end,:,:) - x(1:end-2,:,:));
	dx(end,:,:)     = (x(end,:,:) - x(end-1,:,:));
elseif opdir == 2
	dx(:,1,:)       = (x(:,2,:) - x(:,1,:));
	dx(:,2:end-1,:) = 0.5*(x(:,3:end,:) - x(:,1:end-2,:));
	dx(:,end,:)     = (x(:,end,:) - x(:,end-1,:));
elseif opdir == 3
    if size(x,3) == 3
		dx(:,:,1)   = (x(:,:,2) - x(:,:,1));
		dx(:,:,2)   = 0.5*(x(:,:,end) - x(:,:,1));
		dx(:,:,end) = (x(:,:,end) - x(:,:,end-1));
        return;
    end
	dx(:,:,1)       = (x(:,:,2) - x(:,:,1));
	dx(:,:,2:end-1) = 0.5*(x(:,:,3:end) - x(:,:,1:end-2));
	dx(:,:,end)     = (x(:,:,end) - x(:,:,end-1));
end


