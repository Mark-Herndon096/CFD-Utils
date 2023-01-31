%% Function to remove overlap in periodic direction ( k-only )
function [qr,zr] = remove_overlap(q,z)
qr = q(:,:,3:end-2,:);
zr = z(:,:,3:end-2);
