logName='caffetest.exe.DESKTOP-86PUKQH.hyman.log.INFO.20170425-150209.7408'
fid = fopen(logName, 'r'); 
test_loss = fopen('loss.txt', 'w'); 
tline = fgetl(fid); 
    while ischar(tline) 
    k = strfind(tline, 'Batch'); 
    % it's a valid log
    if ~isempty(k) 
        iter_start = k+6;
        iter_end = strfind(tline(k:end),',');
        iter = tline(iter_start:iter_end+k-2);
        %store test_loss
        loss_k = strfind(tline, 'loss'); 
        if ~isempty(loss_k) 
            loss_tart = loss_k + 7; 
            t_loss = tline(loss_tart : end);
            fprintf(test_loss, '%s\t%s\n', iter,t_loss); 
        end 
    end
     tline = fgetl(fid);
end
fclose(fid); 
test_loss=importdata('loss.txt');
if(~isempty(test_loss))
    figure(1)
    plot(test_loss(:,1),test_loss(:,2));
    title('test_loss vs.¡¯Batch')
end