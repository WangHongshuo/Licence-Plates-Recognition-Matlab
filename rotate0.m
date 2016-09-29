% Radon变换
% Gray为尺寸变换后的输入图像
% output为旋转裁剪后的输出图像
function [output,angle] = rotate0(Gray)
BW = edge(Gray,'canny');
% figure,imshow(BW);
theta = 0:180;
[R,~] = radon(BW,theta);
%J为倾斜角
[~,J] = find(R >= max(max(R)));
%若计算出非数，则倾斜角为0
if (isnan(J) == 1)
    J = 0;
end
angle = 90 - J;
output = imrotate(Gray,angle,'bicubic','crop');
B = im2bw(output);
% figure,imshow(output);
[H,V] = shadow(B);
H1 = find(H, 2,'first');
H2 = find(H, 2,'last');
W1 = find(V, 2,'first');
W2 = find(V, 2,'last');
output = output(H1:H2,W1:W2);
% figure,imshow(output);
end
