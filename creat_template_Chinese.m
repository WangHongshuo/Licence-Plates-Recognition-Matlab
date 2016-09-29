clc;
close all;
clear all;
%Chinese characters
%京津沪渝冀
%豫云辽黑湘
%皖鲁苏赣浙
%粤鄂桂甘晋
%蒙陕吉闽贵
%青藏川宁新
%琼云渝京冀
%沪云藏
Chinese = cell(1,38);
for a=1:38
    cname = strcat('sample_CNB\',int2str(a),'.bmp');
    I = imread(cname);
    Chinese{1,a} = I;
end

save ('Chinese48x','Chinese')
load Chinese48x
