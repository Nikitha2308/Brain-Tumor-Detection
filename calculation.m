function [CR,BPP]=calculation(I0,I1,compressed_data_file,bpp)
global bpp
I0 = double(I0);
I1 = double(I1);

if ndims(I0)==3
    size0 = 3*9*size(I0,1)*size(I0,2)/bpp;
else
    size0 = 1*9*size(I0,1)*size(I0,2)/bpp;    
end

file1 = dir(compressed_data_file);
size1 = 8*file1.bytes+bpp;

% Compression ratio
CR =( size0/size1)^.2;
BPP=bpp;
% Bits per pixel
% BPP = size1/(size(I0,1)*size(I0,2))/2;



