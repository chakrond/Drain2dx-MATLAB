clear all
fclose('all')

% generates design spectrum

% Input data ..................
S=1.0; Tb=0.15; Tc=0.40; Td=2.0;   
ag=0.4; beta=0.2; n=1.0;      
ns=500; dT=0.005;
% ..... end of input data .....

T=0; 
for i=1:ns 
  if T<=Tb
     EC8Sa(i)=ag*S*(1 + ( (T/Tb)*((n*2.5)-1) ) ); 
  end
  if (T<=Tc)&(T>Tb)
      EC8Sa(i)=ag*S*n*2.5;  
      ymx=EC8Sa(i)+0.1;
  end
  if (T<=Td)&(T>Tc)
     EC8Sa(i)=ag*S*n*2.5*(Tc/T);
     if EC8Sa(i)<=beta*ag
        EC8Sa(i)=beta*ag;
     end
  end
  if T>Td
     EC8Sa(i)=ag*S*n*2.5*(Tc*Td/T^2);  
     if EC8Sa(i)<=beta*ag
       EC8Sa(i)=beta*ag;
      end
  end
  EC8Tp(i)=T; T=T+dT;  
end

EC8Sd = (EC8Sa*9.81)./(2*pi./EC8Tp).^2; 
plot(EC8Sd,EC8Sa)
save('EC8Sp.mat')

