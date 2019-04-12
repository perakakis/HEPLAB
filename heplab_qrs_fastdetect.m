function qrs = heplab_qrs_fastdetect(ecg,fs)

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
        
        % algorithm=='2',
        regiao_de_busca=round(0.070*fs);
        
        %nivel em que o ecg filtrado ? considerado onda R
        ganho_limiar=0.15;
        
        %periodo de comparacao: 2 segundos
        limiar_comparacao=round(2*fs);
        
        %intervalo minimo entre marcacoes
        %antes estava trabalhando com 350ms
        salto_entre_pulsos=round(0.350*fs);
        
        %busca ondas R de 10 em 10 msecs
        salto_10msec=round(0.01*fs);
        
        %depois que acha o limiar, volta esse tanto
        volta_amostras=round(0.030*fs);
        
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %inicializacoes de variaveis
        tamanho=length(ecg);
        n=1;
        
        %inicia ondasr com 'empty'
        ondasr=[];
        qrs=[];
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Localiza as regioes onde estao as ondas R
        %
        
        %repete para cada onda R
        while n<tamanho,
            
            %calcula o limiar para a onda R atual, baseado nos proximos 2 segundos
            %com ganho de 0.2 nao sao marcadas algumas ondas R no
            %sinal 124, posicao 300-336
            if (n+limiar_comparacao)<=tamanho,
                limiar=ganho_limiar*max(abs(ecg_flt(n:n+limiar_comparacao)));
            else
                limiar=ganho_limiar*max(abs(ecg_flt(tamanho-limiar_comparacao:tamanho)));
            end
            
            %procura a regiao da onda R, se encontrar...
            if ( (ecg_flt(n)>limiar) & (n<tamanho) ),
                
                %guarda o indice inicial da regiao da onda R
                ondasr=[ondasr;n];
                
                %salta uns 200 msecs para evitar novos
                %disparos neste mesmo pulso.
                n=n+salto_entre_pulsos;
                
                %se nao foi encontrado, continua a busca de 10 em 10 msecs
            else
                n=n+salto_10msec;
                %n=n+1;
            end
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        % Localiza, na regiao, o pico da onda R
        %
        
        %inicia constantes e variaveis
        n=1;
        num_marcas=length(ondasr);
        marcas=[];
        
        %filtra o sinal com um passa altas para retirar a oscila??o da linha de base
        [B,A]= butter(4,1/(fs/2),'high'); %cria um butterworth de w0 = 1 Hz;
        ecg_flt=filtfilt(B,A,ecg); %filtfilt ? uma filtragem de fase zero
        
        %volta um trecho do sinal para buscar a onda R
        ondasr=ondasr-volta_amostras;
        if ondasr(1)<1,ondasr(1)=1;end;
        
        %localiza os picos das ondas R
        for i=1:num_marcas,
            
            %acha o pico da regiao
            if tamanho>=ondasr(i)+regiao_de_busca,
                [valor,marca]=max(abs(ecg_flt(ondasr(i):ondasr(i)+regiao_de_busca)));
            else
                [valor,marca]=max(abs(ecg_flt(ondasr(i):tamanho)));
            end
            
            %calcula a posi??o da marca e guarda o valor
            marca=marca+ondasr(i)-1;
            qrs=[qrs;marca];
            
        end
        
        waitbar (1)
        
        if isempty(ondasr),
            qrs=-1;
        end
        
        close (h)