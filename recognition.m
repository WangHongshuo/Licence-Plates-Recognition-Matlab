%ʶ���ӳ���
%���� algΪ1��Ϊ���������أ�����Ϊcorr2�㷨,C�ָ���ͼƬ��cell
%��� ouput��һ������ַ�cell,ANSʶ����
%cut2Ϊ�Ƿ������˵ڶ��ַָ��
function [output,ANS,cut2] = recognition(C)
%===========================
%alg=1Ϊcorr2,����Ϊ������
% alg = 1;
%===========================
%�����ַ�����
str = {'1','2','3','4','5','6','7'...
    '8','9','0','A','B','C','D','E'...
    'F','G','H','J','K','L','M'...
    'N','0','P','Q','R','S','T','U'...
    'V','W','X','Y','Z','7','O'};
%====����������(��ʱ5��)ģ��Ϊchinese========
% cn = {'��','��','��','ԥ','³','*'};
%==========================================
%=====����ȫ������,ģ��ΪChinese48X=========
cn = {'��','��','��','��','��','ԥ'...
    '��','��','��','��','��','³'...
    '��','��','��','��','��','��'...
    '��','��','��','��','��','��'...
    '��','��','��','��','��','��'...
    '��','��','��','��','��','��'...
    '��','��','*' };
%=========================================
%=========����ģ��==================
load Chinese48x %����������ΪChinese
load letter&number %����������ΪLN
%===================================
SN = zeros(1,7);
%��һ�ַָ���Ƿ�ʹ�õ��ж���־
cut2 = 0;
for a = 1:7;
    %=========��Ϸ�=============
    if (a == 1)
        alg =1;
    else
        alg =2;
    end
    %===========================
    %========������====================================
    %     cname = strcat('output\C',int2str(a),'.bmp');
    %     input = imread(cname);
    %==================================================
    %ѭ������C1~C7ͼ��
    I = C{1,a};
    %���ֱ����϶�����
    if (a == 1)
        I = bwareaopen(I,35);
    else
        I = bwareaopen(I,350);
    end
    [m,n] = size(I);
    %ֱ���ж��ַ��Ƿ�Ϊ1
    if (n/m < 0.3)
        SN(a) = 1;
    else
        %������ֱʻ���ϸ,����һ�Σ����紨��
        %������ֱʻ��ϴ֣���ʴһ�Σ�����ڣ�
        k = sum(sum(I));
        if (k/m/n < 0.45 && a == 1)
            I = bwmorph(I,'thicken',1);
        elseif(k/m/n > 0.82)
            I = bwmorph(I,'thin',1);
        elseif(k/m/n > 0.6 && a ~= 1)
            I = bwmorph(I,'thin',1);
        end
        % ��ֱͶӰ,ˮƽͶӰ
        [H,V] = shadow(I);
        %ͨ����ѯͶӰ�Ƿ���0���ٷָ�(��һ�ַָ��)
        %=======================================
        nor1 = I;
        A1 = min(V);
        A2 = min(H);
        %���ֺ�����Ӣ�Ĳ�ͬ�ָ����
        if (a == 1 )
            j = 0.14;
            k = 0.86;
        else
            j = 0.28;
            k = 0.72;
        end
        %���
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
        %�߶�
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
        %����һ�βü����ͶӰ����
        [m,n] = size(nor1);
        [H,V] = shadow(nor1);
        %�߶Ȳü�
        %���ֺ���ĸ���ò�ͬ�ķָ����
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
                    %�������ǰ���ж�Ϊ0
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
        %��ȼ���
        %��������ĸ���ּ��ò�����ͬ
        if (min(V) <= 4)
            if (a == 1)
                j = 0.2;
                k = 1;
            else
                j = 0.4;
                k = 0.6;
            end
            %��߽�
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
            %�ұ߽�
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
        nor1 = nor1(H1:H2,W1:W2);%����ѡȡ�ĸ�ʽΪ(��1:��2,��1:��2)
        [m,n] = size(nor1);
        %�ж��ü����Ƿ�Ϊ1
        if (n/m < 0.3)
            SN(a) = 1;
            C{1,a} = nor1;
        else
            %===========���ô�ģ��ʱ����=================
            if (a == 1)
                nor2 = imresize(nor1,[84,48]);
            else
                nor2 = imresize(nor1,[42,24]);
            end
            %=========================================
            %         nor2 = imresize(nor1,[42,24]);
            %===========������(�����һ��ͼƬ)========
            C{1,a} = nor2;
            %         imwrite(nor2,cname)
            %========================================
            %========================================
            %ģ��ƥ��,��������ƶȣ����ֵΪʶ����
            %��һ���ַ����ú���ģ��ʶ��
            if (a == 1)
                P = zeros(1,length(Chinese));
                for i=1:length(Chinese)
                    if (alg == 1)
                        %                     %�������ƶ��㷨
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
            %�ж����ƶ����������������
            if (a ~= 1)
                [m,~] = sort(P);
                k = m(36) - m(35);
            end
            %�����㷨��ֵ��ͬ
            if (alg == 1)
                t = 0.08;
            else
                t = 0.05;
            end
            if (a ~= 1 && k < t)
                %����������D��0
                if(j == 14)
                    V3 = V(1:4);
                    if (max(V3) < 40)
                        j = 10;
                    else
                        j = 14;
                    end
                    %����������C��0
                elseif (j == 13 )
                    V3 = V(1:12);
                    V4 = V(13:24);
                    if (abs(max(V3) - max(V4)) < 4 )
                        j = 10;
                    end
                    %����������Q��0
                elseif (j == 10 || j == 26)
                    temp = nor2(22:42,13:24);
                    if (sum(sum(temp)) > 21*12*0.63)
                        j = 26;
                    else
                        j = 10;
                    end
                    %����������B��8
                elseif (j == 12 || j == 8)
                    V3 = V(1:4);
                    if(max(V3) <= 40)
                        j = 8;
                    else
                        j = 12;
                    end
                    %����������S��5
                elseif (j == 28 || j == 5)
                    W3 = H(1:6);
                    if(max(W3) < 21)
                        j = 28;
                    else
                        j = 5;
                    end
                    %����������P��F
                elseif (j == 16 || j == 25)
                    W3 = H(1:6);
                    if (max(W3) < 22);
                        j = 25;
                    else
                        j = 16;
                    end
                    %����������T��1
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
        %            ���Ƶڶ�λ��Ϊ����
        %         ���ʶ��Ϊ0,ǿ��ת��ΪO,���ƺ�5λû��O
        %         ���ʶ��Ϊ8,ǿ��ת����B
        %         ���ʶ��Ϊ6,ǿ��ת����G
        %         ���ʶ��Ϊ4,ǿ��ת����A
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
%======����ʶ����������ʾ*======
if (SN(1) > length(cn)-1)
    SN(1) = length(cn);
end
%================================
%����������������ֵ
output = strcat(cn{SN(1)},str{SN(2)},...
    str{SN(3)},str{SN(4)},str{SN(5)},str{SN(6)},str{SN(7)});
ANS = {cn{SN(1)},str{SN(2)},...
    str{SN(3)},str{SN(4)},str{SN(5)},str{SN(6)},str{SN(7)},output};
clearvars -except C ANS cut2
output = C;
end
