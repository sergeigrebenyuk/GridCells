%% Sim.m
% Simulation flow
% (c) Stepanyuk and Grebenyuk, 2015

% Flags
global pathFromFile
global filedsFromFile
global nbFromFile

global pathUniform      % "Trajectory" is uniformly distributed discrete dots
global pcUniform        % Place cells are generated at nodes of regular mesh

% Simulation vars
global simulationTime   % Simulation time (sec)
global deltaT           % Time step in the time grid
global pcSize            % Environment size
global gcSize           % Grid cell array
global pcNum            % Place cells number

global Path             % Trajectory of the animal
global PC               % place cells in matrix form
global PCD              % place cells as a list of coordinates (for plotting)
global GC GCm A         % Grid cells in matrix form
global W                % Weights of grid cells synapses
global M                % Weights of grid cells lateral synapses
global M_factor
global mRad;
global WNoise           % Noise factor for PC-to-GC synapse weights
global WMin             % Minimal weight of PC-to-GC synapses
global fig_handle;      % handle to GUI panel
global hndl;            % handles structure of fig_handle (filled upon figure loading)
global Reset Stop;      % state variables
global simState;        
global Activations;     % Holds activated place cells for each trajectory point

global pfStruct;        % Place field parameters. See description of struct below

% Generate random walkking path of the animal
Path = GenerateRandomTrajectory2( simulationTime, deltaT, pcSize,pathUniform, pathFromFile);

% Generate place cells and evenly distribute them over the arena
[PC, PCD]  = GenerateRandomPC(pcNum, pcSize, pcUniform, filedsFromFile);
DrawPathAndPlace(hndl,Path,PCD,pcSize);

% Calculate place cells activations at each trajectory position
% 'Activations' holds sets of activated place cells for each trajectory point
Activations = pcActivations(PC,pfStruct,Path,pcUniform,nbFromFile);

W= WNoise*randn(pcSize,pcSize,gcSize,gcSize); W(W<0) = 0;
GC = zeros(gcSize);
GCm = zeros(gcSize);
mr = round(gcSize/2);
if (gcSize > 1) M = fillMConnections(mRad,gcSize,M,M_factor);  pcolor(hndl.lateral_weights,M(:,:,mr,mr)'); colormap(hndl.lateral_weights,'gray'); shading(hndl.lateral_weights,'interp'); end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Simulations
Reset = 0;  Stop = 0;
wh=waitbar(0,'Preparing to walk...');
idx = 2;  
simState = 'sim';
pathLength = size(Path,2);
tic
alf = 1;
f=1;
 
while ( idx < pathLength ) && ~Stop
    if mod(100*idx/pathLength, 20)==0 
        waitbar(idx/pathLength,wh,'Walking (and learning)...'); 
        pb.percent = idx/pathLength;
    end;
    
    if Reset
        Reset = 0; idx = 2;
    end;
    
    
    x_old = Path(:,idx-1); x = Path(:,idx);
    
    pcs = Activations{x(1),x(2)}; % get activated neighbours
    [GC,GCm] = gcActivations(pcs,W,GC,GCm,M);
    
    if isinf(GC)  error('asdfasdf'); end

    for gci=1:gcSize
        for gcj=1:gcSize
            W(:,:,gci,gcj) = LearnGC(pcs,idx,W(:,:,gci,gcj),GC(gci,gcj),GCm(gci,gcj),WNoise,WMin);
        end
    end
    
    
    %if mod(idx,100)==0 scriptDrawCurrentState; end;
    
    idx = idx+1;    % increment index
end

%% Recalculating fresh activations for each grid cell
idx=1;
while ( idx < pathLength ) && ~Stop
    if mod(100*idx/pathLength, 20)==0 waitbar(idx/pathLength,wh,'Rendering...'); end;

    x = Path(:,idx);
    pcs = Activations{x(1),x(2)}; % get activated neighbours
    
    % Calculate Grid Cells activations
    for gci=1:gcSize
        for gcj=1:gcSize
            yt=0;
            w = W(:,:,gci,gcj);
            for k=1:size(pcs,1) % go through the list of activated place cells
                yt = yt + w(pcs(k,1),pcs(k,2))*(pcs(k,3));
            end
            A(x(1),x(2),gci,gcj) = yt;
        end;
    end;
    
    idx = idx+1;    % increment index
end
disp(toc);
close(wh);

scriptDrawCurrentState;