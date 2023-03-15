function [y] = impnlms(echo_file, far_file, out_file, taps, myu, dump_flag)
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
    w_myu_law = zeros(taps, 1);
    lambda = 0.1;
    xi_w = 0.96;

    for i=1:out_len
        x = fliplr(far(i:i+taps-1));
        d = echo(i);
        out(i) = d - sum(x.*w);
        e = out(i);
        for j=1:taps
            if(abs(w(j))<0.005)
                w_myu_law(j) = 400*abs(w(j));
            else
                w_myu_law(j) = 8.51*abs(w(j)) + 1.96;
            end
                
        end
        w_l1 = sum(abs(w_myu_law));
        w_l2 = sqrt(sum(abs(w_myu_law).^2))+eps;
        xi_w = (1-lambda)*xi_w + lambda*taps/(taps-sqrt(taps))*(1-w_l1/(sqrt(taps)*w_l2));
        alpha = 2*xi_w - 1;
        
        k = (1 - alpha)/(2*taps) + (1 + alpha)*(abs(w_myu_law)/(2 * sum(abs(w_myu_law)) + eps));
        norm = x'.*k'*x + eps;

        w = w + (myu .* e .* x .*k./ norm);
    end
    if(dump_flag)
        audiowrite(out_file, out, sr_echo);
    end
    y = erle(out, echo(1:out_len));
end