function varargout = gui_filter(varargin)
% BASIC M-file for basic.fig
%      BASIC, by itself, creates a new BASIC or raises the existing
%      singleton*.
%
%      H = BASIC returns the handle to a new BASIC or the handle to
%      the existing singleton*.
%
%      BASIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BASIC.M with the given input arguments.
%
%      BASIC('Property','Value',...) creates a new BASIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before basic_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to basic_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help basic

% Last Modified by GUIDE v2.5 19-Jun-2016 19:07:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @basic_OpeningFcn, ...
    'gui_OutputFcn',  @basic_OutputFcn, ...
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


% --- Executes just before basic is made visible.
function basic_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to basic (see VARARGIN)

% Choose default command line output for basic
handles.output = hObject;
guidata(hObject, handles);

handles.filter = 'lin';
handles.method = 'rls';
handles.space ='linspace';
handles.useKCV = 0;
handles.KCVMethod = 'seq';
handles.realdata = 1;
handles.loadedData = 0;
handles.filename= '';
handles.plotTrain = 0;
handles.trained = 0;
% handles.X = 0;
% handles.Y = 0;
% handles.Xtest = 0;
% handles.Ytest = 0;
handles.task = 'class';
addpath('./dataGeneration');
addpath('./spectral_reg_toolbox');
addpath('./dataset_scripts');
% Update handles structure

guidata(hObject, handles);


% UIWAIT makes basic wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = basic_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu_filters.
function popupmenu_filters_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_filters contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu_filters
contents = get(hObject,'String');
value = contents{get(hObject,'Value')};
if (strcmpi(value,'Linear'))
    set(handles.text_kpar, 'String', 'Unused kpar');
    set(handles.text_kpar, 'Visible', 'off');
    set(handles.edit_kpar, 'Visible', 'off');
    handles.filter = 'lin';
    set(handles.edit_kpar, 'String', '0');
    set(handles.edit_kpar, 'Enable', 'off');
    set(handles.slider_sigma, 'Enable', 'off');
    set(handles.checkbox_autosigma, 'Enable', 'off');
    set(handles.checkbox_autosigma, 'Value', 0);
elseif (strcmpi(value,'Polynomial'))
    handles.filter = 'pol';
    set(handles.text_kpar, 'String', 'degree');
    set(handles.edit_kpar, 'Enable', 'on');
    set(handles.slider_sigma, 'Enable', 'off');
    set(handles.text_kpar, 'Visible', 'on');
    set(handles.edit_kpar, 'Visible', 'on');
    set(handles.checkbox_autosigma, 'Enable', 'off');
    set(handles.checkbox_autosigma, 'Value', 0);
elseif (strcmpi(value,'Gaussian'))
    handles.filter = 'gauss';
    set(handles.text_kpar, 'String', 'sigma');
    set(handles.edit_kpar, 'Enable', 'on');
    set(handles.checkbox_autosigma, 'Enable', 'on');
    set(handles.slider_sigma, 'Enable', 'on');
    set(handles.text_kpar, 'Visible', 'on');
    set(handles.edit_kpar, 'Visible', 'on');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_filters_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_filters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);



function edit_kpar_Callback(hObject, eventdata, handles)
% hObject    handle to edit_kpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_kpar as text
%        str2double(get(hObject,'String')) returns contents of edit_kpar as a double


% --- Executes during object creation, after setting all properties.
function edit_kpar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_kpar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function edit_tmin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tmin as text
%        str2double(get(hObject,'String')) returns contents of edit_tmin as a double


% --- Executes during object creation, after setting all properties.
function edit_tmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function edit_tmax_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tmax as text
%        str2double(get(hObject,'String')) returns contents of edit_tmax as a double


% --- Executes during object creation, after setting all properties.
function edit_tmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function edit_npoints_Callback(hObject, eventdata, handles)
% hObject    handle to edit_npoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_npoints as text
%        str2double(get(hObject,'String')) returns contents of edit_npoints as a double


% --- Executes during object creation, after setting all properties.
function edit_npoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_npoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_space.
function popupmenu_space_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_space contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_space


% --- Executes during object creation, after setting all properties.
function popupmenu_space_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_dataset.
function popupmenu_dataset_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_dataset contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_dataset


% --- Executes during object creation, after setting all properties.
function popupmenu_dataset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_dataset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_kcv.
function checkbox_kcv_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_kcv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_kcv
handles.useKCV = get(hObject,'Value') ;

if (handles.useKCV == 1)
    set(handles.popupmenu_kcvtype, 'Enable', 'on');
    set(handles.edit_tmin, 'Enable', 'on');
    %set(handles.text12, 'String', 't min');
    set(handles.edit_tmax, 'Enable', 'on');
    set(handles.edit_npoints, 'Enable', 'on');
    set(handles.edit_ksplit, 'Enable', 'on');
    set(handles.edit_fixedValue, 'Enable', 'off');
    set(handles.popupmenu_space, 'Enable', 'on');
    set(handles.checkbox_fixedvalue, 'Value', 0);
    contents = get(handles.popupmenu_kcvtype,'String');
    value = contents{get(hObject,'Value')};
    handles.KCVMethod = value;

else
    set(handles.popupmenu_kcvtype, 'Enable', 'off');
    set(handles.checkbox_fixedvalue, 'Value', 1);
    set(handles.edit_fixedValue, 'Enable', 'on');
    %set(handles.text12, 'String', 't val');
    set(handles.edit_tmax, 'Enable', 'off');
    set(handles.edit_tmin, 'Enable', 'off');
    set(handles.edit_npoints, 'Enable', 'off');
    set(handles.edit_ksplit, 'Enable', 'off');
    set(handles.popupmenu_space, 'Enable', 'off');
end
if (strcmpi(handles.method,'land') || strcmpi(handles.method,'nu'))
    enableTmaxMethodParams(hObject, eventdata, handles);
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_run.
function pushbutton_run_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.filter
% handles.method
% handles.space
% handles.useKCV
% handles.KCVMethod
try
hcpt = showinfowindow('Computing...', 'Please wait...');
tmin = str2double(get(handles.edit_tmin,'String'));
tmax = str2double(get(handles.edit_tmax,'String'));
fixedVal = str2double(get(handles.edit_fixedValue,'String'));
npoints = str2double(get(handles.edit_npoints,'String'));

kpar = [];

handles.trained = 0;

% load dataset
if (handles.realdata == 0 && handles.loadedData == 0)
    [X y Xt yt] = loadDataset(hObject, eventdata, handles);
    handles.X = X;
    handles.y = y;
    handles.Xt = Xt;
    handles.yt = yt;
    handles.loadedData = 1;
elseif  (handles.loadedData == 0)
    if (isempty(handles.filename))
        close(hcpt);
        errordlg('You must specify a file to load','Bad Input','modal')
        uicontrol(hObject)
        return
    end

    fprintf('loading file %s\n', handles.filename);
    stru = whos('-file', handles.filename, 'x', 'y', 'xt', 'yt');
    if(size(stru, 1)~=4)
        msgbox('Loaded data not in the right format');
        return;
    end
    temp = load(handles.filename);
    X = temp.x;
    y = temp.y;
    Xt = temp.xt;
    yt = temp.yt;
    handles.X = X;
    handles.y = y;
    handles.Xt = Xt;
    handles.yt = yt;
    handles.loadedData = 1;
else
    X = handles.X;
    y = handles.y;
    Xt = handles.Xt;
    yt = handles.yt;

end
guidata(hObject, handles);

trange = 0;

autos = get(handles.checkbox_autosigma,'Value');
% check kpar
set(handles.text_selsigma, 'Visible', 'on');
set(handles.text19, 'Visible', 'on');
if ( ~strcmp(handles.filter,'lin'))
    set(handles.text19, 'String', 'Sigma:');
    kpar = str2double(get(handles.edit_kpar,'String'));
    if ( strcmp(handles.filter,'gauss') && autos)
        kpar = autosigma(X,5);
        set(handles.text_selsigma, 'String', kpar);
    elseif ( strcmp(handles.filter,'gauss') )
        if (kpar == 0)
            kpar = 0.1;
            set(handles.edit_kpar,'String', '0.1');
        end
        set(handles.text_selsigma, 'String', kpar);

    elseif ( strcmp(handles.filter,'pol') )
        set(handles.text_selsigma, 'String', kpar);
        set(handles.text19, 'String', 'K Degree:');

    end
    if isnan(kpar)
        errordlg('You must enter a numeric value for filter parameter','Bad Input','modal')
        uicontrol(hObject)
        close(hcpt);
        return
    end
else
    set(handles.text_selsigma, 'Visible', 'off');
    set(handles.text19, 'Visible', 'off');
end

if (handles.useKCV)
    split_type = 'seq';
    contents = get(handles.popupmenu_kcvtype,'String')
    value = contents{get(handles.popupmenu_kcvtype,'Value')}
    switch value
        case 'Sequential KCV'
            split_type='seq';
        case 'Random KCV'
            split_type='rand';
    end

    ksplit = str2double(get(handles.edit_ksplit,'String'));
    if (isnan(ksplit))
        errordlg('You must enter a numeric value for # SPLIT','Bad Input','modal')
        uicontrol(hObject)
        close(hcpt);
        return
    end

    %check tmin, tmax and npoints are numbers


    if (isnan(tmin) || isnan(tmax) || isnan(npoints))
        errordlg('You must enter a numeric value for TMIN, TMAX and POINTS','Bad Input','modal')
        uicontrol(hObject)
        close(hcpt);
        return
    end

    if (strcmpi(handles.method,'land') || strcmpi(handles.method,'nu'))
        trange = floor(tmax);
        tmin=0;
        set(handles.edit_tmax, 'String', trange);
        if (trange ~= tmax)
            set(handles.edit_tmax, 'Background', 'red');
        end


    else
        content = get(handles.popupmenu_space,'String');
        value = content{get(handles.popupmenu_space,'Value')};

        if tmin > tmax
            errordlg('Minimum value for the Log Space is larger than the specified maximum value');
            uicontrol(hObject)
            close(hcpt);
            return;
        end

        switch value
            case 'Linear Space'
                trange = linspace(tmin,tmax,npoints);
            case 'Log Space'
                if tmin < eps
                    errordlg('Minimum value for the Log Space must be grater than 0');
                    uicontrol(hObject)
                    close(hcpt);
                    return;
                end
                trange = logspace(log10(tmin),log10(tmax),npoints);
        end
    end



    [t_kcv_idx, avg_err_kcv] = kcv(handles.filter, kpar, handles.method, trange, X, y, ksplit, handles.task, split_type);

    tval = 0;

    if (strcmpi(handles.method,'land') || strcmpi(handles.method,'nu'))
        tval = t_kcv_idx;
        vmin = 0;
        vmax = max(trange);
    else
        tval = trange(t_kcv_idx);
        vmin = min(trange);
        vmax = max(trange);
    end
    [alpha, err] = learn(handles.filter, kpar, handles.method, tval, X, y, handles.task);

    handles.trained = 1;

    errMat = cell2mat(err);
    [z,index] = min(errMat);
    K = kernel(handles.filter, kpar, Xt, X);
    y_learnt = K * alpha{index(end)};
    lrn_error = learn_error(y_learnt, yt, handles.task);

%     handles.y_learnt_train = y_learnt;

    set(handles.text_testerror, 'String', lrn_error);
    %set(handles.text_error, 'String', avg_err_kcv(t_kcv_idx));
    set(handles.text_error, 'String', errMat( index(end) ));
    set(handles.text_selectedt, 'String', tval);



    if (strcmpi(handles.task,'class') )
        as = axis;
%         ax = (as(1):0.1:as(2));
%         az = (as(3):0.1:as(4));

       ax = min(min(min(Xt(:,1)),X(:,1))) : 0.1 : max(max(max(Xt(:,1)),X(:,1)));
        ax = [ax max(max(max(Xt(:,1)),X(:,1)))];

        az = min(min(min(Xt(:,2)),X(:,2))) : 0.1 : max(max(max(Xt(:,2)),X(:,2)));
        az = [az max(max(max(Xt(:,2)),X(:,2)))];

        [a b] = meshgrid(ax, az);
        c = [a(:),b(:)];
        K = kernel(handles.filter, kpar, c, X);
        y_learnt = K * alpha{index(end)};

        handles.y_learnt = y_learnt;

        axes(handles.axes)
        cla(handles.axes,'reset'); num2str(min(trange))
        contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
        plot_training_set_class(handles.axes, Xt,yt);num2str(min(trange))
        colormap winter

        if norm(alpha{index(end)}) >= 1e10
            errordlg('Inaccurate visualization, due to non-regularized solution','No regularization','modal')
            uicontrol(hObject)
            close(hcpt);
        end
    end

    if (length(trange) > 1)
        axes(handles.axes5)
        cla(handles.axes5);
        axis([vmin-0.01 vmax+0.01 min(avg_err_kcv)-0.01 max(avg_err_kcv)+0.01])
        plot(trange, avg_err_kcv,'-.b'), title('KCV - Error Plot'), xlabel( ['reg.par. range: '  num2str(vmin)  ' - ' num2str(vmax) ] ), ylabel('Error');
        grid on
        hold on
        plot(trange(t_kcv_idx), avg_err_kcv(t_kcv_idx), 'r*');

    else
        axes(handles.axes5)
        cla(handles.axes5);
        axis([vmin-0.01 vmax+0.01 min(avg_err_kcv)-0.01 max(avg_err_kcv)+0.01])
        plot(1:length(avg_err_kcv), avg_err_kcv,'-.b'), title('KCV - Error Plot'),xlabel(['t range: ' num2str(vmin) ' - '  num2str(vmax)] ), ylabel('Error');
        grid on
        hold on
        plot(t_kcv_idx, avg_err_kcv(t_kcv_idx), 'r*');
    end

    guidata(hObject, handles);
    close(hcpt);
    set(handles.edit_tmax, 'Background', 'white');

else %% no kcv

    if (isnan(fixedVal))
        errordlg('You must enter a numeric value for TMAX','Bad Input','modal')
        uicontrol(hObject)
        close(hcpt);
        return
    else
        trange = fixedVal;
    end

    [alpha, err] = learn(handles.filter, kpar, handles.method, trange, X, y, handles.task);


    errMat = cell2mat(err);
    [z,index] = min(errMat);

    K = kernel(handles.filter, kpar, Xt, X);
    y_learnt = K * alpha{index(end)};
    lrn_error = learn_error(y_learnt, yt, handles.task);

    handles.trained = 1;
%     handles.y_learnt_train = y_learnt;

    set(handles.text_error, 'String', errMat(index(end)));
    set(handles.text_testerror, 'String', lrn_error);
    set(handles.text_selectedt, 'String', trange);

    if (strcmpi(handles.task,'class') )
        as = axis;
        ax = min(min(min(Xt(:,1)),X(:,1))) : 0.1 : max(max(max(Xt(:,1)),X(:,1)));
        ax = [ax max(max(max(Xt(:,1)),X(:,1)))];

        az = min(min(min(Xt(:,2)),X(:,2))) : 0.1 : max(max(max(Xt(:,2)),X(:,2)));
        az = [az max(max(max(Xt(:,2)),X(:,2)))];
%         ax = (as(1):0.1:as(2));
%         az = (as(3):0.1:as(4));
        [a b] = meshgrid(ax, az);
        c = [a(:),b(:)];


        K = kernel(handles.filter, kpar, c, X);
        y_learnt = K * alpha{index(end)};

        handles.y_learnt = y_learnt;

        axes(handles.axes)
        cla(handles.axes,'reset');

        contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
        plot_training_set_class(handles.axes, Xt,yt);
        colormap winter
    end

    %     [a b] = meshgrid(ax, az);
    %     c = [a(:),b(:)];
    %
    %     K = kernel(handles.filter, kpar, c, X);
    %     y_learnt = K * alpha{index(1)};
    %     axes(handles.axes)
    %     cla(handles.axes,'reset');
    %
    %     plot_training_set_class(handles.axes, Xt);
    %     contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0]);
    %     colormap autumn
    guidata(hObject, handles);
    close(hcpt);
end
catch err
        close(hcpt);
end


function [X Y Xt Yt] = loadDataset(hObject, eventdata, handles)

n = str2double(get(handles.edit_nsamples,'String'));
nt = str2double(get(handles.edit_ntest,'String'));
p = str2double(get(handles.edit_noise,'String'));

contents = get(handles.popupmenu_dataset,'String');
value = contents{get(handles.popupmenu_dataset,'Value')};

if (isnan(n) || isnan(nt))

    errordlg('You must enter a numeric value for number of samples ','Bad Input','modal')
    uicontrol(hObject)
    return
end
if (isnan(p) || p < 0 || p > 1)
    errordlg('You must enter a numeric value in the range [0, 1] for the amount of noise','Bad Input','modal')
    uicontrol(hObject)
    return
end

  % 'MOONS' 'GAUSSIANS' 'LINEAR' 'SINUSOIDAL' 'SPIRAL'
switch value
    case 'Toy'

        [X Y Xt Yt]=toy_data(n,nt,p,1);
        %         handles.X = X;
        %         handles.Y = Y;
        %         handles.Xtest = Xt;
        %         handles.Ytest = Yt;
        %         guidata(hObject, handles);
    case 'Moons'
        [X, Y] = create_dataset(n, 'MOONS', p, 'PRESET');
        [Xt, Yt] = create_dataset(nt, 'MOONS', p, 'PRESET');
    case 'Gaussians'
        [X, Y] = create_dataset(n, 'GAUSSIANS', p, 'PRESET');
        [Xt, Yt] = create_dataset(nt, 'GAUSSIANS', p, 'PRESET');
    case 'Linear'
        [X, Y] = create_dataset(n, 'LINEAR', p, 'PRESET');
        [Xt, Yt] = create_dataset(nt, 'LINEAR', p, 'PRESET');
    case 'Sinusoidal'
        [X, Y] = create_dataset(n, 'SINUSOIDAL', p, 'PRESET');
        [Xt, Yt] = create_dataset(nt, 'SINUSOIDAL', p, 'PRESET');
    case 'Spiral'
        [X, Y] = create_dataset(n, 'SPIRAL', p, 'PRESET');
        [Xt, Yt] = create_dataset(nt, 'SPIRAL', p, 'PRESET');


end

guidata(hObject, handles);



% --- Executes on selection change in popupmenu_kcvtype.
function popupmenu_kcvtype_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_kcvtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_kcvtype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_kcvtype


% --- Executes during object creation, after setting all properties.
function popupmenu_kcvtype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_kcvtype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% --- Executes on selection change in popupmenu_method.
function popupmenu_method_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_method
contents = get(hObject,'String');
value = contents{get(hObject,'Value')};

if (strcmpi(value,'Reg. Least Squares'))
    handles.method = 'rls';
    enableTminMethodParams(hObject, eventdata, handles);
elseif (strcmpi(value,'Landweber'))
    handles.method = 'land';
    enableTmaxMethodParams(hObject, eventdata, handles)
elseif (strcmpi(value,'Truncated SVD'))
    handles.method = 'tsvd';
    enableTminMethodParams(hObject, eventdata, handles);
elseif (strcmpi(value,'nu-method'))
    handles.method = 'nu';
    enableTmaxMethodParams(hObject, eventdata, handles)
elseif (strcmpi(value,'spectral cut-off'))
    handles.method = 'cutoff';
    enableTminMethodParams(hObject, eventdata, handles);
end
guidata(hObject, handles);


function enableTmaxMethodParams(hObject, eventdata, handles)
if (handles.useKCV == 1)
    set(handles.edit_tmin, 'Enable', 'off');
    set(handles.edit_tmax, 'Enable', 'on');
    set(handles.edit_npoints, 'Enable', 'off');
    set(handles.popupmenu_space, 'Enable', 'off');
end
guidata(hObject, handles);

function enableTminMethodParams(hObject, eventdata, handles)
% set(handles.edit_tmin, 'Enable', 'on');
% set(handles.edit_tmax, 'Enable', 'off');
% set(handles.edit_npoints, 'Enable', 'off');
% set(handles.popupmenu_space, 'Enable', 'off');
if (handles.useKCV == 1)
    set(handles.edit_tmax, 'Enable', 'on');
    set(handles.edit_npoints, 'Enable', 'on');
    set(handles.popupmenu_space, 'Enable', 'on');
    set(handles.edit_tmin, 'Enable', 'on');
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function edit_nsamples_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nsamples as text
%        str2double(get(hObject,'String')) returns contents of edit_nsamples as a double


% --- Executes during object creation, after setting all properties.
function edit_nsamples_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nsamples (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

function edit_noise_Callback(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_noise as text
%        str2double(get(hObject,'String')) returns contents of edit_noise as a double


% --- Executes during object creation, after setting all properties.
function edit_noise_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_noise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes,'Visible','off');
set(handles.axes4,'Visible','off');
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes)
set(handles.axes,'Visible','on');
set(handles.axes4,'Visible','off');
% Hint: get(hObject,'Value') returns toggle state of togglebutton1
guidata(hObject, handles);

% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes4)
set(handles.axes,'Visible','off');
set(handles.axes4,'Visible','on');
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of togglebutton3


% --- Executes on button press in radiobutton_class.
function radiobutton_class_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.task = 'class'
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_class


% --- Executes on button press in radiobutton_reg.
function radiobutton_reg_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.task = 'regr';
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_reg


% --- Executes on button press in pushbutton_class.
function pushbutton_class_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_class (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_class


% --- Executes on button press in pushbutton_reg.
function pushbutton_reg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pushbutton_reg



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tmin as text
%        str2double(get(hObject,'String')) returns contents of edit_tmin as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tmax as text
%        str2double(get(hObject,'String')) returns contents of edit_tmax as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit_npoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_npoints as text
%        str2double(get(hObject,'String')) returns contents of edit_npoints as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_npoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on selection change in popupmenu_space.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu_space contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_space


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_space (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_autosigma.
function checkbox_autosigma_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_autosigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_autosigma


if isequal(get(hObject,'Value') , true)

    set(handles.slider_sigma,'Enable','off');
    set(handles.edit_kpar,'Enable','off');

else

    set(handles.slider_sigma,'Enable','on');
    set(handles.edit_kpar,'Enable','on');

end



% --- Executes on key press with focus on popupmenu_filters and none of its controls.
function popupmenu_filters_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_filters (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton_existing.
function radiobutton_existing_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_existing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.realdata = 1;
set(handles.popupmenu_dataset,'Enable','off');
set(handles.edit_nsamples,'Enable','off');
set(handles.edit_ntest,'Enable','off');
set(handles.edit_noise,'Enable','off');
set(handles.pushbutton_browse,'Enable','on');
handles.loadedData = 0;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_existing


% --- Executes on button press in radiobutton_simulation.
function radiobutton_simulation_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.realdata = 0;
set(handles.popupmenu_dataset,'Enable','on');
set(handles.edit_nsamples,'Enable','on');
set(handles.edit_ntest,'Enable','on');
set(handles.edit_noise,'Enable','on');
set(handles.pushbutton_browse,'Enable','off');
handles.loadedData = 0;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton_simulation



function edit_datasetname_Callback(hObject, eventdata, handles)
% hObject    handle to edit_datasetname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_datasetname as text
%        str2double(get(hObject,'String')) returns contents of edit_datasetname as a double


% --- Executes during object creation, after setting all properties.
function edit_datasetname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_datasetname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton_browse.
function pushbutton_browse_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName,FilterIndex] = uigetfile('*.mat');
name = sprintf('%s%s', PathName, FileName);
handles.filename = name;
if (~isempty(name))
    handles.filename = name;
    handles.realdata = 1;
    set(handles.edit_datasetname, 'String', FileName);
    guidata(hObject, handles);
end
guidata(hObject, handles);


% --- Executes on slider movement.
function slider_sigma_Callback(hObject, eventdata, handles)
% hObject    handle to slider_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=get(hObject,'Value');
set(handles.edit_kpar, 'String', p);
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider_sigma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_sigma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
guidata(hObject, handles);


function edit_ksplit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ksplit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ksplit as text
%        str2double(get(hObject,'String')) returns contents of edit_ksplit as a double


% --- Executes during object creation, after setting all properties.
function edit_ksplit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ksplit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.loadedData = 0;
handles.trained = 0;
set(handles.pushbutton_switchPlot, 'String', 'Plot Training');
handles.plotTrain = 0;

% load dataset
if (handles.realdata == 0 && handles.loadedData == 0)
    [X y Xt yt] = loadDataset(hObject, eventdata, handles);
    handles.X = X;
    handles.y = y;
    handles.Xt = Xt;
    handles.yt = yt;
    handles.loadedData = 1;
    guidata(hObject, handles);
elseif  (handles.loadedData == 0 && handles.realdata == 1)
    if (isempty(handles.filename))
        errordlg('You must specify a file to load','Bad Input','modal')
        uicontrol(hObject)
        return
    end

    fprintf('loading file %s\n', handles.filename);
    stru = whos('-file', handles.filename, 'x', 'y', 'xt', 'yt');
    if(size(stru, 1)~=4)
        msgbox('Loaded data not in the right format');
        return;
    end
    temp = load(handles.filename);
    X = temp.x;
    y = temp.y;
    Xt = temp.xt;
    yt = temp.yt;
    handles.X = X;
    handles.y = y;
    handles.Xt = Xt;
    handles.yt = yt;
    handles.loadedData = 1;
    guidata(hObject, handles);
else
    X = handles.X;
    y = handles.y;
    Xt = handles.Xt;
    yt = handles.yt;
    guidata(hObject, handles);
end
% cla(handles.axes,'reset');
axes(handles.axes)
cla(handles.axes,'reset');
plot_training_set_class(handles.axes, Xt,yt);
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function pushbutton_browse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function edit_ntest_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ntest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ntest as text
%        str2double(get(hObject,'String')) returns contents of edit_ntest as a double


% --- Executes during object creation, after setting all properties.
function edit_ntest_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ntest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);

% --- Executes on button press in checkbox_fixedvalue.
function checkbox_fixedvalue_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_fixedvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_fixedvalue
handles.useKCV = 1 - get(hObject,'Value');

if (handles.useKCV == 1)
    set(handles.popupmenu_kcvtype, 'Enable', 'on');
    set(handles.edit_tmin, 'Enable', 'on');
    %     set(handles.text12, 'String', 't min');
    set(handles.edit_tmax, 'Enable', 'on');
    set(handles.edit_npoints, 'Enable', 'on');
    set(handles.edit_ksplit, 'Enable', 'on');
    set(handles.edit_fixedValue, 'Enable', 'off');
    set(handles.popupmenu_space, 'Enable', 'on');
    set(handles.checkbox_kcv, 'Value', 1);
    contents = get(handles.popupmenu_kcvtype,'String');
    value = contents{get(handles.popupmenu_kcvtype,'Value')};
    handles.KCVMethod = value;

else
    set(handles.popupmenu_kcvtype, 'Enable', 'off');
    set(handles.checkbox_kcv, 'Value', 0);
    set(handles.edit_fixedValue, 'Enable', 'on');
    %     set(handles.text12, 'String', 't val');
    set(handles.edit_tmax, 'Enable', 'off');
    set(handles.edit_tmin, 'Enable', 'off');
    set(handles.edit_npoints, 'Enable', 'off');
    set(handles.edit_ksplit, 'Enable', 'off');
    set(handles.popupmenu_space, 'Enable', 'off');
end
if (strcmpi(handles.method,'land') || strcmpi(handles.method,'nu'))
    enableTmaxMethodParams(hObject, eventdata, handles);
end
guidata(hObject, handles);





function edit_fixedValue_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fixedValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fixedValue as text
%        str2double(get(hObject,'String')) returns contents of edit_fixedValue as a double


% --- Executes during object creation, after setting all properties.
function edit_fixedValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fixedValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


% --- Executes during object deletion, before destroying properties.
function checkbox_fixedvalue_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to checkbox_fixedvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_switchPlot.
function pushbutton_switchPlot_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_switchPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.plotTrain = 1 - handles.plotTrain;
axes(handles.axes)
cla(handles.axes,'reset');

if (handles.plotTrain == 1)
    plot_training_set_class(handles.axes, handles.X,handles.y);
    set(handles.pushbutton_switchPlot, 'String', 'Plot Test');

    if (handles.trained == 1)

        as = axis;
%         ax = (as(1):0.1:as(2));
%         az = (as(3):0.1:as(4));

        ax = min(min(min(handles.Xt(:,1)),handles.X(:,1))) : 0.1 : max(max(max(handles.Xt(:,1)),handles.X(:,1)));
        ax = [ax max(max(max(handles.Xt(:,1)),handles.X(:,1)))];

        az = min(min(min(handles.Xt(:,2)),handles.X(:,2))) : 0.1 : max(max(max(handles.Xt(:,2)),handles.X(:,2)));
        az = [az max(max(max(handles.Xt(:,2)),handles.X(:,2)))];


        [a b] = meshgrid(ax, az);
        c = [a(:),b(:)];

        y_learnt =  handles.y_learnt;

%         axes(handles.axes)
%        cla(handles.axes,'reset');
%         plot_training_set_class(handles.axes, handles.X);

        contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
        hold on
          plot_training_set_class(handles.axes, handles.X,handles.y);

        colormap winter
    end


else
    plot_training_set_class(handles.axes, handles.Xt,handles.yt);
    set(handles.pushbutton_switchPlot, 'String', 'Plot Training');

    if (handles.trained == 1)

        as = axis;
%         ax = (as(1):0.1:as(2));
%         az = (as(3):0.1:as(4));

      ax = min(min(min(handles.Xt(:,1)),handles.X(:,1))) : 0.1 : max(max(max(handles.Xt(:,1)),handles.X(:,1)));
        ax = [ax max(max(max(handles.Xt(:,1)),handles.X(:,1)))];

        az = min(min(min(handles.Xt(:,2)),handles.X(:,2))) : 0.1 : max(max(max(handles.Xt(:,2)),handles.X(:,2)));
        az = [az max(max(max(handles.Xt(:,2)),handles.X(:,2)))];

        [a b] = meshgrid(ax, az);
        c = [a(:),b(:)];

        y_learnt =  handles.y_learnt;

%         axes(handles.axes)
%         cla(handles.axes,'reset');
%         plot_training_set_class(handles.axes, handles.Xt);

contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
        hold on
          plot_training_set_class(handles.axes, handles.Xt,handles.yt);

        colormap winter

% contourf(a, b, reshape(y_learnt, size(a,1), size(a,2)),[0 0],'b');
%         colormap winter
    end


end
guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel9.
function uipanel9_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel9
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
    if (eventdata.NewValue == handles.radiobutton_simulation)
        radiobutton_simulation_Callback(hObject, eventdata, handles);
    else
        radiobutton_existing_Callback(hObject, eventdata, handles);
    end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    helpdlg(sprintf(['Reg. Least Squares: regularization parameter is a real number in (0, s]', ...
         ' with s the biggest eigenvalue of the kernel matrix\n\n', ...
         'Landweber: regularization parameter is the number of iterations of the method\n\n',...
         'T-SVD: regularization parameter is a real number in (0, s]\n\n',...
         'NU-method: regularization parameter is the number of iterations of the method\n\n',...
         'Spectral Cut-off: regularization parameter is a real number in (0, s]\n']),'Info on filters');


% --- Executes on key press with focus on pushbutton_switchPlot and none of its controls.
function pushbutton_switchPlot_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_switchPlot (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)