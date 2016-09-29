function [output] = size300(I)
[x,y] = size(I);
k = x/y;
x = round(k*300);
output = imresize(I,[x,300],'bicubic');
end