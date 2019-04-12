function handle=heplab_ecgplot(signal, srate, qrs, sec_ini, handle, winsec)
% PLOTAecg plota um trecho do ecg indicado
% usage: handle=heplab_ecgplot(ecg, eventos, qrs, indicedossec_ini, signaltype,handle,winsec,main_window)
% 	ecg=vetor com as amostras
%  eventos=vetor com os indices dos eventos
%  qrs=vetor com a onda R marcada
%	sec_ini=um numero entre 0 e o numero de sec_ini
%  signaltype=pode ser 'ecg' ou 'rsp'
%  handle=handle para o axes onde foi plotado
%  main_window=handle da win principal

%apaga o plot anterior

if handle~=-1,
    delete(handle);
end

%pega as constantes (taxa de amostragem)

%titulo='Batimento Cardiaco';
% position=[80 220 890 470];
position=[0.05 0.3 0.9 0.7];

%cria o eixo inteiro do time
time=0:1/srate:(length(signal)-1)/srate;

%calcula numero de sec_ini e de amostras do segmento
sec_ini=sec_ini+1/srate;
win=floor(winsec*srate);

%insere um zero depois da ultima amostra
signal=[signal;0];

%delimita os sinais ? regiao plotada
ss = round(sec_ini*srate);
ecg = signal;
signal = signal(ss:ss+win);

%cria eixo do time
t=sec_ini-1/srate:1/srate:sec_ini+winsec-1/srate;

%cria o handle da regiao do plot
handle=axes('Units','normalized','fontunits','normalized','position',position);

%plota o ecg, os eventos e a marcacao R-R
if isempty(qrs),
    plot(t,signal,'b-');
    r_ind=[];
else
    r_ind=qrs; qrs=-1500*ones(length(ecg),1);
    qrs(r_ind)=ecg(r_ind);
    qrs=qrs(ss:ss+win);
    
    plot(t,signal,'b-',t,qrs,'ro');
end

%mostra os indices dos intervalos
[RRinterval, RRtimes]=heplab_calculate_RR(r_ind,length(ecg)*1/srate,srate);
if RRinterval(1)~=-1,
    
    %encontra ondas R dentro da win
    display=find(RRtimes>=t(1) & RRtimes<=t(length(t)));
    r_ind_aux=r_ind(display);
    RRtimes=RRtimes(display);
    RRinterval=RRinterval(display);
    
    %so mostra o valor dos intervalos para wins de 10 sec_ini ou menos
    if winsec <=10,
        for i=1:length(RRinterval),
            xRR=RRtimes(i);
            yRR=ecg(r_ind(display(1)+i));
            RRtext=sprintf([  num2str(RRinterval(i))  '[' num2str(display(1)+i-1) ']-'  ]);
            h=text(xRR,yRR,RRtext);
            set(h,'fontname','Courier New','fontsize',12,'HorizontalAlignment','right','verticalalignment','middle')

        end
    end
end

grid
axis([t(1) t(length(t)) -1.1 1.1])
xlabel('time (seconds)','fontsize',12)
ylabel('normalized amplitude','fontsize',12)