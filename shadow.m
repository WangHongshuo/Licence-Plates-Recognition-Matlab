%H为水平投影，V为垂直投影
function [H,V] = shadow(im1)
im2=im1.'; %图像行列转置
H=sum(im2); %水平投影后的数组
%垂直投影
V=sum(im1); %垂直投影后 的数组
end