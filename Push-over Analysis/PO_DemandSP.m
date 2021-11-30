% change directory
cd EQREC

% inputs an acceleration 
clc, clear
File = dir('*.AT2');
% **Input**
% if input is (g) scl = 9.81
g     = 9.81;


for i=1:length(File)
Filename{i} = File(i).name;
end
 
for j=1:length(Filename)
    
FileID = fopen(Filename{j});
exp1    = '[^ \f\n\r\t\v,;:]*';

    for i=1:4
        aline1   = fgetl(FileID);
    end

extract1         = regexp(aline1,exp1,'match');
DT{j}            = str2double(extract1(4));   
accel{j}         = fscanf(FileID, '%f',[1,inf]);
accel{j}         = accel{j}*g; 
time{j}          = linspace(0,DT{j}*length(accel{j}),length(accel{j}));
n{j}             = length(accel{j});

fclose('all'); 

end

nmin = min([n{:}]);

% The Newmark Beta method is used to find response spectra 
%  Average acceleration (gamma = 1/2 , beta = 1/4)
%inputs: acceleration, time step, and damping
%outputs: Period(P),Sd,Sv, acceleration, pseudo velocity and pseudo displacement

% input accel must be in cm/s2
for j=1:length(Filename)
    
    DAMP{j}  = 0.05;
    NPNTS{j} = max(size(accel{j})); %takes the size of the acceleration array


  for i=1:length(DAMP{j}) %damping loop (4dampings)
      fineness=3000; 
    for I= 4:2:fineness
        
        %Loop I From 4 to 1000 with a step of 2
       
        P = 1*I/100;    %Period P, is equal to  1/100Hz
        W = 2.*pi/P;    %Angular Velocity W
        WD = W*DAMP{j}(i);    %OMEGA D, NATURAL FREQUENCY OF DAMPED VIBRATION.
        DEN = W*W/4.+WD/DT{j}+1./DT{j}^2;
        D=zeros(1,NPNTS{j});  
        V=zeros(1,NPNTS{j});  
        A=accel{j}(1);                  
        DMAX=0;            
        VMAX=0;
        AMAX=0; 

    for N = 2:NPNTS{j}
       
        D(N)=(accel{j}(N)/4.+(1./DT{j}^2+WD/DT{j})*D((N-1))+(1./DT{j}+WD/2.)*V((N-1))+A((N-1))/4.)/DEN;
       
        A(N)=4.*(D(N)-D((N-1)))/DT{j}^2- 4.*V((N-1))/DT{j} - A((N-1));
        
        V(N)=V(N-1)+DT{j}*(A(N)+A(N-1))/2.;    
         
        %Check maximum
        if abs(D(N))> DMAX
            DMAX=abs(D(N));
        end
        if abs(V(N))> VMAX
            VMAX=abs(V(N));
        end
        if abs(A(N))> AMAX
            AMAX=abs(A(N));
        end
        
        %Find the maximum values of displacement, velocity, and
       
    end
    %40 loops
        PVMAX = DMAX*W;
        PAMAX= DMAX*W*W;
        AMAXG = AMAX/g; %g unit
        PAMAXG= PAMAX/g; %Peak   (g unit)
    
  
    PP{j}(i,(((I-4)/2)+1))=P;  %Period
    Pd{j}(i,(((I-4)/2)+1))=DMAX;
    Pv{j}(i,(((I-4)/2)+1))=VMAX;
    Pa{j}(i,(((I-4)/2)+1))=PAMAXG; %Pseudo Acceleration
    
   end
    
  end
end

%% Plot

figure

for j=1:length(Filename)
hold on
subplot(311),
plot(PP{j}(1,:),Pd{j}(1,:),'linew',2)
title(['Displacement Response Spectrum ( Damping ' num2str(DAMP{j}*100) '% )'  ])
xlabel('Period (s)')
ylabel('Displacement Response (m)')

% if j==length(Filename)
% legend(legends)
% grid
% end

end


for j=1:length(Filename)
hold on
subplot(312),
plot(PP{j}(1,:),Pv{j}(1,:),'linew',2)
title(['Velocity Response Spectrum ( Damping ' num2str(DAMP{j}*100) '% )'  ])
xlabel('Period (s)')
ylabel('Velocity Response (m/s)')
% if j==length(Filename)
% grid
% end

end


for j=1:length(Filename)
hold on
subplot(313),
plot(PP{j}(1,:),Pa{j}(1,:),'linew',2)
title(['Acceleration Response Spectrum ( Damping ' num2str(DAMP{j}*100) '% )'  ])
xlabel('Period (s)')
set(gca,'xlim',[0 5])
ylabel('Acceleration Response(g)'),
set(gca,'yticklabel',num2str(get(gca,'ytick')','%.4f'))
% if j==length(Filename)
% grid
% end

end

%% save file
cd ..
save ('DemandSP.mat','Pa','Pd')

