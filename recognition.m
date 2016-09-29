%识别子程序
%输入 alg为1则为采用逐像素，其他为corr2算法,C分割后的图片的cell
%输出 ouput归一化后的字符cell,ANS识别结果
%cut2为是否启用了第二种分割方法
function [output,ANS,cut2] = recognition(C)
%===========================
%alg=1为corr2,其他为逐像素
% alg = 1;
%===========================
%创建字符数组
str = {'1','2','3','4','5','6','7'...
    '8','9','0','A','B','C','D','E'...
    'F','G','H','J','K','L','M'...
    'N','0','P','Q','R','S','T','U'...
    'V','W','X','Y','Z','7','O'};
%====创建汉字组(暂时5个)模版为chinese========
% cn = {'京','川','皖','豫','鲁','*'};
%==========================================
%=====创建全汉字组,模版为Chinese48X=========
cn = {'京','津','沪','渝','冀','豫'...
    '云','辽','黑','湘','皖','鲁'...
    '苏','赣','浙','粤','鄂','桂'...
    '甘','晋','蒙','陕','吉','闽'...
    '贵','青','藏','川','宁','新'...
    '琼','云','渝','沪','冀','京'...
    '云','藏','*' };
%=========================================
%=========调用模版==================
load Chinese48x %工作区名称为Chinese
load letter&number %工作区名称为LN
%===================================
SN = zeros(1,7);
%第一种分割方法是否使用的判定标志
cut2 = 0;
for a = 1:7;
    %=========混合法=============
    if (a == 1)
        alg =1;
    else
        alg =2;
    end
    %===========================
    %========测试用====================================
    %     cname = strcat('output\C',int2str(a),'.bmp');
    %     input = imread(cname);
    %==================================================
    %循环读出C1~C7图像
    I = C{1,a};
    %汉字保留较多区域
    if (a == 1)
        I = bwareaopen(I,35);
    else
        I = bwareaopen(I,350);
    end
    [m,n] = size(I);
    %直接判定字符是否为1
    if (n/m < 0.3)
        SN(a) = 1;
    else
        %如果汉字笔画较细,膨胀一次（例如川）
        %如果汉字笔画较粗，腐蚀一次（例如黑）
        k = sum(sum(I));
        if (k/m/n < 0.45 && a == 1)
            I = bwmorph(I,'thicken',1);
        elseif(k/m/n > 0.82)
            I = bwmorph(I,'thin',1);
        elseif(k/m/n > 0.6 && a ~= 1)
            I = bwmorph(I,'thin',1);
        end
        % 求垂直投影,水平投影
        [H,V] = shadow(I);
        %通过查询投影是否有0点再分割(另一种分割方法)
        %=======================================
        nor1 = I;
        A1 = min(V);
        A2 = min(H);
        %汉字和数字英文不同分割参数
        if (a == 1 )
            j = 0.14;
            k = 0.86;
        else
            j = 0.28;
            k = 0.72;
        end
        %宽度
        if (A1 <= 4)
            V3 = V(1:round(n*j));
            V4 = V(round(n*k)+1:n);
            W3 = find(V3 <= 4);
            W4 = find(V4 <= 4);
            W1 = max(W3);
            W2 = min(W4);
            if (isempty(W1) == 1)
                W1 = 1;
            end
            if (isempty(W2) == 1)
                W2 = n;
            else
                W2 = n-round(n*j)-1 + W2;
            end
            cut2 = cut2 + 1;
            nor1 = nor1(1:m,W1:W2);
        end
        %高度
        if (A2 <= 4)
            [m,n] = size(nor1);
            H3 = H(1:round(m*j));
            H4 = H(round(m*k)+1:m);
            H3 = find(H3 <= 4);
            H4 = find(H4 <= 4);
            H1 = max(H3);
            H2 = min(H4);
            if (isempty(H1) == 1)
                H1 = 1;
            end
            if (isempty(H2) == 1)
                H2 = m;
            else
                H2 = m-round(m*j)-1 + H2;
            end
            cut2 = cut2 + 1;
            nor1 = nor1(H1:H2,1:n);
        end
        %=========================================
        %更新一次裁剪后的投影数据
        [m,n] = size(nor1);
        [H,V] = shadow(nor1);
        %高度裁减
        %汉字和字母采用不同的分割参数
        if (min(H) <= 3)
            if (a == 1)
                j = 0.15;
                k = 0.85;
            else
                j = 0.4;
                k = 0.6;
            end
            for x=round(m*j):-1:1
                if (H(x) <= 3 && H(x+1) > 3)
                    H1 = x+1;
                    break;
                    %如果出现前几行都为0
                elseif (H(x) <= 3 && H(x+1) <= 3)
                    H1 = x+1;
                elseif (x == round(m*j))
                    H1 = 1;
                end
            end
            for x=round(m*k):m
                if(H(x) <= 3  && H(x-1) > 3)
                    H2 = x-1;
                    break;
                elseif (H(x) <= 3 && H(x-1) <= 3)
                    H2 = x-1;
                elseif (x == round(m*k))
                    H2 = m;
                end
            end
        else
            H1 = 1;
            H2 = m;
        end
        %宽度剪裁
        %汉字与字母数字剪裁参数不同
        if (min(V) <= 4)
            if (a == 1)
                j = 0.2;
                k = 1;
            else
                j = 0.4;
                k = 0.6;
            end
            %左边界
            for x=round(n*j):-1:1
                if (V(x) <= 4 && V(x+1) > 4)
                    W1 = x+1;
                    break;
                elseif(V(x) <=4 && V(x+1) <=4 )
                    W1 = x+1;
                elseif (x == round(n*j))
                    W1 = 1;
                end
            end
            %右边界
            for x=round(n*k):n
                if(V(x) <= 4 && V(x-1) > 4)
                    W2 = x-1;
                    break;
                elseif(V(x) <=4 && V(x-1) <=4 )
                    W2 = x-1;
                elseif (x == round(n*k))
                    W2 = n;
                end
            end
        else
            W1 = 1;
            W2 = n;
        end
        nor1 = nor1(H1:H2,W1:W2);%区域选取的格式为(行1:行2,列1:列2)
        [m,n] = size(nor1);
        %判定裁剪后是否为1
        if (n/m < 0.3)
            SN(a) = 1;
            C{1,a} = nor1;
        else
            %===========调用大模版时启用=================
            if (a == 1)
                nor2 = imresize(nor1,[84,48]);
            else
                nor2 = imresize(nor1,[42,24]);
            end
            %=========================================
            %         nor2 = imresize(nor1,[42,24]);
            %===========测试用(输出归一化图片)========
            C{1,a} = nor2;
            %         imwrite(nor2,cname)
            %========================================
            %========================================
            %模版匹配,求矩阵相似度，最大值为识别结果
            %第一个字符调用汉子模版识别
            if (a == 1)
                P = zeros(1,length(Chinese));
                for i=1:length(Chinese)
                    if (alg == 1)
                        %                     %矩阵相似度算法
                        P(i) = corr2(nor2,Chinese{1,i});
                    else
                        P(i) = pixelbypixel(nor2,Chinese{1,i});
                    end
                end
            else
                P = zeros(1,length(LN));
                for i=1:length(LN)
                    if (alg == 1)
                        P(i) = corr2(nor2,LN{1,i});
                    else
                        P(i) = pixelbypixel(nor2,LN{1,i});
                    end
                end
            end
            %========================================
            M = max(P);
            [~,j] = find(P == M);
            j = min(j);
            [H,V] = shadow(nor2);
            %判定相似度相近则启动特征法
            if (a ~= 1)
                [m,~] = sort(P);
                k = m(36) - m(35);
            end
            %两种算法阈值不同
            if (alg == 1)
                t = 0.08;
            else
                t = 0.05;
            end
            if (a ~= 1 && k < t)
                %特征法区分D和0
                if(j == 14)
                    V3 = V(1:4);
                    if (max(V3) < 40)
                        j = 10;
                    else
                        j = 14;
                    end
                    %特征法区分C和0
                elseif (j == 13 )
                    V3 = V(1:12);
                    V4 = V(13:24);
                    if (abs(max(V3) - max(V4)) < 4 )
                        j = 10;
                    end
                    %特征法区分Q和0
                elseif (j == 10 || j == 26)
                    temp = nor2(22:42,13:24);
                    if (sum(sum(temp)) > 21*12*0.63)
                        j = 26;
                    else
                        j = 10;
                    end
                    %特征法区分B和8
                elseif (j == 12 || j == 8)
                    V3 = V(1:4);
                    if(max(V3) <= 40)
                        j = 8;
                    else
                        j = 12;
                    end
                    %特征法区分S和5
                elseif (j == 28 || j == 5)
                    W3 = H(1:6);
                    if(max(W3) < 21)
                        j = 28;
                    else
                        j = 5;
                    end
                    %特征法区分P和F
                elseif (j == 16 || j == 25)
                    W3 = H(1:6);
                    if (max(W3) < 22);
                        j = 25;
                    else
                        j = 16;
                    end
                    %特征法区分T和1
                elseif (j == 1 || j == 29)
                    W3 = H(3:6);
                    if (max(W3) > 20)
                        j = 29;
                    else
                        j = 1;
                    end
                end
            end
            SN(a) = j;
        end
        %            车牌第二位不为数字
        %         如果识别为0,强制转换为O,车牌后5位没有O
        %         如果识别为8,强制转换成B
        %         如果识别为6,强制转换成G
        %         如果识别为4,强制转换成A
        if (a == 2)
            if  (SN(a) == 10||SN(a) == 24)
                SN(a) = 37;
            elseif (SN(a) == 8)
                SN(a) = 12 ;
            elseif (SN(a) == 6)
                SN(a) = 17 ;
            elseif (SN(a) == 4)
                SN(a) = 11;
            end
        end
        clear nor1 nor2 P max ;
    end
end
%======汉字识别参数溢出显示*======
if (SN(1) > length(cn)-1)
    SN(1) = length(cn);
end
%================================
%清理工作区并整理返回值
output = strcat(cn{SN(1)},str{SN(2)},...
    str{SN(3)},str{SN(4)},str{SN(5)},str{SN(6)},str{SN(7)});
ANS = {cn{SN(1)},str{SN(2)},...
    str{SN(3)},str{SN(4)},str{SN(5)},str{SN(6)},str{SN(7)},output};
clearvars -except C ANS cut2
output = C;
end
