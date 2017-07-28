clear;
clc;
solver=caffe.Solver('C:\caffe\caffe-master\examples\mnist\lenet_solver.prototxt'); %协议文件所在路径
%solver.solve()
iter=solver.iter()
train_net=solver.net
test_net=solver.test_nets(1)
close all;
hold on%画图用的 
iter_ = solver.iter();%获取迭代次数
while iter_<10000
    solver.step(1);%一步一步迭代
    iter_ = solver.iter();    %得到迭代次数
    loss=solver.net.blobs('loss').get_data();%取训练集的loss  
    if iter_==1
        loss_init = loss;
    else if(mod(iter_,1)==0)  %每1次绘制一次损失
        y_l=[loss_init loss];
        x_l=[iter_-1, iter_];     
        plot(x_l, y_l, 'r-');
        drawnow
        loss_init = loss;
        end
    end

    if mod(iter_, 100) == 0   %100次取一次accuray
        accuracy=solver.test_nets.blobs('accuracy').get_data();%取验证集的accuracy       
        if iter_/100 == 1
            accuracy_init = accuracy;
        else 
            x_l=[iter_-100, iter_];
            y_a=[accuracy_init accuracy];
            plot(x_l, y_a,'g-');
            drawnow
            accuracy_init=accuracy;
        end
    end
end
