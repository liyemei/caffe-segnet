clc;
clear;
model = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\deploy.prototxt';%模型  
weights = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\bvlc_reference_caffenet.caffemodel';%参数  
net=caffe.Net(model,'train');%测试 
net.copy_from(weights); %得到训练好的权重参数 
names=net.blob_names; %网络每一层的名字
namess=net.layer_names;
%weight_fullvisual( net,2 )  %3个通道的
weight_partvisual(net,2,48) 
