function [lamda] = trainlamdaH(DATA,CLASS,alfa,MEJORA,MADc,GADc)
global minmax;

clear Datai Classi numdes numdata numclass minmax Class Indices D lamda

Datai = DATA;
Classi = CLASS;
 %save 'datosprueba.dat' DP -ascii

[numdata numdes] = size(Datai); % determinar numero de descriptores

%% Valores minimos y máximos y normalización
for i=1:numdes
    minmax(i,:) = [min(Datai(:,i)) max(Datai(:,i))]; % valores minimos y máximos de los descriptores
    D(:,i) = (Datai(:,i)-min(Datai(:,i)))/(max(Datai(:,i))-min(Datai(:,i))); %normalización de los datos
end


%% Separar clases
Class(:,1) = unique(Classi); % identifico el número de clases existentes
% for i=1:length(Class)
%     Class(i,2) = i;
%   end
[numclass non] = size(Class);

for k=1:numclass
    indices = find(Class(k)==Classi);
    if length(indices)>1
        lamda(k).ro = [mean(D(indices,:))];
    else
        lamda(k).ro = D(indices,:);
    end
    lamda(k).clase = Class;
    lamda(k).indices = indices;
    lamda(k).desv = [std(D(indices,:))];
    lamda(k).minmax = minmax';
    lamda(k).alfa = alfa;
    lamda(k).mejora = MEJORA;
    lamda(k).MAD = MADc;
    lamda(k).GAD = GADc;
end
lamda(k+1).ro = [0.5*ones(1,numdes)];
lamda(k+1).desv = [0.25*ones(1,numdes)];



if MEJORA == 1
    
    for i=1:numdata
    clear GAD 
    for k=1:numclass+1
        for j=1:numdes
            
          %% Calculo del MAD con función binomial
          if     MADc == 1 
          MADkj(k,j) = (lamda(k).ro(1,j)^D(i,j))*((1-lamda(k).ro(1,j))^(1-D(i,j))); %MAD de la clase k y descriptor j
          
          %% Calculo del MAD con función binomial-distancia Ref(TesisLamda pp92)
          elseif MADc == 2  
          MADkj(k,j) = ((lamda(k).ro(1,j)^D(i,j))*((1-lamda(k).ro(1,j))^(1-D(i,j))))/((D(i,j)^D(i,j))*((1-D(i,j))^(1-D(i,j))));
          
          %% Calculo del MAD con función binomial-ganancia Ref(Manual SALSA pp10)
          elseif MADc == 3
          aa = log(lamda(k).ro(1,j)/(1-lamda(k).ro(1,j)));
          bb = 2*lamda(k).ro(1,j)-1;
          MADkj(k,j) = (aa/bb)*(lamda(k).ro(1,j)^D(i,j))*((1-lamda(k).ro(1,j))^(1-D(i,j))); %MAD de la clase k y descriptor j
          
          %% Calculo del MAD con función gaussiana
          elseif MADc == 4
            aa = (D(i,j)-lamda(k).ro(1,j))^2;
            bb = (lamda(k).desv(1,j))^2;
            if k~=numclass+1
            MADkj(k,j) = exp(-0.5*aa/bb);
            else
            MADkj(k,j) = exp(-0.5);
            end
              MADkj(k,j) = exp(-0.5*((D(i,j)-lamda(k).ro(1,j))^2)/((lamda(k).desv(1,j))^2));
          end
        end
        
          
          %% Calculo del GAD con operador min max
          if     GADc == 1
          GAD(k,1) = alfa*min(MADkj(k,:))+(1-alfa)*max(MADkj(k,:)); 
          
          %% Calculo del GAD con operador producto-probabilistico suma
          elseif GADc == 2
          [fil col] = size(MADkj);
          snorma = MADkj;
                for j=1:col-1 
                    snorma(:,j+1) = snorma(:,j)+snorma(:,j+1)-snorma(:,j).*snorma(:,j+1);    
                end
          tnorma = prod(MADkj(k,:));
          GAD(k,1) = alfa*tnorma+(1-alfa)*snorma(k,col);      

           %% Calculo del GAD  con operador Einstein
          elseif GADc == 3 
          [fil col] = size(MADkj);
           tnorma = MADkj;
           snorma = MADkj;       
           for n=1:fil
                for j=1:col-1 
                    tnorma(n,j+1) = (tnorma(n,j)*tnorma(n,j+1))/(2-((tnorma(n,j)+tnorma(n,j+1))-(tnorma(n,j)*tnorma(n,j+1))));
                    snorma(n,j+1) = (snorma(n,j)+snorma(n,j+1))/(1+(snorma(n,j)*snorma(n,j+1)));
                end
           end
          GAD(k,1) = alfa*tnorma(k,col)+(1-alfa)*snorma(k,col);  
                  
           %% Calculo del GAD  con operador Hamacher producto-suma
           elseif GADc == 4
           [fil col] = size(MADkj);
            tnorma = MADkj;
            snorma = MADkj;        
            p = 0;
           for n=1:fil
                for j=1:col-1 
                    tnorma(n,j+1) = (tnorma(n,j)*tnorma(n,j+1))/(p+(1-p)*((tnorma(n,j)+tnorma(n,j+1))-(tnorma(n,j)*tnorma(n,j+1))));
                    snorma(n,j+1) = (snorma(n,j)+snorma(n,j+1)-(snorma(n,j)*snorma(n,j+1))-(1-p)*(snorma(n,j)*snorma(n,j+1)))/(1-(1-p)*(snorma(n,j)*snorma(n,j+1)));
                end
           end
          GAD(k,1) = alfa*tnorma(k,col)+(1-alfa)*snorma(k,col);   

           %% Calculo del GAD  con operador Dombi
           elseif GADc == 5
           [fil col] = size(MADkj);
            tnorma = MADkj;
            snorma = MADkj;   
           p = 1;
           for n=1:fil
                for j=1:col-1 
                    tnorma(n,j+1) = 1/(1+(((1/tnorma(n,j))-1)^( p)+((1/tnorma(n,j+1))-1)^( p))^(1/( p)));
                    snorma(n,j+1) = 1/(1+(((1/snorma(n,j))-1)^(-p)+((1/snorma(n,j+1))-1)^(-p))^(1/(-p)));
                end
           end
           GAD(k,1) = alfa*tnorma(k,col)+(1-alfa)*snorma(k,col); 
           %% Calculo del GAD  con operador Schweizer2
           elseif GADc == 6
            [fil col] = size(MADkj);
            tnorma = MADkj;
            snorma = MADkj;   
           p = 2;
           for n=1:fil
                for j=1:col-1 
                    tnorma(n,j+1) = 1/(((1/tnorma(n,j)^p)+((1/tnorma(n,j+1)^p))-1)^(1/p));
                    snorma(n,j+1) = 1-(1/(((1/(1-snorma(n,j))^p)+(1/(1-snorma(n,j+1)^p))-1)^(1/p)));
                end
           end
           GAD(k,1) = alfa*tnorma(k,col)+(1-alfa)*snorma(k,col); 
           
          end          
    end
    GAD1(:,i) = GAD(:,1) ;
    end

for k=1:numclass
     if length(lamda(k).indices)>1
    lamda(k).mdGAD = (mean(GAD1(:,lamda(k).indices)'))';
     else
        lamda(k).mdGAD = GAD1(:,lamda(k).indices);
     end
    
    end
%% Calculo del GAD adaptable a cada clase 
for k=1:numclass
    
     aux = GAD1(1:numclass,lamda(k).indices(1));
     m1 = find(max(aux) == aux);
     aux(m1,1) = 0;
     m2 = find(max(aux) == aux); 
     aux(m2,1) = 0;
     m3 = find(max(aux) == aux); 
     aux(m3,1) = 0;
     m4 = find(max(aux) == aux); 
     
%       GADNIC(k,1) = mean(mean((GAD1([m1 m2 m3 m4],lamda(k).indices))'));
%     para pozo
    
       GADNIC(k,1) = mean(mean((GAD1(1:numclass,lamda(k).indices))'));% emo
    GAD1(numclass+1,lamda(k).indices) = GADNIC(k,1); 
end
    lamda(1).GADNIC = GADNIC;
else
    lamda(1).GADNIC = 0;
    
end






    
