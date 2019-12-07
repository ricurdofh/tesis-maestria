%% PRUEBA LAMDA-HAD
global DATA CLASS MMAD
%load ../Datasets/winequality-white.csv;
data1 = dlmread('../Datasets/winequality-white.csv', ';',1,0)
%data1 = winequality-white;

% 1. [2,  4,  5,  6,  7,  8, 11]
featureset1 = data1(:,[2 4 5 6 7 8 11]);

% 2. [2,  5,  6,  8, 11]
featureset2 = data1(:,[2 5 6 8 11]);

% 3. [2,  6,  7,  8,  10, 11]
featureset3 = data1(:,[2 6 7 8 10 11]);

% 4. [2,  6,  8, 11]
featureset4 = data1(:,[2 6 8 11]);

% 5. [1, 2, 3, 5, 8, 9, 10]
featureset5 = data1(:,[1 2 3 5 8 9 10]);

% 6. [2, 3, 5, 8, 9]
featureset6 = data1(:,[2 3 5 8 9]);

% 7. [1,  6,  7,  9, 11]
featureset7 = data1(:,[1 6 7 9 11]);

% 8. [1,  4,  7,  9, 11]
featureset8 = data1(:,[1 4 7 9 11]);

CLASS = data1(:,12);

    trIdx = [1:2449];
    teIdx = [2450:4898];

%MODEL1 = trainlamdaH(featureset1(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M1 = simlamdaH(featureset1(teIdx,:), MODEL1);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results1_WQ.csv', OUT_M1);

MODEL2 = trainlamdaH(featureset2(trIdx,:),CLASS(trIdx,:),0.1,1,4,3);
OUT_M2 = simlamdaH(featureset2(teIdx,:), MODEL2);% OUTM tiene los valores predichos por LAMDA-HAD

csvwrite('results2_WQ.csv', OUT_M2);

%MODEL3 = trainlamdaH(featureset3(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M3 = simlamdaH(featureset3(teIdx,:), MODEL3);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results3_WQ.csv', OUT_M3);

%MODEL4 = trainlamdaH(featureset4(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M4 = simlamdaH(featureset4(teIdx,:), MODEL4);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results4_WQ.csv', OUT_M4);

%MODEL5 = trainlamdaH(featureset5(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M5 = simlamdaH(featureset5(teIdx,:), MODEL5);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results5_WQ.csv', OUT_M5);

%MODEL6 = trainlamdaH(featureset6(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M6 = simlamdaH(featureset6(teIdx,:), MODEL6);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results6_WQ.csv', OUT_M6);

%MODEL7 = trainlamdaH(featureset7(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M7 = simlamdaH(featureset7(teIdx,:), MODEL7);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results7_WQ.csv', OUT_M7);

%MODEL8 = trainlamdaH(featureset8(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M8 = simlamdaH(featureset8(teIdx,:), MODEL8);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results8_WQ.csv', OUT_M8);