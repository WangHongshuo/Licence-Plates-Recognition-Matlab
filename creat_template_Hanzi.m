clc;
close all;
clear all;
%�����弽
%ԥ���ɺ���
%��³�ո���
%������ʽ�
%���¼�����
%��ش�����
%�����復��
%���Ʋ�
Chinese = cell(1,38);
for a=1:38
    cname = strcat('sample_CNB\',int2str(a),'.bmp');
    I = imread(cname);
    Chinese{1,a} = I;
end

save ('Chinese48x','Chinese')
load Chinese48x