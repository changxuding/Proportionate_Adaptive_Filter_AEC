function [y] = pnlms(echo_file, far_file, out_file, taps, myu, dump_flag)
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
    sigma = 0.01;
    rou = 0.01;
    for i=1:out_len
        x = fliplr(far(i:i+taps-1));
        d = echo(i);
        out(i) = d - sum(x.*w);
        e = out(i);
        
        l_inf = max(abs(w));
        l_prime_inf = max(sigma, l_inf);
        g = max(rou*l_prime_inf, abs(w));
        g_norm = sum(g)/taps + eps;
        norm = x' * x + eps;
 
        w = w + g ./ g_norm .* myu .* e .* x ./ norm;
    end
    if(dump_flag)
        audiowrite(out_file, out, sr_echo);
    end
    y = erle(out, echo(1:out_len));
end
