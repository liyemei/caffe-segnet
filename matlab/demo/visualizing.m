clc;
clear;
model = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\deploy.prototxt';%模型  
weights = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\bvlc_reference_caffenet.caffemodel';%参数  
net=caffe.Net(model,'test');%测试    
names=net.blob_names; %网络每一层的名字
net.copy_from(weights); %得到训练好的权重参数  
net %显示net的结构  
d = load('C:\caffe\caffe-master\matlab\+caffe\imagenet\ilsvrc_2012_mean.mat');  %均值文件
mean_data = d.mean_data;  
%彩色图像按照BGR存储，而matlab中读取的顺序一般是RGB。所以对这只猫需要进行如下处理：
im = imread('cat.jpg');%读取图片  
im_data = im(:, :, [3, 2, 1]);  %matlab按照RGB读取图片，
IMAGE_DIM = 256;%图像将要resize的大小，建议resize为图像最小的那个维度  
CROPPED_DIM = 227;%待会需要把一张图片crops成十块，最终softmpencv是BGR，所以需要转换顺序为opencv处理格式  
im_data = permute(im_data, [2, 1, 3]);  % 原始图像m*n*channels,现在permute为n*m*channels大小  
im_data = single(im_data);  % 强制转换数据为single类型  
im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');  % 线性插值resize图像  

 im_data = im_data - mean_data;  % 零均值  
crops_data = zeros(CROPPED_DIM, CROPPED_DIM, 3, 10, 'single');%注意此处是因为prototxt的输入大小为宽*高*通道数*10  
indices = [0 IMAGE_DIM-CROPPED_DIM] + 1;%获得十块每一块大小与原始图像大小差距，便于crops  
%下面就是如何将一张图片crops成十块  
n = 1;  
%此处两个for循环并非是1：indices，而是第一次取indices(1)，然后是indices(2)，每一层循环两次  
%分别读取图片四个角大小为CROPPED_DIM*CROPPED_DIM的图片  
for i = indices  
    for j = indices  
        crops_data(:, :, :, n) = im_data(i:i+CROPPED_DIM-1, j:j+CROPPED_DIM-1, :);%产生四个角的cropdata，1 2 3 4  
        crops_data(:, :, :, n+5) = crops_data(end:-1:1, :, :, n);%翻转180°来一次，产生四个角的翻转cropdata，6 7 8 9  
        n = n + 1;  
    end  
end  
center = floor(indices(2) / 2) + 1;  
%以中心为crop_data左上角顶点，读取CROPPED_DIM*CROPPED_DIM的块  
crops_data(:,:,:,5) = ...  
    im_data(center:center+CROPPED_DIM-1,center:center+CROPPED_DIM-1,:);  
%与for循环里面一样，翻转180°，绕左边界翻转  
crops_data(:,:,:,10) = crops_data(end:-1:1, :, :, 5);  
                             
cat_map=zeros(CROPPED_DIM*2,CROPPED_DIM*5,3);%两行五列展示  
cat_num=0;  
for i=0:1  
    for j=0:4  
        cat_num=cat_num+1  
        cat_map(CROPPED_DIM*i+1:(i+1)*CROPPED_DIM,CROPPED_DIM*j+1:(j+1)*CROPPED_DIM,:)=crops_data(:,:,:,cat_num);  
    end  
end  
imshow(uint8(cat_map))
%前向计算
res=net.forward({crops_data});  
prob=res{1};  
prob1 = mean(prob, 2);  
[~, maxlabel] = max(prob1);
%weight_partvisual(net,1,1)  %　调用部分显示函数　weight_partvisual( net,layer_num ,channels_num )  
                               %  layer_num是第几个卷积层， channels_num 表示 
                                 %  显示第几个通道的卷积核，取值范围为 （0，上一层的特征图数）
%weight_fullvisual( net,1  )  %3个通道的
mapnum=3;%第几层的feature☆☆☆☆☆☆☆☆  
crop_num=1;%第几个crop的特征图☆☆☆☆☆☆☆☆  
feature_partvisual( net,mapnum,crop_num ) 

%mapnum=2;%第几层的feature☆☆☆☆☆☆☆☆  
%feature_fullvisual( net,mapnum )
%K>> A=net.blobs('pool5').get_data(); 
%C=net.layers('fc6').params(1).get_data();  