function [RRinterval, RRtimes]=heplab_calculate_RR(qrs,signal_sec,srate)
%usage: [RRinterval, RRtimes]=heplab_calculate_RR(qrs,signal_sec);

RRtimes=0;
RRinterval=0;

if length(qrs)>1,

	%cria o eixo do time
   time=0:1/srate:signal_sec-1/srate;

   %transforma as marcacoes em msec
   RRtimes=round(1000*time(qrs));
      
   %calcula os intervalos R-R
   RR=RRtimes(1:length(RRtimes)-1);
   RR1=RRtimes(2:length(RRtimes));
   RRinterval=RR1-RR;
   
   %transforma em segundos (a primeira marcacao nao ? intervalo)
	RRtimes=RRtimes(2:length(RRtimes))/1000;
   
   %arredonda os intervalos R-R
   RRinterval=round(RRinterval);

else   
   RRinterval=-1;
   RRtimes=-1;
end

