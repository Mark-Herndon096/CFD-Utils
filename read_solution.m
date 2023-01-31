function [data, q] = read_solution(fname)

fid = fopen(fname,'r','ieee-le');
ng = fread(fid,1,'int');
dims = fread(fid,3,'int');

mach = fread(fid,1,'single');
aoa  = fread(fid,1,'single');
reyn = fread(fid,1,'single');
tau  = fread(fid,1,'single');

datalength = prod(dims)*ng*5;

q = zeros(datalength,1);

q = fread(fid,datalength,'single');

q  = reshape(q, [dims(1),dims(2), dims(3),5]);
data = [mach; aoa; reyn; tau];
fclose(fid);
