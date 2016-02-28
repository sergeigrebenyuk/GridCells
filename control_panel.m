function varargout = control_panel(varargin)
% CONTROL_PANEL MATLAB code for control_panel.fig
%      CONTROL_PANEL, by itself, creates a new CONTROL_PANEL or raises the existing
%      singleton*.
%
%      H = CONTROL_PANEL returns the handle to a new CONTROL_PANEL or the handle to
%      the existing singleton*.
%
%      CONTROL_PANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROL_PANEL.M with the given input arguments.
%
%      CONTROL_PANEL('Property','Value',...) creates a new CONTROL_PANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before control_panel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to control_panel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help control_panel

% Last Modified by GUIDE v2.5 14-May-2015 23:32:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @control_panel_OpeningFcn, ...
                   'gui_OutputFcn',  @control_panel_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before control_panel is made visible.
function control_panel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to control_panel (see VARARGIN)

% Choose default command line output for control_panel
handles.output = hObject;

global hndl;
hndl = handles;
% Update handles structure
guidata(hObject, handles);

% cmap = ones(2,3);
% cmap(2,:) = [0,0.6,0];
%colormap(hndl.place_fields, 'hot');
% colormap(hndl.phase_plot, cmap);

%shading(hndl.place_fields, 'interp');
%axis(hndl.place_fields, 'equal'); 
% UIWAIT makes control_panel wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(hObject,'WindowButtonDownFcn',@wbdcb);

end

% --- Outputs from this function are returned to the command line.
function varargout = control_panel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in BuildNewTrajectory.
function BuildNewTrajectory_Callback(hObject, eventdata, handles)
% hObject    handle to BuildNewTrajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global simulationTime   % Simulation time (sec)
    global deltaT           % Time step in the time grid
    global pcSize            % Environment size
    global Path;            % Trajectory of the animal
    global Reset;
    global PC PCD;
    global Activations;
    global pfStruct;
    global pathUniform      % "Trajectory" is uniformly distributed discrete dots
    global pcUniform      % "Trajectory" is uniformly distributed discrete dots
    Path = GenerateRandomTrajectory2( simulationTime, deltaT, pcSize, pathUniform,0);
    Activations = pcActivations(PC,pfStruct,Path,pcUniform,0);
    DrawPathAndPlace(handles,Path,PCD,pcSize);
    Reset = 1;
end
% --- Executes on key press with focus on BuildNewTrajectory and none of its controls.
function BuildNewTrajectory_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to BuildNewTrajectory (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in NewPlaceFields.
function NewPlaceFields_Callback(hObject, eventdata, handles)
% hObject    handle to NewPlaceFields (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global pcSize            % Environment size
    global Path;            % Trajectory of the animal
    global Reset;
    global PC PCD;
    global Activations;
    global pfStruct;
    global pcNum;
    global pcUniform        % Place cells are generated at nodes of regular mesh
    [PC PCD] = GenerateRandomPC(pcNum, pcSize,pcUniform,0);
    Activations = pcActivations(PC,pfStruct,pcUniform,Path,0);
    DrawPathAndPlace(handles,Path,PCD,pcSize);
    Reset = 1;
end
% --- Executes on key press with focus on NewPlaceFields and none of its controls.
function NewPlaceFields_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to NewPlaceFields (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over BuildNewTrajectory.
function BuildNewTrajectory_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to BuildNewTrajectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in StopSim.
function StopSim_Callback(hObject, eventdata, handles)
% hObject    handle to StopSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Stop;
Stop = 1;
end
% --- Executes on button press in Restart.
function Restart_Callback(hObject, eventdata, handles)
% hObject    handle to Restart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gc_sim
end


% --- Executes on mouse press over axes background.
function GC_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to GC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A;
[x,y,str] = disp_point(hObject);
text(x,y,str,'VerticalAlignment','bottom');
A1=A(:,:,x,y)'; 

pcolor(hndl.gc1,A1);
colormap(hndl.gc1,'jet');
shading(hndl.gc1,'interp');
    

end


% --- Executes on mouse press over axes background.
function gc1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to gc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global A;
[x,y,str] = disp_point(hObject);
text(x,y,str,'VerticalAlignment','bottom');

S1 = shiftdim(A,2);
S2 = S1(:,:,x,y);

pcolor(hndl.GC,S2');
colormap(hndl.GC,'jet');
shading(hndl.GC,'interp');
    
end

function wbdcb(src,evnt)
 ah = gca; 
    %[x,y,str] = disp_point(ah);
    %text(x,y,str,'VerticalAlignment','bottom');
    if strcmp(get(src,'SelectionType'),'normal')       
     %[x,y,str] = disp_point(ah);
     %hl = line('XData',x,'YData',y,'Marker','.');
     %text(x,y,str,'VerticalAlignment','bottom');
     set(src,'WindowButtonMotionFcn',{@wbmcb,ah})
    elseif strcmp(get(src,'SelectionType'),'alt')
     set(src,'WindowButtonMotionFcn','')
     %[x,y,str] = disp_point(gca);
     %text(x,y,str,'VerticalAlignment','bottom');
    end
    function wbmcb(src,evnt,ah)
     
        cp = get(ah,'CurrentPoint');  
        x = round(cp(1,1));
        y = round(cp(1,2));
        str = ['(',num2str(x,'%0.3g'),', ',num2str(y,'%0.3g'),')'];    

        global A hndl;
        ax = gca;
        if ax==hndl.GC
            A1=A(:,:,x,y)'; 
            pcolor(hndl.gc1,A1);
            colormap(hndl.gc1,'jet');
            shading(hndl.gc1,'interp');

        elseif ax==hndl.gc1

            S1 = shiftdim(A,2);
            S2 = S1(:,:,x,y);

            pcolor(hndl.GC,S2');
            colormap(hndl.GC,'jet');
            shading(hndl.GC,'interp');

        end
    end  
end
% function [x,y,str] = disp_point(ah)
%   cp = get(ah,'CurrentPoint');  
%   x = round(cp(1,1));
%   y = round(cp(1,2));
%   str = ['(',num2str(x,'%0.3g'),', ',num2str(y,'%0.3g'),')'];    
% 
%   global A hndl;
%   ax = gca;
%   if ax==hndl.GC
%         A1=A(:,:,x,y)'; 
%         pcolor(hndl.gc1,A1);
%         colormap(hndl.gc1,'jet');
%         shading(hndl.gc1,'interp');
% 
%     elseif ax==hndl.gc1
% 
%         S1 = shiftdim(A,2);
%         S2 = S1(:,:,x,y);
% 
%         pcolor(hndl.GC,S2');
%         colormap(hndl.GC,'jet');
%         shading(hndl.GC,'interp');
% 
%     end
% 
% end
