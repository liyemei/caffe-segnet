windows vs2013 python2.7 matlab2014以上
添加upsample 、BN层。支持Segnet，添加Segnet-C++、python接口demo
打开windows-Caffe.sln编译即可，其他编译问题同微软官方caffe步骤
添加了cpm层。
参考：
We add customized caffe layer for data augmentation: cpm_data_transformer.cpp, including scale augmentation e.g., in the range of 0.7 to 1.3, rotation augmentation, e.g., in the range of -40 to 40 degrees, flip augmentation and image cropping. This augmentation strategy makes the method capable of dealing with a large range of scales and orientations. You can set the augmentation parameters in setLayers.py. Example data layer parameters in the training prototxt is:

layer {
  name: "data"
  type: "CPMData"
  top: "data"
  top: "label"
  data_param {
    source: "/home/zhecao/COCO_kpt/lmdb_trainVal"
    batch_size: 10
    backend: LMDB
  }
  cpm_transform_param {
    stride: 8
    max_rotate_degree: 40
    visualize: false
    crop_size_x: 368
    crop_size_y: 368
    scale_prob: 1
    scale_min: 0.5
    scale_max: 1.1
    target_dist: 0.6
    center_perterb_max: 40
    do_clahe: false
    num_parts: 56
    np_in_lmdb: 17
  }
}


