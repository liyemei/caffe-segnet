%参考http://www.aichengxu.com/view/2422137  
clear  
clc  
  
im = imread('cat.jpg');%读取图片  
figure;imshow(im);%显示图片  
[scores, maxlabel] = classification_demo(im, 0);%获取得分第二个参数0为CPU，1为GPU  
maxlabel %查看最大标签是谁  
figure;plot(scores);%画出得分情况  
axis([0, 999, -0.1, 0.5]);%坐标轴范围  
grid on %有网格  
  
fid = fopen('synset_words.txt', 'r');  
i=0;  
while ~feof(fid)  
    i=i+1;  
    lin = fgetl(fid);  
    lin = strtrim(lin);  
    if(i==maxlabel)  
        fprintf('the label of %d is %s\n',i,lin)  
        break  
    end  
end  