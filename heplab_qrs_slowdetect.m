function qrs = heplab_qrs_slowdetect(ecg,fs)

h = waitbar(1/2,'QRS detection in progress...');

%filtra em 17Hz
Q = 3;
gain = 1.2;
w0=17.5625*2*pi;
NUM=gain*w0^2;
DEN=[1,(w0/Q),w0^2];
[B,A] = bilinear(NUM,DEN,fs);

ecg_flt = filtfilt(B,A,ecg);

%derivada
ecg_flt=filter([1 -1],1,ecg_flt);

%passa baixas 30 Hz (para nao enriquecer ruido)
[B,A]=butter(8,30/(fs/2));
ecg_flt=filter(B,A,ecg_flt);
ecg_flt = ecg_flt /max(abs(ecg_flt)); %gain

%eleva ao quadrado
ecg_flt=ecg_flt.^2;

%integrador (janela movel)
N=round(0.150*fs); ecg_flt=1/N*filter(ones(1,N),1,ecg_flt);

%localiza, dentro das picos do sinal integrado, o ponto de maximo do sinal ecg

% algorithm=='1',
salto_entre_pulsos=0.200*fs;
area_limiar=2*fs;
volta_amostras=0.160*fs;

tamanho=length(ecg);
ecg_temp=-1500*ones(tamanho,1);
ecg_aux=ecg;
n=1;
qrs=[];

%repete para cada onda R
while n<tamanho,
    maximo=0;
    indice=0;
    
    %calcula o limiar para a onda R atual, baseado nos proximos 2 segundos
    %com ganho de 0.2 nao sao marcadas algumas ondas R no sinal 124, posicao 300-336
    if (n+area_limiar)<=tamanho,
        limiar=0.15*max(abs(ecg_flt(n:n+area_limiar)));
    else
        limiar=0.15*max(abs(ecg_flt(tamanho-area_limiar:tamanho)));
    end
    
    %procura a regiao da onda R
    while ( (ecg_flt(n)>limiar) & (n<tamanho) ),        
        %encontra e memoriza a localizacao do ponto de maximo dentro dessa regiao
        if abs(ecg_flt(n))>maximo,
            maximo=abs(ecg_flt(n));
            indice=n;
        end
        n=n+1;
        
    end
    
    %se for encontrado o ponto de maximo, marca em um vetor a localizacao
    if indice~=0,
        ecg_temp(indice)=1;
        n=indice+salto_entre_pulsos; % salta 200 msec para evitar novos disparos neste mesmo pulso.
        %n=n+150;    % salta 150 amostras para evitar novos disparos neste mesmo pulso.
        
        %se nao foi encontrado, continua a busca na proxima amostra
    else
        n=n+1;
    end
    
end

%calcula a media em regioes de 1 segundo (melhor fazer um passa baixas)
for kk=1:fs:tamanho-fs,
    ecg(kk:kk+fs-1) =...
        ecg(kk:kk+fs-1) - mean(ecg(kk:kk+fs-1));
end

atraso=volta_amostras; %volta 130ms e busca o maximo ate o ponto da marcacao
n=1;
waitbar (2/2)
%busca no vetor de marcacao as regioes ondem estao as
%onda R e encontra o ponto de maximo no vetor ECG
while n<=tamanho,
    maximo=0;
    indice=0;
    
    %se encontrar uma marcacao entre neste laco
    while ( (ecg_temp(n)==1) & (n<=tamanho) ),
        
        %volta, se possivel, at? 130ms do sinal para a busca da onda R
        if (n-atraso)>0,
            inicio=n-volta_amostras;
        else
            inicio=1;
        end
        
        %localiza o pico na regiao de 130ms e memoriza no vetor ondar
        [maximo,indice]=max(abs(ecg(inicio:n)));
        indice=fix(inicio+indice-1);
        qrs=[qrs;indice];
        n=n+1;
    end
    n=n+1;
end

if isempty(qrs),
    qrs=-1;
end

close (h)