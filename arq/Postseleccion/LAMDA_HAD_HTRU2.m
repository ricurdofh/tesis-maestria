%% PRUEBA LAMDA-HAD
global DATA CLASS MMAD
load ../Datasets/HTRU_2.csv;
data1 = HTRU_2;

% 1. [3, 4, 6, 7]
featureset1 = data1(:,[3 4 6 7]);

% 2. [2, 3, 6]
featureset2 = data1(:,[2 3 6]);

% 3. [1, 3, 4, 6]
featureset3 = data1(:,[1 3 4 6]);

% 4. [2, 3, 6]
featureset4 = data1(:,[2 3 6]);

% 5. [1, 2, 3, 4, 5, 6, 7, 8]
%featureset5 = data1(:,[1 2 3 4 5 6 7 8]);

CLASS = data1(:,9);

    trIdx = [1:8949];
    teIdx = [8950:17898];

%MODEL1 = trainlamdaH(featureset1(trIdx,:),CLASS(trIdx,:),0.1,1,1,5);
%OUT_M1 = simlamdaH(featureset1(teIdx,:), MODEL1);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results1_HTRU2.csv', OUT_M1);

%MODEL2 = trainlamdaH(featureset2(trIdx,:),CLASS(trIdx,:),0.1,1,1,5);
%OUT_M2 = simlamdaH(featureset2(teIdx,:), MODEL2);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results2_HTRU2.csv', OUT_M2);

%MODEL3 = trainlamdaH(featureset3(trIdx,:),CLASS(trIdx,:),0.1,1,1,5);
%OUT_M3 = simlamdaH(featureset3(teIdx,:), MODEL3);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results3_HTRU2.csv', OUT_M3);

MODEL4 = trainlamdaH(featureset4(trIdx,:),CLASS(trIdx,:),0.1,1,1,5);
OUT_M4 = simlamdaH(featureset4(teIdx,:), MODEL4);% OUTM tiene los valores predichos por LAMDA-HAD

csvwrite('results4_HTRU2.csv', OUT_M4);

%MODEL5 = trainlamdaH(featureset5(trIdx,:),CLASS(trIdx,:),0.1,1,1,5);
%OUT_M5 = simlamdaH(featureset5(teIdx,:), MODEL5);% OUTM tiene los valores predichos por LAMDA-HAD

%csvwrite('results5_HTRU2.csv', OUT_M5);