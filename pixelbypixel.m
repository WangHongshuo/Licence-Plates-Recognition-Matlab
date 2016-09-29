%逐像素算法
%输入nor为归一化的图片，template为模版
%输出p为相同像素占比
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