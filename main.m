clear; 
clc;

echo_path = './st/qingyinyue/echo.wav';
far_path = './st/qingyinyue/far.wav';

nlms_out_path = './out_nlms.wav';


dump_flag = 0;
taps = 256;
myu = 0.5;
alpha_ipnlms = -0.5;
% main
% erle_lms = lms(echo_path,far_path,lms_out_path,taps,myu,dump_flag);
erle_nlms = nlms(echo_path,far_path,nlms_out_path,taps,myu,dump_flag);
% erle_pnlms = pnlms(echo_path,far_path,pnlms_out_path,taps,myu,dump_flag);
% erle_ipnlms = ipnlms(echo_path,far_path,ipnlms_out_path,taps,myu,alpha_ipnlms,dump_flag);
% erle_iipnlms = iipnlms(echo_path,far_path,iipnlms_out_path,taps,myu,dump_flag);
% erle_mpnlms = mpnlms(echo_path,far_path,mpnlms_out_path,taps,myu,dump_flag);
% erle_impnlms = impnlms(echo_path,far_path,mpnlms_out_path,taps,myu,dump_flag);

% plot erle
% erle_len = length(erle_lms);
% x = linspace(0, erle_len/16000, erle_len);
% plot(x(1:100), erle_lms(1:100), x(1:100),erle_nlms(1:100), x(1:100),erle_pnlms(1:100), x(1:100),erle_ipnlms(1:100), x(1:100),erle_iipnlms(1:100));
% legend('lms','nlms','pnlms','ipnlms', 'iipnlms');