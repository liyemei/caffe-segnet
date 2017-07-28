caffe.set_mode_cpu();       %设置cpu或者gpu模式
caffe.reset_all();
model = 'C:\caffe\caffe-master\examples\mnist\lenet_train_test.prototxt';%模型  
weights = 'C:\caffe\caffe-master\examples\mnist\lenet_iter_10000.caffemodel';%参数  
net = caffe.Net(model,weights,'test');
acc=[];
loss=[];
for i=1:49
    net.forward_prefilled
   acc=[acc; net.blobs('accuracy').get_data()];
  loss=[loss;net.blobs('loss').get_data()];
end
acc;
loss;
i=1:49;
figure()
plot(i,loss)

