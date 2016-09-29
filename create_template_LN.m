clc;
close all;
clear all;
A=imread('sample\A.bmp');
B=imread('sample\B.bmp');
C=imread('sample\C.bmp');
D=imread('sample\D.bmp');
E=imread('sample\E.bmp');
F=imread('sample\F.bmp');
G=imread('sample\G.bmp');
H=imread('sample\H.bmp');
J=imread('sample\J.bmp');
K=imread('sample\K.bmp');
L=imread('sample\L.bmp');
M=imread('sample\M.bmp');
N=imread('sample\N.bmp');
O=imread('sample\O.bmp');
P=imread('sample\P.bmp');
Q=imread('sample\Q.bmp');
R=imread('sample\R.bmp');
S=imread('sample\S.bmp');
T=imread('sample\T.bmp');
U=imread('sample\U.bmp');
V=imread('sample\V.bmp');
W=imread('sample\W.bmp');
X=imread('sample\X.bmp');
Y=imread('sample\Y.bmp');
Z=imread('sample\Z.bmp');
one=imread('sample\1.bmp');  
two=imread('sample\2.bmp');
three=imread('sample\3.bmp');
four=imread('sample\4.bmp');
five=imread('sample\5.bmp');
six=imread('sample\6.bmp');
seven=imread('sample\7.bmp');
eight=imread('sample\8.bmp');
nine=imread('sample\9.bmp'); 
zero=imread('sample\0.bmp');

%补充模版
%7的另一个模版
A1 = imread('sample\7-1.bmp');
%额外模版
ext = [A1 ];

letter=[A B C D E F G H J K L M...
    N O P Q R S T U V W X Y Z];
number=[one two three four five...
    six seven eight nine zero];
character=[number letter ext];
LN=mat2cell(character,42,[24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24 24 24 24 24 24 24 ...
    24]);
save ('letter&number','LN')
clear all