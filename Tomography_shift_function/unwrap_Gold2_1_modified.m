%phase=double(phase);

%phase=single(phase);
phasefilename = ['D:\abcd1'];
fid=fopen(phasefilename,'wb');
fwrite(fid,phase,'float32');
fclose(fid);

[m,n]=size(phase);

unwrappedfilename = ['D:\abcd3'];
eval(['!unphs6 -input ', phasefilename, ' -output ', ...
    unwrappedfilename, ' -format float -xsize ',num2str(m),' -ysize ', num2str(n)]) ;
fid = fopen(unwrappedfilename, 'rb');
unphase=fread(fid, [m, n],'float32', 'l');
fclose(fid);
u1=unphase;