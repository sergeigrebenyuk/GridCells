%% Main.m
% Initialization and starting simulation flow
% (c) Stepanyuk and Grebenyuk, 2015

%% Global declarations and initializations

init_and_clear;         % clear averything and load panels

%    x02: [1x720 double]  - Это расстояние от центра каждого поля до центра помещения, оно сейчас не используется
%     Rp: [720x720 double] – хеббовская корреляция полей места
%     Rm: [720x720 double] – антихеббовская корреляция полей места
%    xyc: [720x2 double] – координаты центров полей
%    dxc: [720x720 double]- расстояния между центрами вдоль оси абцисс
%    dyc: [720x720 double] ]- расстояния между центрами вдоль оси ординат
% diagRp: [1x720 double] – диагональ матрицы Rp, “нужно” только для версии модели с чисто антихебовскими синапсами
%    Rpg: {[720x720 double]} –матрицы хеббовских корреляций запакованные по группам- для тех версий модели в которых группы не покрывают полями все пространство
% w_ne_0: {[1x720 double]} – номера синапсов каждой хеббовской группы ,- для тех версий модели в которых группы не покрывают полями все пространство
% 
%      x: [720x5 double] – векторы активностей клеток места для нескольких моментов времени объединенные в матрицу 
%     Wg: - веса каждой группы синапсов, кажется этот параметр используется только для рисования картинки

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
global GC               % Grid cells in matrix form
global W                % Weights of grid cells synapses
global M                % Weights of grid cells lateral synapses
global M_factor         % Amplitude of guassian kernel of connections
global mRad             % Radius of the kernel
global WNoise           % Noise factor for PC-to-GC weights
global WMin             % Minimal weight of PC-to-GC synapses
global fig_handle       % handle to GUI panel
global hndl             % handles structure of fig_handle (filled upon figure loading)
global Reset Stop       % state variables
global simState         
global Activations      % Holds activated place cells for each trajectory point

global pfStruct;        % Place field parameters. See description of struct below

%% Initializations
pathFromFile = 0;
filedsFromFile = 0;
nbFromFile = 0;

pathUniform = 2;    % 0 - random trajectory, 1 - uniform random locations, 2 - regular grid pcSize x pcSize
pcUniform = 1;      % 0 - random location of place cells, 1 - grid-like distribution with integer coordinates


simulationTime = 1000.0;
deltaT = 2.0;

pcSize = 50;
pcNum = pcSize^2*0.4;
WNoise = 0.1;
WMin = -0.2;

% gcSize = 3;
% M_factor = -100000;
% mRad = round(gcSize/5);
% 
% pfStruct.Rad = round(pcSize/5);  % Radius of place field
% pfStruct.EISizeRatio = 1.5;     % Ratio between ex ad inh place field sizes
% pfStruct.Amp = 1000;             % Sensitivity (ampltude) of place field
% pfStruct.EIAmpRatio = 2;        % Ratio between ex and inh place field amplitudes

gcSize = 3;
M_factor = -0.01;                % Amplitude of guassian kernel of connections
mRad = round(gcSize/5);         % Radius of the kernel

pfStruct.Rad = round(pcSize/5);  % Radius of place field
pfStruct.EISizeRatio = 0.5;     % Ratio between ex ad inh place field sizes
pfStruct.Amp = 0.5;             % Sensitivity (ampltude) of place field
pfStruct.EIAmpRatio = 2;        % Ratio between ex and inh place field amplitudes


% Loading GUI file 'control_panel.fig' 
fig_handle = control_panel; % this loads and displays GUI window

%% Start simulation...
gc_sim;
    