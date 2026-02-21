
s = tf('s')';
w = 2*pi*100;
apf = (s/w-1)/(s/w+1);

figure; bode(apf); grid on