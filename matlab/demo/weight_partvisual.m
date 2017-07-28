function [  ] = weight_partvisual( net,layer_num ,channels_num )  
layers=net.layer_names;  
convlayer=[];  
for i=1:length(layers)  
    if strcmp(layers{i}(1:3),'con')  %%仅仅卷积核能获取到权重 0 
        convlayer=[convlayer;layers{i}];  
    end  
end  
w=net.layers(convlayer(layer_num,:)).params(1).get_data();  
b=net.layers(convlayer(layer_num,:)).params(2).get_data();  
w=w-min(w(:));  
w=w/max(w(:))*255;  %归一化

weight=w(:,:,channels_num,:);%四维，核长*核宽*核左边输入*核右边输出(核个数)  
[kernel_r,kernel_c,input_num,kernel_num]=size(w);  
map_row=ceil(sqrt(kernel_num));%行数  
map_col=map_row;%列数  
weight_map=zeros(kernel_r*map_row,kernel_c*map_col);  
kernelcout_map=1;  
for i=0:map_row-1  
    for j=0:map_col-1  
        if kernelcout_map<=kernel_num  
            weight_map(i*kernel_r+1+i:(i+1)*kernel_r+i,j*kernel_c+1+j:(j+1)*kernel_c+j)=weight(:,:,:,kernelcout_map);  
            kernelcout_map=kernelcout_map+1;  
        end  
    end  
end  
figure  
hAxe=axes('Parent',gcf,... % 设置新的axe， 将'parent' 属性设置为当前窗口gcf
    'Units','pixels',...     %设置单位为pixels
    'Position',[500 0 605 705]);  % 指定axe的位置 left和bottom设定了axe的左下角坐标，width和height设定了窗口的宽度和高度
axes(hAxe);
imshow(uint8(weight_map))  
str1=strcat('weight num:',num2str(kernelcout_map-1));  
title(str1)  

end  