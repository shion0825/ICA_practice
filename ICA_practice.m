clc; close all; clear;


[s1, f1] = audioread("speech_female.wav");    % 1つめの信号
[s2, f2] = audioread("speech_male.wav");    % 2つめの信号

info1 = audioinfo("speech_female.wav"); %1つめの信号の情報
info2 = audioinfo("speech_male.wav");   %2つめの信号の情報

time = info1.Duration;  % 信号の時間長
Fs = f1;                % サンプリング周波数
timeAxis = time * Fs;

s = [s1.'; s2.'];       %s行列
a = [2, 0.5; 1.4, 1.6]; %

x = a * s;              %分離前の信号の行列

y = zeros(size(x));     %yの初期化
yAns1 = zeros(size(x)); %分離後のy
yAns2 = zeros(size(x));
W = eye(2, 2);          %Wを単位行列とする
I = eye(2, 2);          %単位行列I
p = zeros(2, 1);        %pの初期化

L = 30;                 %Lの設定
myu = 0.5;              %μの設定
J = zeros(L, 1);        %J(W)の初期化


for l = 1 : L
    E = zeros(2, 2);    %Eの初期化
    for t = 1 : timeAxis
        y(:, t) = W * x(:, t); 
        p = [tanh(y(1, t));tanh(y(2,t))];
        R = (p*y(:, t).');
        E = E + R / timeAxis; 
        J(l) = J(l) -(log(sech(y(1, t))/pi())+log(sech(y(2, t))/pi()))/timeAxis;
    end
    J(l) = J(l)-log(abs(det(W)));
    W = W - myu * (E - I) * W;  %W更新
end

for t = 1:timeAxis
    y(:, t) = W * x(:, t);  %分離
end

for t = 1 : timeAxis
    yAns1(:, t) = W \ [y(1, t); 0];
    yAns2(:, t) = W \ [0; y(2, t)];
end