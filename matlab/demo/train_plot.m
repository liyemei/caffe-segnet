
logName='caffe.exe.DESKTOP-86PUKQH.hyman.log.INFO.20170424-233340.13488'
fid = fopen(logName, 'r'); 
test_loss = fopen('test_loss.txt', 'w'); 
train_loss = fopen('train_loss.txt', 'w'); 
train_lr = fopen('train_lr.txt','w');
tline = fgetl(fid); 
while ischar(tline) 
    k = strfind(tline, 'Iteration'); 
    % it's a valid log
    if ~isempty(k) 
        iter_start = k+10;
        iter_end = strfind(tline(k:end),',');
        iter = tline(iter_start:iter_end+k-2);
        %store test_loss
        lr_k = strfind(tline, 'lr'); 
        if ~isempty(lr_k) 
            lr_tart = lr_k + 5; 
            lr = tline(lr_tart : end);
            fprintf(train_lr, '%s\t%s\n', iter,lr); 
        end 
        %store train_loss
        train_k = strfind(tline, 'loss'); 
        if ~isempty(train_k) 
            train_tart = train_k + 7; 
            loss_train = tline(train_tart : end);
            fprintf(train_loss, '%s\t%s\n', iter,loss_train); 
        end 
        %store test_loss
        test_k = strfind(tline, 'Testing'); 
        if ~isempty(test_k) % 
            tline = fgetl(fid); 
            flag = 1;
            while(ischar(tline) && flag)
                test_k = strfind(tline, 'loss'); 
                if ~isempty(test_k) 
                    flag = 0;
                    test_start = test_k + 7;
                    test_end = strfind(tline(test_start:end),'(')-3;
                    loss_test = tline(test_start : test_end+test_start);
                    fprintf(test_loss, '%s\t%s\n', iter,loss_test); 
                end 
                tline = fgetl(fid); 
            end
        end 
    end
    tline = fgetl(fid); 
end
fclose(fid); 
fclose(test_loss);
fclose(train_loss);
fclose(train_lr);
%plot

train_loss=importdata('train_loss.txt');
if(~isempty(train_loss))
    figure(1)
    plot(train_loss(:,1),train_loss(:,2));
    title('train_loss vs. Iterations')
end


test_loss=importdata('test_loss.txt');
if(~isempty(test_loss))
    figure(2)
    plot(test_loss(:,1),test_loss(:,2));
    title('test_loss vs. Iterations')
end


train_lr=importdata('train_lr.txt');
if(~isempty(train_lr))
    figure(3)
    plot(train_lr(:,1),train_lr(:,2));
    title('train_lr vs. Iterations')
end