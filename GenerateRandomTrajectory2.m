function [ X ] = GenerateRandomTrajectory2( simTime, dt, size, uniform, fromfile )
%   Generates random walking path with integer positions within size x size arena. 

%   INPUT
%   size          : dimensions of the size x size environment
%   simTime       : simulation time
%   dt            : time step

%   OUTPUT
%   X             : Generated trajectory

%   Example : GenerateRandomTrajectory( 5000, 5., 100. );

    %% Initializations
    %rng('shuffle','multFibonacci');
    prev_x=[0;0];
	if ~fromfile
        switch uniform
            case 0  % random trajectory
            sigmaVelocity = 5.; % SD of Gaussian velocity
            x=[0; 0];
            beta=0.95;
            dv=0.1; 
            animalSize=0.5;  % size of animal

            X = zeros(2,simTime / dt);               

            v=[0; 0];                               % Instant velocity
            simTicks = 0;                           % Simulation ticks
            t = 0;                                  % Time
            idx = 0;
            %% Simulation
            while (t < simTime)

                simTicks = simTicks+1;
                t = simTicks*dt;

                v=beta*v + sigmaVelocity*randn(2,1)*dv; %random change of speed
                x=x + v*dt;               %change of position  

                if sum((x>=size-animalSize)|(x<=animalSize))  % if find wall - change direction of motion
                  fi=rand*pi;
                  normv=sqrt(v'*v)*0.1;
                  v=normv*cos(fi)*[1; 1];
                  v(x>=size-animalSize)=-normv*sin(fi);
                  v(x<=animalSize)=normv*sin(fi);
                end      
                x=min(max(x,animalSize),size-animalSize);
                %x = mod(x,size)+[1;1];

                x=round(x);
                if (sum(x-prev_x))
                   idx=idx+1;
                    X(:,idx)=x;
                end;
            end
            dd=0;
        case 1 % uniform random locations
            rng('shuffle','combRecursive');
            X=mod(randi(size*2,2,round(simTime/dt)),size)+1; % this yields better filling at edges than X=randi(size,2,round(simTime/dt));
        case 2 % regular grid
            k=5;
            A = zeros(2,size*size);
            for i=1:size
                for j=1:size
                    A(:,i+(j-1)*size)=[i;j];
                end
            end
            X=repmat(A,1,k);
%             sz=size^2*k;
%             for i=1:sz
%                 x = randi(sz);
%                 y = randi(sz);
%                 t = X(:,x);
%                 X(:,x) = X(:,y);
%                 X(:,y) = t;
%                 
%             end
        end
        save path X
    else
        data = load('path');
        X = data.X;
    end % ~fromfile

    

  

  




end

