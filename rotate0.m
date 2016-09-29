% Radon�任
% GrayΪ�ߴ�任�������ͼ��
% outputΪ��ת�ü�������ͼ��
function [output,angle] = rotate0(Gray)
BW = edge(Gray,'canny');
% figure,imshow(BW);
theta = 0:180;
[R,~] = radon(BW,theta);
%JΪ��б��
[~,J] = find(R >= max(max(R)));
%�����������������б��Ϊ0
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
