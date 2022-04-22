function [estSig1, estSig2] = BSS(observeSignal, stepSize, numIterative, Fs)
% function BSS(folderName, stepSize, numIterative, timeAxis, Fs)

[size1, size2] = size(observeSignal);
timeAxis = size2;
y = zeros(size1, size2);     %yの初期化
yAns = zeros(size1, size2);
separMatrix = eye(size1);          %分離行列の初期値
identMatrix = eye(size1);          %単位行列

J = zeros(numIterative, 1);        %J(W)の初期化


for l = 1 : numIterative
    E = zeros(size1);    %Eの初期化
    y = separMatrix * observeSignal; 
    p = arrayfun(@tanh, y);
    R = (p* y.');
    E = E + R / timeAxis;
    k = arrayfun(@cosh, y) / pi;
    k = arrayfun(@log, 1 ./ k);
    J(l) = - sum(k, "all") / timeAxis - log(abs(det(separMatrix)));
    separMatrix = separMatrix - stepSize * (E - identMatrix) * separMatrix;  %W更新
end

for t = 1:timeAxis
    y(:, t) = separMatrix * observeSignal(:, t);  %分離
end

for t = 1 : timeAxis
    yAns(:, t) = diag((separMatrix \ (diag(y(:, t)))));
end

for i = 1 : size1
    fileName = "makesound" + num2str(i) + ".wav";
    audiowrite(fileName,yAns(i, :)/max(abs(yAns(i, :))),Fs);
end

estSig1 = yAns(1, :).';
estSig2 = yAns(2, :).';
% plot(J)