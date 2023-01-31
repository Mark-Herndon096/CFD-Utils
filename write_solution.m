function write_solution(data,q,dims,fname)

fid = fopen(fname,'wb','ieee-le');
ng = 1;
fwrite(fid,ng,'int');
fwrite(fid,dims,'int');
fwrite(fid,data,'single');
fwrite(fid,q,'single');
fclose(fid);
