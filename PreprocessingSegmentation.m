 tic;
clc;
clear all;
close all;
% input = imread('test\qx\30\test_5.jpg');
input = imread('test\test_4.jpg');
%灰度化
Gray = rgb2gray(input);
figure(1),subplot(2,3,1),imshow(Gray,[]);title('灰度化')
% 等比例缩放图片
Gray = size300(Gray);
%=======图像旋转矫正=================
%rotate0为radon变换,rotate1为顶角检测变换，rotate2为hough变换
% [Gray,angle] = rotate0(Gray);
% [Gray,angle]= rotate1(Gray);
% [Gray,angle] = rotate2(Gray);
% Gray = size300(Gray);
%=======图像旋转矫正=================
figure(1),subplot(2,3,2),imshow(Gray);
% title({'矫正和尺寸变换',;strcat('角度:',num2str(angle))});
title('尺寸变换');
%中值滤波.
Gray = double(medfilt2(Gray,[3 3]));
figure(1),subplot(2,3,3),imshow(Gray,[]);title('中值滤波')
% 取灰度值阀值
%=========================================
% T = graythresh(Gray);%另一种二值化方法
% B = im2bw(Gray,T);
%=========================================
Imax = max(max(Gray));
Imin = min(min(Gray));
T = round((Imax-(Imax-Imin)/2)*1.1);%1.1765
B = (Gray)>=T;
subplot(2,3,4),imshow(B);title('二值化')
% B1 = ~B;
% figure,imshow(B1);title('二值化取反')
%===========测试==========================
% B = imread('test.bmp');
%=========================================
%细化处理，近一步清除干扰
% B = bwmorph(B,'skel',1);
% subplot(2,3,4),imshow(B);title('细化处理')
% 先腐蚀,后除去面积较小的非文本区域
%字符二值化后笔画较细则膨胀一次
[m,n] = size(B);
B = bwareaopen(B,20);
k = sum(sum(B));
se = strel('square',2);
if (k < m*n*0.19)
    B = imdilate(B,se);
    subplot(2,3,5),imshow(B);title('字符较细，需要膨胀一次')
elseif (k > m*n*0.5)
    B = ~B;
    k = sum(sum(B));
    if (k < m*n*0.19)
        B = imdilate(B,se);
    end
    subplot(2,3,5),imshow(B);title('黄色车牌取反')
else
    subplot(2,3,5),imshow(B);title('字符不需要膨胀一次')
end
%去除面积较小的部分，汉字区域和其他区域参数不同;
%汉字区域
temp1 = B(1:m,1:round(n*0.3));
temp1 = bwareaopen(temp1,30);
%字母数字区域
temp2 = B(1:m,round(n*0.3)+1:n);
temp2 = bwareaopen(temp2,150);
B = [temp1,temp2];
clear temp1 temp2
subplot(2,3,6),imshow(B);title('去除面积较小部分')
% set( figure(3),'Color','blue')
figure(3),subplot(2,1,1),imshow(B);title('裁剪前原图');
% B = bwmorph(B, 'thin',Inf);title('细化');
[m,n] = size(B);
% 求垂直投影
[H,V] = shadow(B);
y=1:n;
figure(2),subplot(5,1,1),plot(y,V(y));title('垂直投影');
% 求水平投影
x=1:m;
subplot(5,1,2),plot(x,H(x));title('水平投影')
%水平剪裁
%上边界(向上判定)
for x=round(m*0.25):-1:2
    %判定条件
    if ((H(x) > round(n*0.14) && H(x-1) <= round(n*0.14)) || H(x) > round(n*0.75))%寻找0-x边界
        H1 = x;
        break
    elseif (x == 2)
        H1 = 1;
    end
end
%下边界(向下判定)
for x=round(m*0.7):m
    %判定条件
    if ((H(x) <= round(n*0.16) && H(x-1) > round(n*0.16)) || H(x) > round(n*0.75))%寻找x-0边界
        H2 = x-1;
        break
    elseif (x == m)%到图片极限宽度
        H2 = m;
    end
end
%进行一次裁剪
temp = B(H1:H2,1:n);
% 求垂直投影
[m,n] = size(temp);
[H,V] = shadow(temp);
x=1:m;
subplot(5,1,3),plot(x,H(x));title('水平裁剪后的水平投影');
y=1:n;
subplot(5,1,4),plot(y,V(y));title('水平裁剪后的垂直投影');
%垂直剪裁
W = zeros(1,14);
W(1) = 1;
%左侧边界
%占用W(1)W(2)W(3)暂存
a = 2;
for y=round(n*0.2):-1:1
    %判定条件
    if(a == 2 && (V(y) > 2 && V(y+1) <= 2))
        W(a) = y+1;
        a = a - 1;
    end
    if (a == 1 && V(y) <= 2  && V(y+1) > 2)
        W(a) = y;
        a = a - 1;
    end
    if (a == 0 && W(2) - W(1) >= n*0.1)
        break;
    end
    if (a == 0 && W(2) - W(1) < n*0.1)
        a = a+1;
    end
    if (y == 1 && a == 1);
        W(1) = 1;
    end
end

%右侧边界
for y=round(n*0.9):n-1
    %判定条件
    if(V(y) > 4 && V(y+1) <= 4)
        W(14) = y;
        break
    elseif (y == n-1)
        W(14) = n;
    end
end
%剪裁后的图片
temp = temp(1:m,W(1):W(14));
%调整剪裁后的图片大小
[m,n] = size(temp);
k = m/n;
x = round(k*300);
temp = imresize(temp,[x,300]);
[~,n] = size(temp);
%更新剪裁后的图像数据(垂直)
[~,V] = shadow(temp);
y=1:n;
subplot(5,1,5),plot(y,V(y));title('垂直裁剪后的垂直投影');

figure(3),subplot(2,1,2),imshow(temp);title('裁剪并重新调整后的图片');

[m,n] = size(temp);
%垂直方向分割字符（倒序分割）
W = zeros(1,14);
W(1) = 1;
W(14) = n;
g = 13;
wrong = 0;
for y=n-1:-1:1
    if ((V(y) <= 4  && V(y+1) > 4) || (V(y) > 4 && V(y+1) <= 4))%寻找0-x和x-0边界
        W(g) = y;
        if (mod(g,2) == 1)%修正分割左侧多出的黑边
            W(g) = W(g)+1;
        end
        g =g-1;
        %判定第三个字符分割是否受到点的影响
        if (g == 2 && W(4) - W (3) < n*0.09)
            g = g+2;
        end
        %判定第四到第七个字符分割是否正确
        if(g < 13 && g > 3 && mod(g,2) == 0 && W(g+2) - W(g+1) < n*0.02 );
            k = sum(sum(V(:,W(g+1):W(g+2))));
            if (k/m/(W(g+2) - W(g+1)) < 0.75)
                W(g+2) = 0;
                W(g+1) = 0;
                g = g+2;
            end
        end
        %分割完成停止扫描
        if(g == 1)
            break;
        end
        %判断分割是否溢出
        if (g ~= 1 && y == 1 )
            wrong = 1;
            break;
        end
    end
end
%判定边界分割是否正确,是否分割出7个大小正确的字符
a = 0;
if(length(W) == 14 || wrong ~= 1)
    for g=1:7
        if (W(g*2)-W(g*2-1) > round(n*0.15))
            a = a+1;
        end
    end
    wrong = 0;
end
%=============================================
%如果分割失败即W(14)为0或分割字符数多于7，进行经验分割
if (wrong == 1 || min(W) == 0|| a > 0 )
    W(2) = W(1) + n*0.11;%33宽度
    W(3) = W(2) + round(n*0.02);%5宽度
    W(4) = W(3) + n*0.11;
    W(5) = W(4) + n*0.08;%16宽度
    for g=3:6
        W(g*2) = W(g*2-1) + round(n*0.135);
        W(g*2+1) = W(g*2);
    end
    W(14) = n;
    FC = 1;
else
    FC = 0;
end
%=============================================
%输出分割后的字符
C = cell(1,7);
figure(4);
for g=1:7
    C{1,g} = temp(1:m,W(2*g-1):W(2*g));
    if (g == 2 || g == 6)
        [x,y] = size(C{1,g});
        C{1,g} = bwareaopen(C{1,g},round(x*y*0.1));
    end
    subplot(2,7,g),imshow(C{1,g});
end
% set( figure(4),'Color','blue')
%清除除了标志位和分割图像之外的所有数据
clearvars -except FC C txt numb
%调用识别函数
[output,ANS,cut2] = recognition(C);

for a=1:7
    figure(4),subplot(2,7,a+7),imshow(output{1,a});title(ANS{1,a});
end
suptitle('分割结果和识别结果')
toc;