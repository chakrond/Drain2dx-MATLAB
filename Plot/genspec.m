% genspec.m: 
% generates design spectrum
clear all;
% Input data ..................
S=1.0; Tb=0.15; Tc=0.40; Td=2.0;   
ag=0.4; beta=0.2; q=4;       
ns=60; dT=0.04;            
% ..... end of input data .....

T=0; 
for i=1:ns 
  if T<=Tb
     Sd(i)=ag*S*(2/3+(T/Tb)*(2.5/q-2/3)); 
  end
  if (T<=Tc)&(T>Tb)
      Sd(i)=ag*S*2.5/q;  
      ymx=Sd(i)+0.1;
  end
  if (T<=Td)&(T>Tc)
     Sd(i)=ag*S*2.5*(Tc/T)/q;
     if Sd(i)<=beta*ag
        Sd(i)=beta*ag;
     end
  end
  if T>Td
     Sd(i)=ag*S*2.5*(Tc*Td/T^2)/q;  
     if Sd(i)<=beta*ag
       Sd(i)=beta*ag;
      end
  end
  Tp(i)=T; T=T+dT;  
end

% plot spectrum
xyax=[0 ns*dT 0 ymx];
fileplot='spec';
oneplot(Tp,Sd,'T (s)','Sd (g)',xyax)
print ('-dpsc2', fileplot);
% print spectrum values in file SPEC.DAT
fio=fopen('spec.dat','w'); 
for i=1:ns
  fprintf(fio,'%10.2f %9.5f \n', Tp(i), Sd(i));
end
fclose(fio)

