windows vs2013 python2.7 matlab2014以上
添加upsample 、BN层。支持Segnet，添加Segnet-C++、python接口demo
打开windows-Caffe.sln编译即可，其他编译问题同微软官方caffe步骤
添加了cpm层,输入层数据可以旋转变换

使用方法参考：https://github.com/CMU-Perceptual-Computing-Lab/caffe_train

这个没有DenseImageDataLayer，不过可以如下代替：
data 和label分开输入
layer {
  name: "data"
  type: "Data"
  top:"data"
  include {
    phase: TRAIN
  }
  transform_param {
mean_file: "G:/interest_of_imags_for_recognation/VOC2012/Resize224/Img_train_mean.binaryproto"
  }
  data_param {
    source: "G:/interest_of_imags_for_recognation/VOC2012/Resize224/Img_train"
    batch_size: 1
    backend: LMDB
  }
}
layer {
  name: "label"
  type: "Data"
  top:"label"
  include {
    phase: TRAIN
  }
  data_param {
    source: "G:/interest_of_imags_for_recognation/VOC2012/Resize224/Label_train"
    batch_size: 1
    backend: LMDB
  }
}
layer {
  name: "data"
  type: "Data"
  top: "data"
  include {
    phase: TEST
  }
  transform_param {
    mean_file: "G:/interest_of_imags_for_recognation/VOC2012/Resize224/Img_val_mean.binaryproto"
  }
  data_param {
    source: "G:/interest_of_imags_for_recognation/VOC2012/Resize224/Img_val"
    batch_size: 1
    backend: LMDB
  }
}
layer {
  name: "label"
  type: "Data"
  top: "label"
  include {
    phase: TEST
  }
  data_param {
    source: "G:/interest_of_imags_for_recognation/VOC2012/Resize224/Label_val"
    batch_size: 1
    backend: LMDB
  }
}

这里上传一个简化版本的训练测试工程，解压后放在D盘即可，训练在C++训练。
链接：http://pan.baidu.com/s/1o80sCEu 密码：ugbs

copyright @Qingsong Liu
