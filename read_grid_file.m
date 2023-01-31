%% Function to read PLOT3D grid file with or without iblank
function [x,y,z,iblank,dims] = read_grid_file(fname)
fid = fopen(fname,'r','ieee-le');
 %TEST FOR FORM, TYPE, AND IBLANK ARRAY
fseek(fid, 0, 'eof');
fsize = ftell(fid);
frewind(fid);
status = 0;
while status == 0
    % Test values for 'STREAM' (No records)
    ng = fread(fid,1,'int');
    dims = zeros(3,ng);
    for n = 1:ng
        dims(1,n) = fread(fid,1,'int');
        dims(2,n) = fread(fid,1,'int');
        dims(3,n) = fread(fid,1,'int');
    end
    frewind(fid);
    nelms   = sum(prod(dims));
    nrecs   = 0;
    ibytes  = 4*(nrecs + 1 + ng*3);
    dbytes  = 8*(nelms*3);
    ibbytes = 4*(nelms);
    % Size of file in bytes for different scenarios
    dt1 = ibytes + dbytes;             % 'STREAM', double, no iblank
    dt2 = ibytes + dbytes + ibbytes;   % 'STREAM', double, with iblank
    dt3 = ibytes + dbytes/2;           % 'STREAM', single, no iblank
    dt4 = ibytes + dbytes/2 + ibbytes; % 'STREAM', single, with iblank
    
    if fsize == dt1
	    form   = 'STREAM';
	    typ    = 'double';
	    ib     = 0;
	    status = 1;
    elseif fsize == dt2
	    form   = 'STREAM';
	    typ    = 'double';
	    ib     = 1;
	    status = 1;
    elseif fsize == dt3
	    form   = 'STREAM';
	    typ    = 'single';
	    ib     = 0;
	    status = 1;
    elseif fsize == dt4
	    form   = 'STREAM';
	    typ    = 'single';
	    ib     = 1;
	    status = 1;
    else
	    status = 0;
    end
    if status == 1
        break;
    end
    % Test values for 'UNFORMATTED'
    rec1 = fread(fid,1,'int');
    ngu = fread(fid,1,'int');
    rec1 = fread(fid,1,'int');
    rec2 = fread(fid,1,'int');
    dimsu = zeros(3,ng);
    for n = 1:ngu
        dimsu(1,n) = fread(fid,1,'int');
        dimsu(2,n) = fread(fid,1,'int');
        dimsu(3,n) = fread(fid,1,'int');
    end
    rec2 = fread(fid,1,'int');
    frewind(fid);
    
    nelms   = sum(prod(dimsu));
    nrecs   = 4 + ngu*2;
    ibytes  = 4*(nrecs + 1 + ngu*3);
    dbytes  = 8*(nelms*3);
    ibbytes = 4*(nelms);
    
    % Size of file in bytes for different scenarios
    dt1 = ibytes + dbytes;             % Unformatted, double, no iblank
    dt2 = ibytes + dbytes + ibbytes;   % Unformatted, double, with iblank
    dt3 = ibytes + dbytes/2;           % Unformatted, single, no iblank
    dt4 = ibytes + dbytes/2 + ibbytes; % Unformatted, single, with iblank
    if fsize == dt1
	    form   = 'UNFORMATTED';
	    typ    = 'double';
	    ib     = 0;
	    status = 1;
    elseif fsize == dt2
	    form   = 'UNFORMATTED';
	    typ    = 'double';
	    ib     = 1;
	    status = 1;
    elseif fsize == dt3
	    form   = 'UNFORMATTED';
	    typ    = 'single';
	    ib     = 0;
	    status = 1;
    elseif fsize == dt4
	    form   = 'UNFORMATTED';
	    typ    = 'single';
	    ib     = 1;
	    status = 1;
    else
	    status = 0;
    end
end

%%

%% BLOCK TO READ UNFORMATTED SINGLE/DOUBLE FORTRAN PLOT3D GRID
%  WITHOUT IBLANKS
if strcmp(form,'UNFORMATTED')
    rec = fread(fid,1,'int');
    ng  = fread(fid,1,'int');
    rec = fread(fid,1,'int');
    rec = fread(fid,1,'int');
    dims = zeros(3,ng);
    for n = 1:ng
        dims(1,n) = fread(fid,1,'int');
        dims(2,n) = fread(fid,1,'int');
        dims(3,n) = fread(fid,1,'int');
    end
    rec = fread(fid,1,'int');
    
    
    imax = max(dims(1,:));
    jmax = max(dims(2,:));
    kmax = max(dims(3,:));
    
    x = zeros(imax,jmax,kmax,ng);
    y = zeros(imax,jmax,kmax,ng);
    z = zeros(imax,jmax,kmax,ng);
	iblank = ones(imax,jmax,kmax,ng);
    
    for n = 1:ng
        bytes = fread(fid,1,'int');
        for k = 1:dims(3,n)
            for j = 1:dims(2,n)
                x(1:dims(1,n),j,k,n) = fread(fid,dims(1,n),typ);
            end
        end
        for k = 1:dims(3,n)
            for j = 1:dims(2,n)
                	y(1:dims(1,n),j,k,n) = fread(fid,dims(1,n),typ);
            end
        end
        for k = 1:dims(3,n)
            for j = 1:dims(2,n)
                	z(1:dims(1,n),j,k,n) = fread(fid,dims(1,n),typ);
            end
        end
		if ib == 1
        	for k = 1:dims(3,n)
        	    for j = 1:dims(2,n)
        	        	iblank(1:dims(1,n),j,k,n) = fread(fid,dims(1,n),'int');
        	    end
        	end
		end
        rec = fread(fid,1,'int');
    end
    fclose(fid);
end


%% BLOCK TO READ UNFORMATTED SINGLE/DOUBLE FORTRAN PLOT3D GRID
if strcmp(form,'STREAM')   
    ng  = fread(fid,1,'int');
    dims = zeros(3,ng);
    for n = 1:ng
        dims(1,n) = fread(fid,1,'int');
        dims(2,n) = fread(fid,1,'int');
        dims(3,n) = fread(fid,1,'int');
    end

    imax = max(dims(1,:));
    jmax = max(dims(2,:));
    kmax = max(dims(3,:));
    
    x = zeros(imax,jmax,kmax,ng);
    y = zeros(imax,jmax,kmax,ng);
    z = zeros(imax,jmax,kmax,ng);
	iblank = ones(imax,jmax,kmax,ng);

    for n = 1:ng
        for k = 1:dims(3,n)
            for j = 1:dims(2,n)
                x(:,j,k,n) = fread(fid,dims(1,n),typ);
            end
        end
        for k = 1:dims(3,n)
            for j = 1:dims(2,n)
                y(:,j,k,n) = fread(fid,dims(1,n),typ);
            end
        end
        for k = 1:dims(3,n)
            for j = 1:dims(2,n)
                z(:,j,k,n) = fread(fid,dims(1,n),typ);
            end
        end
		if ib == 1
        	for k = 1:dims(3,n)
        	    for j = 1:dims(2,n)
        	        	iblank(1:dims(1,n),j,k,n) = fread(fid,dims(1,n),'int');
        	    end
        	end
		end
    end
    fclose(fid);
end
  


