% Hough变换
function  [output,angle] = rotate2(Gray)
Len = zeros(1,8);
% BW = im2bw(Gray,graythresh(Gray));
% BW = double(bw);
BW = edge(Gray,'canny');
% figure(1),imshow(BW);title('边界图像');
[H,T,R] = hough(BW);
% figure(2),imshow(H,[],'XData',T,'YData',R,'InitialMagnification','fit');
% xlabel('\theta'),ylabel('r');
% axis on, axis normal,hold on;
P = houghpeaks(H,4,'threshold',ceil(0.3*max(H(:))));
% x = T(P(:,2));
% y = R(P(:,1));
% plot(x,y,'s','color','w');
lines = houghlines(BW,T,R,P,'FillGap',50,'MinLength',7);
% figure(3),imshow(BW),title('直线标定');
max_len = 0;
% hold on;
for k=1:length(lines)
    xy = [lines(k).point1;lines(k).point2];
    % 标出线段
%     plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','g');
    % 标出线段的起始和终端点
%     plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','r');
%     plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','r');
    len = norm(lines(k).point1-lines(k).point2);
    Len(k) = len;
    if (len>max_len)
        max_len=  len;
%         xy_long = xy;
    end
end
% 强调最长的部分
% plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','b');
[~, Index1] = max(Len(:));
% 最长线段的起始和终止点
% x1 = [lines(Index1).point1(1) lines(Index1).point2(1)];
% y1 = [lines(Index1).point1(2) lines(Index1).point2(2)];
% 求得线段的斜率
K1 = -(lines(Index1).point1(2)-lines(Index1).point2(2))/...
    (lines(Index1).point1(1)-lines(Index1).point2(1));
angle = -atan(K1)*180/pi;
%若计算出非数，则倾斜角为0
if (isnan(angle) == 1)
    angle = 0;
end
% imrotate是逆时针的所以取一个负号
output = imrotate(Gray,angle,'bicubic');
% figure(4),imshow(output);
B = im2bw(output);
[H,V] = shadow(B);
H1 = find(H, 2,'first');
H2 = find(H, 2,'last');
W1 = find(V, 2,'first');
W2 = find(V, 2,'last');
output = output(H1:H2,W1:W2);
% figure(),imshow(output);
end
