%�������㷨
%����norΪ��һ����ͼƬ��templateΪģ��
%���pΪ��ͬ����ռ��
function p = pixelbypixel(nor,template)
[m,n] = size(nor);
b = 0;
for x = 1:m
    for y = 1:n
        if (nor(x,y) == template(x,y))
            b = b+1;
        end
    end
end
sums = m*n;
p = b/sums;
end