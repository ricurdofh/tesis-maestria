function [OUT] = simlamdaH(Data, lamda)

clear D Class GAD1 GADNIC alfa OUT OUT1 GAD1;
global GAD1 MADkj MMAD
Class = lamda(1).clase;
[numdata numdes] = size(Data);
alfa = lamda(1).alfa;
for i=1:numdes
    Dp(:,i) = (Data(:,i)-lamda(1).minmax(1,i))/(lamda(1).minmax(2,i)-lamda(1).minmax(1,i)); %normalización de los datos
end

uno = find(Dp>1);
cer = find(Dp<0);
D = Dp;
D(uno) = 1;
D(cer) = 0;
D;

MMAD=[];
numclass = length(lamda)-1;
for i=1:numdata
    clear GAD 
    for k=1:numclass+1
        for j=1:numdes
          
            %% Calculo del MAD con función binomial
           if     lamda(1).MAD == 1 
           MADkj(k,j) = (lamda(k).ro(1,j)^D(i,j))*((1-lamda(k).ro(1,j))^(1-D(i,j))); %MAD de la clase k y descriptor j
          
          %% Calculo del MAD con función binomial-distancia Ref(TesisLamda pp92)
           elseif lamda(1).MAD == 2   
           MADkj(k,j) = ((lamda(k).ro(1,j)^D(i,j))*((1-lamda(k).ro(1,j))^(1-D(i,j))))/((D(i,j)^D(i,j))*((1-D(i,j))^(1-D(i,j))));
          
          %% Calculo del MAD con función binomial-ganancia Ref(Manual SALSA pp10)
           elseif lamda(1).MAD == 3   
           aa = log(lamda(k).ro(1,j)/(1-lamda(k).ro(1,j)));
           bb = 2*lamda(k).ro(1,j)-1;
           MADkj(k,j) = (aa/bb)*(lamda(k).ro(1,j)^D(i,j))*((1-lamda(k).ro(1,j))^(1-D(i,j))); %MAD de la clase k y descriptor j
          
           %% Calculo del MAD con función gaussiana
           elseif lamda(1).MAD == 4   
            na = (D(i,j)-lamda(k).ro(1,j))^2;
            nb = (lamda(k).desv(1,j))^2;
            if k~=numclass+1
            MADkj(k,j) = exp(-0.5*na/nb);
            else
            MADkj(k,j) = exp(-0.5);
            end
           end          
        end
        
        %% Calculo del GAD con operador min max
          if     lamda(1).GAD == 1
          GAD(k,1) = alfa*min(MADkj(k,:))+(1-alfa)*max(MADkj(k,:)); 
          
          %% Calculo del GAD con operador producto-probabilistico suma
          elseif lamda(1).GAD == 2
          [fil col] = size(MADkj);
          snorma = MADkj;
                for j=1:col-1 
                    snorma(:,j+1) = snorma(:,j)+snorma(:,j+1)-snorma(:,j).*snorma(:,j+1);    
                end
          tnorma = prod(MADkj(k,:));
          GAD(k,1) = alfa*tnorma+(1-alfa)*snorma(k,col);      

           %% Calculo del GAD  con operador Einstein
           elseif lamda(1).GAD == 3
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
           elseif lamda(1).GAD == 4
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
           elseif lamda(1).GAD == 5
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
           elseif lamda(1).GAD  == 6
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
%     indices_class = find(max(GAD)==GAD);
%     %indices_class = find(max(GAD(1:3,1)) == GAD(1:3,1));
%         if indices_class == numclass+1
%             OUT(i,1) = 0;
%         else
%             OUT(i,1) = Class(indices_class);
%         end
    GAD1(:,i) = GAD(:,1); 
    MMAD=vertcat(MMAD,MADkj);
end



        

%% Identificación del máximo gad para identifiación de la clase
%si method = 0 entonces calculo del GAD convencional

if lamda(1).mejora == 0
    
for i=1:numdata
    indices_class = find(max(GAD1(:,i))==GAD1(:,i));
        if indices_class == numclass+1
            OUT(i,1) = 0;
        else
            OUT(i,1) = Class(indices_class);
        end

end

%%si lamda.mejora = 1 entonces calculo del GAD adaptable a cada clase
else 


for k = 1:numclass
        P(:,k) = lamda(k).mdGAD(1:numclass,:);
        %S(:,k) = lamda(k).stGAD(1:numclass,:);
end

for n=1:numdata
    for j = 1: numclass
        for i = 1 : numclass
         %gg(i,1)= sqrt(abs(GAD1(i,n)^2-P(i,j)^2));
        %gg(i,1)= gaussmf(GAD1(i,n),[S(i,j) P(i,j)]);
        gg(i,1)= P(i,j)^GAD1(i,n)*(1-P(i,j))^(1-GAD1(i,n));
        end
        gad1(j,1) = sum(gg);
    end
    %indices_class = find(min(gad1) == gad1);
    indices_class = find(max(gad1) == gad1);
    OUT(n,1) = Class(indices_class);
end

%% COMPROBACIÓN NIC
for i=1:numdata
    indices_class = find(max(GAD1(1:numclass,i))==GAD1(1:numclass,i));
        if GAD1(indices_class,i) <= lamda(1).GADNIC(indices_class,1)
            OUT(i,1) = 0;% Class(indices_class);  %0;   para emociones cuando se quiere anular la nic
        end
        GAD1(numclass+1,i) = lamda(1).GADNIC(indices_class,1);
 end


end


% figure
% for n=1:numclass+1
%     
% plot (GAD1(n,:))
% hold on
% xlim([0 numdata ])
% end
% legend('GAD1','GAD2','GAD3','GAD4','GAD5','GAD6','GAD7','GAD8');
% 
% figure
% plot(OUT,'.r','MarkerSize', 11)
% a = axis;
% axis([a(1) a(2) 0 17]);
% set(gca, 'YTick', 0:17)
% hold on
% grid on
% 
% %plot(OUT1,'.')
% xlabel('Number of incoming data [N]');
% ylabel('Class [K]');
% 
% axis([0 numdata 0 numclass+1])

