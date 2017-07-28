function [  ] = weight_fullvisual( net,layer_num  )  
layers=net.layer_names;  
convlayer=[];  
for i=1:length(layers)  
    if strcmp(layers{i}(1:3),'con')  
        convlayer=[convlayer;layers{i}];  
    end  
end

w=net.layers(convlayer(layer_num,:)).params(1).get_data();%四维，核长*核宽*核左边输入*核右边输出(核个数)
b=net.layers(convlayer(layer_num,:)).params(2).get_data();  
minval=min(min(min(min(w))));  
maxval=max(max(max(max(w))));  
w=(w-minval)/maxval*255;  
  
[kernel_r,kernel_c,input_num,kernel_num]=size(w);  
map_row=input_num;%行数  
map_col=kernel_num;%列数  
weight_map=zeros(kernel_r*map_row,kernel_c*map_col);  
for i=0:map_row-1  
    for j=0:map_col-1  
        weight_map(i*kernel_r+1+i:(i+1)*kernel_r+i,j*kernel_c+1+j:(j+1)*kernel_c+j)=w(:,:,i+1,j+1);  
    end  
end  
figure  
imshow(uint8(weight_map))  
str1=strcat('weight num:',num2str(map_row*map_col));  
title(str1)  
  
end 