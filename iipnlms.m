function [y] = iipnlms(echo_file, far_file, out_file, taps, myu, dump_flag)
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
    % pnlms para
    sigma = 0.01;
    rou = 0.01;
    % iipnlms para
    alpha = zeros(taps,1);
    alpha1 = -0.5;
    alpha2 = 0.5;
    gamma = 0.1;
    % main
    for i=1:out_len
        x = fliplr(far(i:i+taps-1));
        d = echo(i);
        out(i) = d - x'*w;
        e = out(i);

        l_inf = max(abs(w));
        l_prime_inf = max(sigma, l_inf);
        g = max(rou*l_prime_inf, abs(w));
        g_norm = sum(g)/taps + eps;
        gk = g/g_norm;
        
        % logic for update alpha
        thres = gamma*max(gk);
        for j = 1:taps
            if(gk(j)>thres)
                alpha(j) = alpha1;
            else
                alpha(j) = alpha2;
            end
        end
        k = (1-alpha)/2 + (1+alpha).*gk;
        
        norm = x' * x + eps;
        w = w + k .* myu .* e .* x ./ norm;
    end
    y = erle(out, echo(1:out_len));
    if(dump_flag)
        audiowrite(out_file, out, sr_echo);
    end
end
