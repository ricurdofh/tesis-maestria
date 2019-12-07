%% PRUEBA LAMDA-HAD
global DATA CLASS MMAD
data1 = dlmread('../Datasets/winequality-white.csv', ';',1,0);

% 1. [1, 2, 3, 5, 8, 9, 10]
featureset1 = data1(:,[1 2 3 5 8 9 10]);

% 2. [2,  6,  8, 11]
featureset2 = data1(:,[2 6 8 11]);

% 3. [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
featureset3 = data1(:,[1 2 3 4 5 6 7 8 9 10 11]);

% 4. [2, 5, 6, 7, 8, 9, 11]
featureset4 = data1(:,[2 5 6 7 8 9 11]);

% 5. [1, 2, 3, 4, 5, 6, 7, 8]
%featureset5 = data1(:,[1 2 3 4 5 6 7 8]);

CLASS = data1(:,12);

    trIdx = [1:2449];
    teIdx = [2450:4898];

%MODEL1 = trainlamdaH(featureset1(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M1 = simlamdaH(featureset1(teIdx,:), MODEL1);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results1_WQ.csv', OUT_M1);

%MODEL2 = trainlamdaH(featureset2(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M2 = simlamdaH(featureset2(teIdx,:), MODEL2);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results2_WQ.csv', OUT_M2);

%MODEL3 = trainlamdaH(featureset3(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M3 = simlamdaH(featureset3(teIdx,:), MODEL3);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results3_WQ.csv', OUT_M3);

MODEL4 = trainlamdaH(featureset4(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
OUT_M4 = simlamdaH(featureset4(teIdx,:), MODEL4);% OUTM tiene los valores predichos por LAMDA-HAD

csvwrite('results4_WQ.csv', OUT_M4);

%MODEL5 = trainlamdaH(featureset5(trIdx,:),CLASS(trIdx,:),0.9,1,2,3);
%OUT_M5 = simlamdaH(featureset5(teIdx,:), MODEL5);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results5_WQ.csv', OUT_M5);