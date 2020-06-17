function varargout = gui_l1l2(varargin)

addpath(genpath('.'));
%GUI_L1L2 M-file for gui_l1l2.fig
%      GUI_L1L2, by itself, creates a new GUI_L1L2 or raises the existing
%      singleton*.
%
%      H = GUI_L1L2 returns the handle to a new GUI_L1L2 or the handle to
%      the existing singleton*.
%
%      GUI_L1L2('Property','Value',...) creates a new GUI_L1L2 using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to gui_l1l2_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GUI_L1L2('CALLBACK') and GUI_L1L2('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GUI_L1L2.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_l1l2

% Last Modified by GUIDE v2.5 05-Nov-2010 17:21:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_l1l2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_l1l2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before gui_l1l2 is made visible.
function gui_l1l2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
% Choose default command line output for gui_l1l2
handles.output = hObject;

handles.isfix = true;
handles.isregression = true;
handles.isrealdata = true;
handles.tot = 1;
handles.outputtime = false;
handles.filename = '';
handles.p = 10;
set(handles.p_val, 'String', num2str(handles.p));
handles.s = 4;
set(handles.s_val, 'String', num2str(handles.s));
handles.delta = 0;
set(handles.delta_val, 'String', num2str(handles.delta));
handles.n = 100;
set(handles.n_val, 'String', num2str(handles.n));
handles.data_ok = 0;
handles.k = str2double(get(handles.k_val, 'String'));
handles.default_l1 = 1;

handles.err_type = 'regr';
handles.rand_split = 'true';
handles.l1_par = 0.0001;
handles.l2_par = 0;

handles.l1_par_max = -1;
handles.l1_par_min = -1;
handles.n_trials = -1;


axes(handles.error);
xlabel('l1 par');
ylabel('error');
axes(handles.selection);
xlabel('l1 par');
ylabel('# of selected features');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_l1l2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_l1l2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.filename = uigetfile;
[FileName,PathName,FilterIndex] = uigetfile('.mat');
name = sprintf('%s%s', PathName, FileName);
handles.filename = name;
set(handles.browse, 'String', FileName);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function p_val_Callback(hObject, eventdata, handles)
% hObject    handle to p_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p_val as text
%        str2double(get(hObject,'String')) returns contents of p_val as a double


% --- Executes during object creation, after setting all properties.
function p_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_val_Callback(hObject, eventdata, handles)
% hObject    handle to n_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_val as text
%        str2double(get(hObject,'String')) returns contents of n_val as a double


% --- Executes during object creation, after setting all properties.
function n_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function s_val_Callback(hObject, eventdata, handles)
% hObject    handle to s_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of s_val as text
%        str2double(get(hObject,'String')) returns contents of s_val as a double


% --- Executes during object creation, after setting all properties.
function s_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to s_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_val_Callback(hObject, eventdata, handles)
% hObject    handle to deltatxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deltatxt as text
%        str2double(get(hObject,'String')) returns contents of deltatxt as a double


% --- Executes during object creation, after setting all properties.
function deltatxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deltatxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in real_data_simulation.
function real_data_simulation_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in real_data_simulation 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
str = get(eventdata.NewValue, 'String');
%strcmp(str, '  simulation')
switch strcmp(str, '  simulation')
    case 1
        handles.isrealdata = 0;
        set(handles.pushbutton1, 'Enable', 'off');
        set(handles.s_val, 'Enable', 'on');
        set(handles.n_val, 'Enable', 'on');
        set(handles.p_val, 'Enable', 'on');
        set(handles.delta_val, 'Enable', 'on');
        set(handles.stxt, 'Enable', 'on');
        set(handles.ntxt, 'Enable', 'on');
        set(handles.ptxt, 'Enable', 'on');
        set(handles.deltatxt, 'Enable', 'on');
        set(handles.generate_data, 'Enable', 'on');
        set(handles.generate_data_txt, 'Enable', 'on');
    case 0 
        handles.isrealdata = 1;
        set(handles.pushbutton1, 'Enable', 'on');
        set(handles.s_val, 'Enable', 'off');
        set(handles.n_val, 'Enable', 'off');
        set(handles.p_val, 'Enable', 'off');
        set(handles.delta_val, 'Enable', 'off');
        set(handles.stxt, 'Enable', 'off');
        set(handles.ntxt, 'Enable', 'off');
        set(handles.ptxt, 'Enable', 'off');
        set(handles.deltatxt, 'Enable', 'off');
        set(handles.generate_data_txt, 'Enable', 'off');
        set(handles.generate_data, 'Enable', 'off');
end
guidata(hObject, handles);


function l1_par_val_Callback(hObject, eventdata, handles)
% hObject    handle to l1_par_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l1_par_val as text
%        str2double(get(hObject,'String')) returns contents of l1_par_val
%        as a double
handles.isfix = 1;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function l1_par_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l1_par_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function k_val_Callback(hObject, eventdata, handles)
% hObject    handle to k_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a = get(hObject,'String');
if(~isempty(a))
    handles.k=str2double(a);
else
    handles.k=5;
    set(handles.k_val, 'String', num2str(5));
end

guidata(hObject,handles);
% Hints: get(hObject,'String') returns contents of k_val as text
%        str2double(get(hObject,'String')) returns contents of k_val as a double


% --- Executes during object creation, after setting all properties.
function k_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to k_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(hObject,'Value')+0.0001;
handles.l1_par=10^(7*p-5)-10^(-5);
set(handles.l1_par_val,'String',num2str(handles.l1_par));
guidata(hObject,handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in split_val.
function split_val_Callback(hObject, eventdata, handles)
% hObject    handle to split_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=get(hObject,'Value');
if(tmp==1)
    handles.rand_split = true;
    
else
    handles.rand_split = false;
end
% = get(hObject,'Value');
guidata(hObject,handles);
% Hints: contents = get(hObject,'String') returns split_val contents as cell array
%        contents{get(hObject,'Value')} returns selected item from split_val


% --- Executes during object creation, after setting all properties.
function split_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to split_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(hObject,'Value');
handles.l2_par=10^(7*p-5)-10^(-5);
set(handles.l2_par_val,'String',num2str(handles.l2_par));
guidata(hObject,handles);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function l2_par_val_Callback(hObject, eventdata, handles)
% hObject    handle to l2_par_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l2_par_val as text
%        str2double(get(hObject,'String')) returns contents of l2_par_val as a double


% --- Executes during object creation, after setting all properties.
function l2_par_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l2_par_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over real_data.
function real_data_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to real_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on real_data and none of its controls.
function real_data_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to real_data (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in fix_kcv.
function fix_kcv_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in fix_kcv 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
str = get(eventdata.NewValue, 'String');
%strcmp(str, '  simulation')
switch strcmp(str, '  fix')
    case 1
        handles.isfix = 1;
        set(handles.slider2, 'Enable', 'on');
        set(handles.l1_par_val, 'Enable', 'on');
        set(handles.l1_par_txt, 'Enable', 'on');
        set(handles.k_val, 'Enable', 'off');
        set(handles.ktxt, 'Enable', 'off');
        set(handles.split_val, 'Enable', 'off');
        set(handles.default, 'Enable', 'off');
        set(handles.choose, 'Enable', 'off');
        %set(handles.l1_par_max_val, 'Enable', 'off');
        %set(handles.l1_par_min_val, 'Enable', 'off');
        %set(handles.n_trials_val, 'Enable', 'off');
        %set(handles.l1_par_max_txt, 'Enable', 'off');
        %set(handles.l1_par_min_txt, 'Enable', 'off');
        %set(handles.n_trials_txt, 'Enable', 'off');
    case 0 
        handles.isfix = 0;
        set(handles.slider2, 'Enable', 'off');
        set(handles.l1_par_val, 'Enable', 'off');
        set(handles.l1_par_txt, 'Enable', 'off');
        set(handles.k_val, 'Enable', 'on');
        set(handles.ktxt, 'Enable', 'on');
        set(handles.split_val, 'Enable', 'on');
        set(handles.default, 'Enable', 'on');
        set(handles.choose, 'Enable', 'on');
        %set(handles.l1_par_max_val, 'Enable', 'on');
        %set(handles.l1_par_min_val, 'Enable', 'on');
        %set(handles.n_trials_val, 'Enable', 'on');
        %set(handles.l1_par_max_txt, 'Enable', 'on');
        %set(handles.l1_par_min_txt, 'Enable', 'on');
        %set(handles.n_trials_txt, 'Enable', 'on');
        
end
guidata(hObject, handles);


% --- Executes when selected object is changed in classification_regression.
function classification_regression_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in classification_regression 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
str = get(eventdata.NewValue, 'String');
%strcmp(str, '  simulation')
switch strcmp(str, '  regression')
    case 1
        handles.isregression = 1;
        handles.err_type = 'regr';
    case 0 
        handles.isregression = 0;
        handles.err_type = 'class';
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%set(h, 'Modal', 'on');
% h=msgbox('computing...');
% %hc=get(h,'Children');

if(handles.isrealdata)
    if(isempty(handles.filename))
        msgbox('No file selected', 'modal');
        return;
    else
    fprintf('loading file %s\n', handles.filename);
%     st = regexp(filename, '.mat', 'start');
%     if(numel(st)>1) 
%         st = st(numel(st));
%     end
    en = regexp(handles.filename, '.mat', 'end');
    if(numel(en)>1) 
        en = st(numel(st));
    end
    l = length(handles.filename);
   if(isempty(en))
        msgbox('.mat file needed', 'modal');
        return;
    end
    
    if(~(en==l))
        msgbox('.mat file needed', 'modal');
        return;
    end
    
    stru = whos('-file', handles.filename, 'x', 'y', 'xt', 'yt');
    if(size(stru, 1)~=4)
        msgbox('Loaded data not in the right format', 'modal');
        return;
    end
    end
    temp = load(handles.filename);
    handles.X = temp.x;
    handles.Y = temp.y;
    handles.Xt = temp.xt;
    handles.Yt = temp.yt;
% else
%     handles.p = str2double(get(handles.p_val, 'String'));
%     handles.s = str2double(get(handles.s_val, 'String'));
%     handles.n = str2double(get(handles.n_val, 'String'));
%     handles.delta = str2double(get(handles.delta_val, 'String'));
%     [X, Y] = create_training_set(handles.n,handles.p,handles.s,handles.delta);
%     [Xt, Yt] = create_training_set(handles.n,handles.p,handles.s,handles.delta);
%     if(~handles.isregression)
%         Y = sign(Y);
%         Yt = sign(Yt);
%     end
else
    if(~handles.data_ok)
        msgbox('You should generate a dataset', 'modal');
        return;
    end
end

h = showinfowindow('computing...', 'please wait');
handles.l2_par = str2double(get(handles.l2_par_val, 'String'));
if(~handles.isfix)
    if(handles.default_l1)
        [cv_output,model, tau_values] = l1l2_kcv(handles.X,handles.Y,'err_type', handles.err_type, 'rand_split', handles.rand_split, 'K', handles.k, 'protocol', 'one_step', ...
     'smooth_par', handles.l2_par);
    else
     [cv_output,model, tau_values] = l1l2_kcv(handles.X,handles.Y,'err_type', handles.err_type, 'rand_split', handles.rand_split, 'K', handles.k, 'protocol', 'one_step', ...
     'smooth_par', handles.l2_par, 'L1_n_par', handles.n_trials, 'L1_max_par', handles.l1_par_max, 'L1_min_par', handles.l1_par_min);
    end
%[cv_output,model, tau_values] = l1l2_kcv(handles.X,handles.Y,'err_type', handles.err_type, 'rand_split', handles.rand_split, 'K', handles.k, 'protocol', 'one_step','smooth_par', handles.l2_par);

%    -'L1_n_par': number of values for the sparsity parameter (default is 100)
%       -'L1_max_par': maximum value for the sparsity parameter (default is
%        chosen automatically, see paper)
%       -'L1_min_par': minimum value for the sparsity parameter (default is
%        chosen automatically as L1_max_par/100)
    handles.l1_par = cv_output.tau_opt_1step;
    idx = find(tau_values==handles.l1_par);
    axes(handles.error);
    mm = [cv_output.err_KCV_1step(:); cv_output.err_train_1step(:)];
    axis([min(tau_values) max(tau_values) min(mm) max(mm)]);
    plot(tau_values, cv_output.err_KCV_1step);
    hold on
    plot(tau_values, cv_output.err_train_1step, 'r');
    plot(handles.l1_par, cv_output.err_KCV_1step(tau_values == handles.l1_par),'g*');
    xlabel('l1 par');
    ylabel('error');
    legend('KCV error', 'training error', 'KCV minimum', 'location', 'SouthEast');
    hold off
    %xlabel('l1 par'); ylabel('error');
    axes(handles.selection);
    %axis([min(tau_values) max(tau_values) 0 1]);
    plot(tau_values, cv_output.sparsity);
    xlabel('l1 par');
    ylabel('# of selected features');
    
    %xlabel('l1 par'); ylabel('# of selected features');
else
    handles.l1_par = str2double(get(handles.l1_par_val, 'String'));
    [beta_m, offset_par, n_iter] = l1l2_learn(handles.X, handles.Y, handles.l1_par, 'smooth_par', handles.l2_par);
    model.beta_1step = beta_m;
    model.offset_1step = offset_par;
end
[pred] = l1l2_pred(model,handles.Xt,handles.Yt,handles.err_type);
temp = model.beta_1step(model.beta_1step~=0.0);
set(handles.error_opt, 'String', num2str(pred.err_1step));
set(handles.l2_par_opt, 'String', num2str(handles.l2_par, '%3.3e'));
set(handles.l1_par_opt, 'String', num2str(handles.l1_par, '%3.3e'));
set(handles.s_opt, 'String', num2str(numel(temp)));
set(hObject, 'Enable', 'on');
%non_closing_window_handle = findobj('CloseRequestFcn','');
%set(non_closing_window_handle,'CloseRequestFcn','closereq')
close(h);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function delta_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in generate_data.
function generate_data_Callback(hObject, eventdata, handles)
% hObject    handle to generate_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.p = str2double(get(handles.p_val, 'String'));
    handles.s = str2double(get(handles.s_val, 'String'));
    handles.n = str2double(get(handles.n_val, 'String'));
    handles.delta = str2double(get(handles.delta_val, 'String'));
    if(handles.delta<0.)
        handles.delta=0.;
        set(handles.delta_val, 'String', num2str(handles.delta));
    end
    if(handles.delta>1.)
        handles.delta=1.;
        set(handles.delta_val, 'String', num2str(handles.delta));
    end 
    [handles.X, handles.Y] = create_training_set(handles.n,handles.p,handles.s,handles.delta);
    [handles.Xt, handles.Yt] = create_training_set(handles.n,handles.p,handles.s,handles.delta);
%     if(~handles.isregression)
%         handles.Y = sign(handles.Y);
%         handles.Yt = sign(handles.Yt);
%     end
  txt=sprintf('generated %d training points\ngenerated %d test points', handles.n, handles.n);
  handles.tot = handles.tot+1;
  handles.data_ok = 1;
  set(handles.generate_data_txt, 'String', txt);  
  guidata(hObject, handles);

  



function l1_par_min_val_Callback(hObject, eventdata, handles)
% hObject    handle to l1_par_min_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l1_par_min_val as text
%        str2double(get(hObject,'String')) returns contents of l1_par_min_val as a double
a = get(hObject,'String');
if(~isempty(a))
    handles.l1_par_min=str2double(a);
else
    handles.l1_par_min=-1;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function l1_par_min_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l1_par_min_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function l1_par_max_val_Callback(hObject, eventdata, handles)
% hObject    handle to l1_par_max_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of l1_par_max_val as text
%        str2double(get(hObject,'String')) returns contents of l1_par_max_val as a double
a = get(hObject,'String');
if(~isempty(a))
    handles.l1_par_max=str2double(a);
else
    handles.l1_par_max=-1;
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function l1_par_max_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to l1_par_max_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n_trials_val_Callback(hObject, eventdata, handles)
% hObject    handle to n_trials_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_trials_val as text
%        str2double(get(hObject,'String')) returns contents of n_trials_val as a double
a = get(hObject,'String');
if(~isempty(a))
    handles.n_trials=str2double(a);
else
    handles.n_trials=-1;
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function n_trials_val_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_trials_val (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in default_choose.
function default_choose_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in default_choose 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
str = get(eventdata.NewValue, 'String');
%strcmp(str, '  simulation')
switch strcmp(str, '   default')
    case 1
        handles.default_l1 = 1;
        set(handles.l1_par_max_val, 'Enable', 'off');
        set(handles.l1_par_min_val, 'Enable', 'off');
        set(handles.n_trials_val, 'Enable', 'off');
        set(handles.l1_par_max_txt, 'Enable', 'off');
        set(handles.l1_par_min_txt, 'Enable', 'off');
        set(handles.n_trials_txt, 'Enable', 'off');
    case 0 
        handles.default_l1 = 0;
        set(handles.l1_par_max_val, 'Enable', 'on');
        set(handles.l1_par_min_val, 'Enable', 'on');
        set(handles.n_trials_val, 'Enable', 'on');
        set(handles.l1_par_max_txt, 'Enable', 'on');
        set(handles.l1_par_min_txt, 'Enable', 'on');
        set(handles.n_trials_txt, 'Enable', 'on');
end

guidata(hObject, handles);
