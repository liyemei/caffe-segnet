function [  ] = feature_partvisual( net,mapnum,crop_num ) 
%这一部分针对指定的第crop_num张图像在第map_num层进行可视化。注意，这一部分的可视化包含池化层等
names=net.blob_names;  
featuremap=net.blobs(names{mapnum}).get_data();%获取指定层的特征图  
[m_size,n_size,num,crop]=size(featuremap);%获取特征图大小，长*宽*卷积核个数*通道数  
row=ceil(sqrt(num));%行数  
col=row;%列数  
feature_map=zeros(m_size*row,n_size*col);  
cout_map=1;  
for i=0:row-1  
    for j=0:col-1  
        if cout_map<=num  
            feature_map(i*m_size+1:(i+1)*m_size,j*n_size+1:(j+1)*n_size)=(mapminmax(featuremap(:,:,cout_map,crop_num),0,1)*255)';  
            cout_map=cout_map+1;  
        end  
    end  
end  
imshow(uint8(feature_map))  
str=strcat('feature map num:',num2str(cout_map-1));  
title(str)  
end  