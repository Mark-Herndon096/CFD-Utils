function write_grid_file(x,y,z,dims,fname)

ng = 1;
fid = fopen(fname,'wb','ieee-le');
fwrite(fid,ng,'int');
fwrite(fid,dims,'int');
fwrite(fid,x,'single');
fwrite(fid,y,'single');
fwrite(fid,z,'single');
fclose(fid);
