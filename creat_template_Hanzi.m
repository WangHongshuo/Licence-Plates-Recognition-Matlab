clc;
close all;
clear all;
%¾©½ò»¦Óå¼½
%Ô¥ÔÆÁÉºÚÏæ
%ÍîÂ³ËÕ¸ÓÕã
%ÔÁ¶õ¹ğ¸Ê½ú
%ÃÉÉÂ¼ªÃö¹ó
%Çà²Ø´¨ÄşĞÂ
%ÇíÔÆÓå¾©¼½
%»¦ÔÆ²Ø
Chinese = cell(1,38);
for a=1:38
    cname = strcat('sample_CNB\',int2str(a),'.bmp');
    I = imread(cname);
    Chinese{1,a} = I;
end

save ('Chinese48x','Chinese')
load Chinese48x