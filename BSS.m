function BSS(observeSignal, stepSize, numIterative, timeAxis, Fs)
% function BSS(folderName, stepSize, numIterative, timeAxis, Fs)

[size1, size2] = size(observeSignal);
y = zeros(size1, size2);     %yの初期化
yAns = zeros(size1, size2);
separMatrix = eye(size1);          %分離行列の初期値
identMatrix = eye(size1);          %単位行列

J = zeros(numIterative, 1);        %J(W)の初期化


for l = 1 : numIterative
    E = zeros(size1);    %Eの初期化
    for t = 1 : timeAxis
        y(:, t) = separMatrix * observeSignal(:, t); 
        p = arrayfun(@tanh, y(:, t));
        R = (p* y(:, t).');
        E = E + R / timeAxis; 
        J(l) = J(l) -(log(sech(y(1, t))/pi())+log(sech(y(2, t))/pi()))/timeAxis;
    end
    J(l) = J(l)-log(abs(det(separMatrix)));
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
plot(J)