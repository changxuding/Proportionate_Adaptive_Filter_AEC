function [y] = ipnlms(echo_file, far_file, out_file, taps, myu, alpha, dump_flag)
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
    % main
    for i=1:out_len
        x = fliplr(far(i:i+taps-1));
        d = echo(i);
        out(i) = d - x'*w;
        e = out(i);

        k = (1 - alpha)/(2*taps) + (1 + alpha)*(abs(w)/(2 * sum(abs(w)) + eps));
        norm = x'.*k'*x + eps;

        w = w + (myu .* e .* x .*k./ norm);
    end
    y = erle(out, echo(1:out_len));
    if(dump_flag)
        audiowrite(out_file, out, sr_echo);
    end
end

