function y = erle(e, x)
    Pd = filter(1,[1,-0.98],x.^2);
    Pe = filter(1,[1,-0.98],e.^2);
    y_tmp = 10*log10(Pd./(Pe+eps));
    if(1)
        y = sum(y_tmp)/length(y_tmp);
    elseif(0)
        frame_len = 128;
        block_num = floor(length(y_tmp)/frame_len);
        y = zeros(block_num,1);
        for i=1:block_num
            y(i) = sum(y_tmp((i-1)*frame_len+1:i*frame_len))/frame_len;
        end
    else
        y = y_tmp;
    end
end

