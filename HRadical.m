function varargout = HRadical(varargin)
% HRADICAL MATLAB code for HRadical.fig
%      HRADICAL, by itself, creates a new HRADICAL or raises the existing
%      singleton*.
%
%      H = HRADICAL returns the handle to a new HRADICAL or the handle to
%      the existing singleton*.
%
%      HRADICAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HRADICAL.M with the given input arguments.
%
%      HRADICAL('Property','Value',...) creates a new HRADICAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HRadical_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HRadical_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HRadical

% Last Modified by GUIDE v2.5 29-Nov-2019 23:11:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HRadical_OpeningFcn, ...
                   'gui_OutputFcn',  @HRadical_OutputFcn, ...
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

% --- Executes just before HRadical is made visible.
function HRadical_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HRadical (see VARARGIN)

% Choose default command line output for HRadical
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HRadical wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%Add mitochondria.png
set(hObject, 'Units', 'pixels');
handles.banner = imread('mitochondria.png');
axes(handles.axes1);
image(handles.banner)
set(handles.axes1, 'Visible', 'off');

%Add wall.png
set(hObject, 'Units', 'pixels');
handles.banner = imread('wall.png');
axes(handles.axes6);
image(handles.banner)
set(handles.axes6, 'Visible', 'off');

%Create legend
axes(handles.axes2);
set(gca, 'xtick', [])
hold on
plot(0,0,'.r','MarkerSize',20)
plot(0,0,'.g','MarkerSize',20)
plot(0,0,'.m','MarkerSize',20)
plot(0,0,'.','MarkerSize',20,'Color',[1 0.6 0.3])
plot(0,0,'.k','MarkerSize',20)
legend('Superoxide','SOD','Hydrogen Peroxide','Iron ion','Hydroxyl Radical')
set(handles.axes2, 'Visible', 'off', 'Units', 'pixels');
hold off

%Set up description
set(handles.text6,'String','Press Start to begin simulation');

%Make all axes invisible
set(handles.axes3, 'Visible', 'off');
set(handles.axes4, 'Visible', 'off');
set(handles.axes5, 'Visible', 'off');
set(handles.axes7, 'Visible', 'off');
set(handles.axes8, 'Visible', 'off');
set(handles.axes9, 'Visible', 'off');
set(handles.axes10, 'Visible', 'off');

%Set up global boolean for when the simulation is in a loop or not, this is
%for the reset button to look like a push button instead of a toggle
%button. When pressed outside the loop the button does nothing but untoggle
%itself. However in the loop it there is a check for if the button was
%pressed or not, in this case it is untoggled in the loop itself.
global ol
ol = 1;

% --- Outputs from this function are returned to the command line.
function varargout = HRadical_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start button.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text6,'String','Simulation Start');

%set up graph 1: outside the mitochondria SOD
axes(handles.axes4);
g1 = plot(0,0,'.','MarkerSize',20);
set(g1,'XData', [],'YData', [])
axis off

%set up graph 2: inside the mitochondria superoxide 
axes(handles.axes3);
g2 = plot(0,0,'.','MarkerSize',20);
set(g2,'XData', [],'YData', [])
axis off

%set up graph 3: outside the cell iron 
axes(handles.axes5);
g3 = plot(0,0,'.','MarkerSize',20);
set(g3,'XData', [],'YData', [])
axis off

%set up graph 4: outside the mitochondria hydrogen 
axes(handles.axes7);
g4 = plot(0,0,'.','MarkerSize',20);
set(g4,'XData', [],'YData', [])
axis off

%set up graph 5: outside the mitochondria hydrogen peroxide
axes(handles.axes8);
g5 = plot(0,0,'.','MarkerSize',20);
set(g5,'XData', [],'YData', [])
axis off

%set up graph 6: outside the cell hydrogen peroxide
axes(handles.axes9);
g6 = plot(0,0,'.','MarkerSize',20);
set(g6,'XData', [],'YData', [])
axis off

%set up graph 7: outside the cell hydroxyl radical
axes(handles.axes10);
g7 = plot(0,0,'.m','MarkerSize',20);
set(g7,'XData', [],'YData', [])
axis off

%Get number of superoxide
n = round(get(handles.slider2,'Value'));

%Get number of iron
in = round(get(handles.slider4,'Value'));

%tso keeps track of the total number of superoxide molecules created so
%that the creation of superoxide can stop at n.
tso = 0;

%Sets up initial coordinates for all graphs
x1 = 20*rand(1,50)-5;
y1 = 10*rand(1,50)-10;
x2 = [];
y2 = [];
x3 = 20*rand(1,in)-5;
y3 = 10*rand(1,in)-10;
x4 = [];
y4 = [];
x5 = [];
y5 = [];
x6 = [];
y6 = [];
x7 = [];
y7 = [];

%Gets speed value from slider and translates it into a pause value for the
%loop
svalue = floor(get(handles.slider1,'Value'));
if svalue == 1
    pvalue = 0.3;
elseif svalue == 2
    pvalue = 0.2;
elseif svalue == 3
    pvalue = 0.1;
elseif svalue == 4
    pvalue = 0.075;
else
    pvalue = 0.05;
end

%Gets the total amount of points in each graph that is needed
[s,s2] = size(x2);
[s,s3] = size(x3);
[s,s4] = size(x4);
[s,s5] = size(x5);
[s,s6] = size(x6);

%booleans keep track of which description messages have been used
d2 = 0;
d3 = 0;
d4 = 0;

%Sets the global variable to false before entering loop
global ol
ol = 0;

%Main simulation loop
for i = 1:(n*50+50)
    
    %Gets value of reset button, untoggles it, and breaks loop
    reset = get(handles.pushbutton2, 'Value');
    if reset
        set(handles.pushbutton2, 'Value', 0);
        break;
    end
    
    %Create superoxide every 10 steps
    if(rem(i,10) == 0 && tso<n)
      rn1 = 20*rand(1,1)-5;
      rn2 = 10*rand(1,1)-5;
      x2 = [x2 rn1(1,1)];
      y2 = [y2 rn2(1,1)];
      tso = tso + 1;
      if(~d2)
          set(handles.text6,'String','Superoxide is produced in the mitochondria');
          d2 = 1;
      end
    end
    
    %Move superoxide to outside the mitochodria every 20 steps
    if(rem(i,20) == 0 && s2>0)
      rn1 = 20*rand(1,1)-5;
      rn2 = 10*rand(1,1)-5;
      x4 = [x4 rn1(1,1)];
      y4 = [y4 rn2(1,1)];
      x2(:,s2)= [];
      y2(:,s2)= [];
      if(~d3)
          set(handles.text6,'String','SOD dimutes superoxide which results in hydrogen peroxide and regular molecular oxygen(not shown here)');
          d3 = 1;
      end
    end
    
    %Every 5 steps check if there is superoxide outside mitochondria and
    %then dimutes it into hydrogen peroxide
    if(rem(i,5) == 0 && s4>0)
      rn1 = 20*rand(1,1)-5;
      rn2 = 10*rand(1,1)-5;
      x5 = [x5 rn1(1,1)];
      y5 = [y5 rn2(1,1)];
      x4(:,s4)= [];
      y4(:,s4)= [];
    end
    
    %Moves hydrogen peroxide outside the cell every 50 steps
    if(rem(i,50) == 0 && s5>0)
      rn1 = 20*rand(1,1)-5;
      rn2 = 10*rand(1,1)-5;
      x6 = [x6 rn1(1,1)];
      y6 = [y6 rn2(1,1)];
      x5(:,s5)= [];
      y5(:,s5)= [];
    end
    
    %Reacts iron with hydrogen peroxide and creates hydroxyl radical every
    %10 steps
    if(rem(i,10) == 0 && s3>0 && s6>0)
      rn1 = 20*rand(1,1)-5;
      rn2 = 10*rand(1,1)-5;
      x7 = [x7 rn1(1,1)];
      y7 = [y7 rn2(1,1)];
      x3(:,s3)= [];
      y3(:,s3)= [];
      x6(:,s6)= [];
      y6(:,s6)= [];     
      if(~d4)
          set(handles.text6,'String','Hydrogen peroxide can react with iron(or copper) in the body resulting in hydroxyl radical');
          d4 = 1;
      end
    end
    
    %Gets size of each coordinate
    [s,s2] = size(x2);
    [s,s3] = size(x3);
    [s,s4] = size(x4);
    [s,s5] = size(x5);
    [s,s6] = size(x6);
    [s,s7] = size(x7);
    
    %Moves particles 
    x1 = x1 + 0.05*rand(1,50);
    y1 = y1 + 0.05*rand(1,50);
    
    x2 = x2 + 0.01*rand(1,s2);
    y2 = y2 + 0.01*rand(1,s2);
    
    x3 = x3 + 0.01*rand(1,s3);
    y3 = y3 + 0.01*rand(1,s3);
    
    x4 = x4 + 0.01*rand(1,s4);
    y4 = y4 + 0.01*rand(1,s4);
    
    x5 = x5 + 0.01*rand(1,s5);
    y5 = y5 + 0.01*rand(1,s5);
    
    x6 = x6 + 0.01*rand(1,s6);
    y6 = y6 + 0.01*rand(1,s6);
    
    x7 = x7 + 0.01*rand(1,s7);
    y7 = y7 + 0.01*rand(1,s7);

    %Update all graphs
    set(g1,'XData', x1,'YData', y1, 'color', 'g')
    axis off
    set(g2,'XData', x2,'YData', y2, 'color', 'r')
    axis off
    set(g3,'XData', x3,'YData', y3, 'color', [1 0.6 0.3])
    axis off
    set(g4,'XData', x4,'YData', y4, 'color', 'r')
    axis off
    set(g5,'XData', x5,'YData', y5, 'color', 'm')
    axis off
    set(g6,'XData', x6,'YData', y6, 'color', 'm')
    axis off
    set(g7,'XData', x7,'YData', y7, 'color', 'k')
    axis off
    
    %Slows loop so that animations can be seen
    pause(pvalue)
end
%Sets boolean back to true
ol = 1;

%Resets all graphs
set(g1,'XData', [],'YData', [])
axis off
set(g2,'XData', [],'YData', [])
axis off
set(g3,'XData', [],'YData', [])
axis off
set(g4,'XData', [],'YData', [])
axis off
set(g5,'XData', [],'YData', [])
axis off
set(g6,'XData', [],'YData', [])
axis off
set(g7,'XData', [],'YData', [])
axis off

%Sets description for end of simulation
set(handles.text6,'String','Simulation done, press start to begin again');


% --- Executes on button press in reset button.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Untoggles reset button if outside the loop
global ol
if ol
   set(handles.pushbutton2, 'Value', 0);
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Gets value from slider and rounds it nearest integer
value = round(get(handles.slider1,'Value'));
set(handles.slider1,'Value',value);

%Determine speed value
if value == 1
    speed = 'Very Slow';
elseif value == 2
    speed = 'Slow';
elseif value == 3
    speed = 'Default';
elseif value == 4
    speed = 'Fast';
else
    speed = 'Very Fast';
end

set(handles.text8,'String', speed);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Gets value of slider for number of particles and rounds it to nearest integer
value = round(get(handles.slider2,'Value'));
set(handles.slider2,'Value',value);

set(handles.text9,'String', value);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Gets value of slider for number of particles and rounds it to nearest integer
value = round(get(handles.slider4,'Value'));
set(handles.slider4,'Value',value);

set(handles.text13,'String', value);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
