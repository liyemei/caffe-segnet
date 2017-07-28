# -*- coding: utf-8 -*-
"""
Created on Wed Jul 12 22:46:26 2017

@author: Administrator
"""
import numpy as np
from PIL import Image
import matplotlib.pyplot as plt
import caffe
CAFFE_ROOT='C:/caffe/caffe-master/python'
import numpy as np
import os
import sys
sys.path.append(CAFFE_ROOT)
# 初始化地址
model_def = 'segnet_model_driving_webdemo.prototxt' # 模型文件
model_weights =  'segnet_weights_driving_webdemo.caffemodel' #模型权重值
test_image = "5.jpg" #测试图片

# load image, switch to BGR, subtract mean, and make dims C x H x W for Caffe
'''im = Image.open(test_image)
in_ = np.array(im, dtype=np.float32)
in_ = in_[:,:,::-1] # change RGB image to BGR image
in_ = in_.transpose((2,0,1)) # Reshape the image from (500, 334, 3) to (3, 500, 334)'''

net = caffe.Net(model_def, model_weights, caffe.TEST) #导入模型
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})  #设定图片的shape格式(1,3,28,28) 
transformer.set_transpose('data', (2,0,1))    #改变维度的顺序，由原始图片(28,28,3)变为(3,28,28) 
    #transformer.set_mean('data', np.load(mean_file).mean(1).mean(1))    #减去均值，前面训练模型时没有减均值，这儿就不用 
transformer.set_raw_scale('data', 255)    # 缩放到【0，255】之间 
transformer.set_channel_swap('data', (2,1,0))   #交换通道，将图片由RGB变为BGR 
       
im=caffe.io.load_image(test_image)                   #加载图片 
net.blobs['data'].data[...] = transformer.preprocess('data',im) 
     #执行上面设置的图片预处理操作，并将图片载入到blob中 
net.forward() #图片进入前馈卷积神经网络
'''net.blobs['data'].reshape(1, *in_.shape) 
net.blobs['data'].data[...] = in_ #读入图像'''

out = net.blobs['conv1_1_D'].data[0].argmax(axis=0) #最后得到的图片
out= np.array(out)
"""print net.blobs['score'].data[0].shape #(21, 500, 334) 
print net.blobs['score'].data[0].argmax(axis=0)
print out.shape"""
plt.imshow(out)

