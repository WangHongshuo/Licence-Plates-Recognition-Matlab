 tic;
clc;
clear all;
close all;
% input = imread('test\qx\30\test_5.jpg');
input = imread('test\test_4.jpg');
%�ҶȻ�
Gray = rgb2gray(input);
figure(1),subplot(2,3,1),imshow(Gray,[]);title('�ҶȻ�')
% �ȱ�������ͼƬ
Gray = size300(Gray);
%=======ͼ����ת����=================
%rotate0Ϊradon�任,rotate1Ϊ���Ǽ��任��rotate2Ϊhough�任
% [Gray,angle] = rotate0(Gray);
% [Gray,angle]= rotate1(Gray);
% [Gray,angle] = rotate2(Gray);
% Gray = size300(Gray);
%=======ͼ����ת����=================
figure(1),subplot(2,3,2),imshow(Gray);
% title({'�����ͳߴ�任',;strcat('�Ƕ�:',num2str(angle))});
title('�ߴ�任');
%��ֵ�˲�.
Gray = double(medfilt2(Gray,[3 3]));
figure(1),subplot(2,3,3),imshow(Gray,[]);title('��ֵ�˲�')
% ȡ�Ҷ�ֵ��ֵ
%=========================================
% T = graythresh(Gray);%��һ�ֶ�ֵ������
% B = im2bw(Gray,T);
%=========================================
Imax = max(max(Gray));
Imin = min(min(Gray));
T = round((Imax-(Imax-Imin)/2)*1.1);%1.1765
B = (Gray)>=T;
subplot(2,3,4),imshow(B);title('��ֵ��')
% B1 = ~B;
% figure,imshow(B1);title('��ֵ��ȡ��')
%===========����==========================
% B = imread('test.bmp');
%=========================================
%ϸ��������һ���������
% B = bwmorph(B,'skel',1);
% subplot(2,3,4),imshow(B);title('ϸ������')
% �ȸ�ʴ,���ȥ�����С�ķ��ı�����
%�ַ���ֵ����ʻ���ϸ������һ��
[m,n] = size(B);
B = bwareaopen(B,20);
k = sum(sum(B));
se = strel('square',2);
if (k < m*n*0.19)
    B = imdilate(B,se);
    subplot(2,3,5),imshow(B);title('�ַ���ϸ����Ҫ����һ��')
elseif (k > m*n*0.5)
    B = ~B;
    k = sum(sum(B));
    if (k < m*n*0.19)
        B = imdilate(B,se);
    end
    subplot(2,3,5),imshow(B);title('��ɫ����ȡ��')
else
    subplot(2,3,5),imshow(B);title('�ַ�����Ҫ����һ��')
end
%ȥ�������С�Ĳ��֣�����������������������ͬ;
%��������
temp1 = B(1:m,1:round(n*0.3));
temp1 = bwareaopen(temp1,30);
%��ĸ��������
temp2 = B(1:m,round(n*0.3)+1:n);
temp2 = bwareaopen(temp2,150);
B = [temp1,temp2];
clear temp1 temp2
subplot(2,3,6),imshow(B);title('ȥ�������С����')
% set( figure(3),'Color','blue')
figure(3),subplot(2,1,1),imshow(B);title('�ü�ǰԭͼ');
% B = bwmorph(B, 'thin',Inf);title('ϸ��');
[m,n] = size(B);
% ��ֱͶӰ
[H,V] = shadow(B);
y=1:n;
figure(2),subplot(5,1,1),plot(y,V(y));title('��ֱͶӰ');
% ��ˮƽͶӰ
x=1:m;
subplot(5,1,2),plot(x,H(x));title('ˮƽͶӰ')
%ˮƽ����
%�ϱ߽�(�����ж�)
for x=round(m*0.25):-1:2
    %�ж�����
    if ((H(x) > round(n*0.14) && H(x-1) <= round(n*0.14)) || H(x) > round(n*0.75))%Ѱ��0-x�߽�
        H1 = x;
        break
    elseif (x == 2)
        H1 = 1;
    end
end
%�±߽�(�����ж�)
for x=round(m*0.7):m
    %�ж�����
    if ((H(x) <= round(n*0.16) && H(x-1) > round(n*0.16)) || H(x) > round(n*0.75))%Ѱ��x-0�߽�
        H2 = x-1;
        break
    elseif (x == m)%��ͼƬ���޿��
        H2 = m;
    end
end
%����һ�βü�
temp = B(H1:H2,1:n);
% ��ֱͶӰ
[m,n] = size(temp);
[H,V] = shadow(temp);
x=1:m;
subplot(5,1,3),plot(x,H(x));title('ˮƽ�ü����ˮƽͶӰ');
y=1:n;
subplot(5,1,4),plot(y,V(y));title('ˮƽ�ü���Ĵ�ֱͶӰ');
%��ֱ����
W = zeros(1,14);
W(1) = 1;
%���߽�
%ռ��W(1)W(2)W(3)�ݴ�
a = 2;
for y=round(n*0.2):-1:1
    %�ж�����
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

%�Ҳ�߽�
for y=round(n*0.9):n-1
    %�ж�����
    if(V(y) > 4 && V(y+1) <= 4)
        W(14) = y;
        break
    elseif (y == n-1)
        W(14) = n;
    end
end
%���ú��ͼƬ
temp = temp(1:m,W(1):W(14));
%�������ú��ͼƬ��С
[m,n] = size(temp);
k = m/n;
x = round(k*300);
temp = imresize(temp,[x,300]);
[~,n] = size(temp);
%���¼��ú��ͼ������(��ֱ)
[~,V] = shadow(temp);
y=1:n;
subplot(5,1,5),plot(y,V(y));title('��ֱ�ü���Ĵ�ֱͶӰ');

figure(3),subplot(2,1,2),imshow(temp);title('�ü������µ������ͼƬ');

[m,n] = size(temp);
%��ֱ����ָ��ַ�������ָ
W = zeros(1,14);
W(1) = 1;
W(14) = n;
g = 13;
wrong = 0;
for y=n-1:-1:1
    if ((V(y) <= 4  && V(y+1) > 4) || (V(y) > 4 && V(y+1) <= 4))%Ѱ��0-x��x-0�߽�
        W(g) = y;
        if (mod(g,2) == 1)%�����ָ�������ĺڱ�
            W(g) = W(g)+1;
        end
        g =g-1;
        %�ж��������ַ��ָ��Ƿ��ܵ����Ӱ��
        if (g == 2 && W(4) - W (3) < n*0.09)
            g = g+2;
        end
        %�ж����ĵ����߸��ַ��ָ��Ƿ���ȷ
        if(g < 13 && g > 3 && mod(g,2) == 0 && W(g+2) - W(g+1) < n*0.02 );
            k = sum(sum(V(:,W(g+1):W(g+2))));
            if (k/m/(W(g+2) - W(g+1)) < 0.75)
                W(g+2) = 0;
                W(g+1) = 0;
                g = g+2;
            end
        end
        %�ָ����ֹͣɨ��
        if(g == 1)
            break;
        end
        %�жϷָ��Ƿ����
        if (g ~= 1 && y == 1 )
            wrong = 1;
            break;
        end
    end
end
%�ж��߽�ָ��Ƿ���ȷ,�Ƿ�ָ��7����С��ȷ���ַ�
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
%����ָ�ʧ�ܼ�W(14)Ϊ0��ָ��ַ�������7�����о���ָ�
if (wrong == 1 || min(W) == 0|| a > 0 )
    W(2) = W(1) + n*0.11;%33���
    W(3) = W(2) + round(n*0.02);%5���
    W(4) = W(3) + n*0.11;
    W(5) = W(4) + n*0.08;%16���
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
%����ָ����ַ�
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
%������˱�־λ�ͷָ�ͼ��֮�����������
clearvars -except FC C txt numb
%����ʶ����
[output,ANS,cut2] = recognition(C);

for a=1:7
    figure(4),subplot(2,7,a+7),imshow(output{1,a});title(ANS{1,a});
end
suptitle('�ָ�����ʶ����')
toc;