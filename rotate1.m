%顶角检测变换
function [output,theta] = rotate1(Gray)
% figure,imshow(Gray);
% bw = im2bw(Gray, graythresh(Gray));
bw = edge(Gray, 'canny');
% figure,imshow(bw);
[r, c] = find(bw);
[rmin, indr] = min(r);
[cmin, indc] = min(c);
p1 = [rmin, c(indr)];
p2 = [r(indc) cmin];
% hold on;
% plot([p1(2) p2(2)], [p1(1) p2(1)],'w-o','LineWidth',3);
k = (p2(1)-p1(1))/(p2(2)-p1(2));
theta = atan(k)/pi*180;
%若计算出非数，则倾斜角为0
if (isnan(theta) == 1)
    theta = 0;
end
output = imrotate(Gray, theta, 'bicubic');
B = im2bw(output);
% figure,imshow(output);
[H,V] = shadow(B);
H1 = find(H, 2,'first');
H2 = find(H, 2,'last');
W1 = find(V, 1,'first');
W2 = find(V, 1,'last');
output = output(H1:H2,W1:W2);
 % figure,imshow(output);
end