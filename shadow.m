%HΪˮƽͶӰ��VΪ��ֱͶӰ
function [H,V] = shadow(im1)
im2=im1.'; %ͼ������ת��
H=sum(im2); %ˮƽͶӰ�������
%��ֱͶӰ
V=sum(im1); %��ֱͶӰ�� ������
end