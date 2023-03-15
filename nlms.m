function [y] = nlms(echo_file, far_file, out_file, taps, myu, dump_flag)
    [echo, sr_echo] = audioread(echo_file);
    [far, sr_far] = audioread(far_file);
    if(sr_echo~=sr_far)
        error('echo signal sampling rate must be equal to far signal');
    end

    % para
    min_len = min(length(echo),length(far));
    out_len = min_len-taps;
    out = zeros(out_len, 1);
    w = zeros(taps, 1);
    for i=1:out_len
        x = fliplr(far(i:i+taps-1));
        d = echo(i);
        out(i) = d - sum(x.*w);
        e = out(i);
        norm = sum(x.*x) + eps;
        w = w + myu.*e.*x ./ norm;
    end
    y = erle(out, echo(1:out_len));
    if(dump_flag)
        audiowrite(out_file, out, sr_echo);
    end
end

