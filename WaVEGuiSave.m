function varargout = WaveguiSave(varargin)
% WaveguiSave M-file for WaveguiSave.fig
%      WaveguiSave, by itself, creates a new WaveguiSave or raises the existing
%      singleton*.
%
%      H = WaveguiSave returns the handle to a new WaveguiSave or the handle to
%      the existing singleton*.
%
%      WaveguiSave('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WaveguiSave.M with the given input arguments.
%
%      WaveguiSave('Property','Value',...) creates a new WaveguiSave or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before WaveguiSave_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to WaveguiSave_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help WaveguiSave

% Last Modified by GUIDE v2.5 17-Jan-2005 18:47:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WaveguiSave_OpeningFcn, ...
                   'gui_OutputFcn',  @WaveguiSave_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before WaveguiSave is made visible.
function WaveguiSave_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to WaveguiSave (see VARARGIN)

% Choose default command line output for WaveguiSave
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes WaveguiSave wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = WaveguiSave_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

% varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function Save_Name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Save_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Save_Name_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Save_Name as text
%        str2double(get(hObject,'String')) returns contents of Save_Name as a double

outputs = get(hObject,'String');
save pgconfig.mat outputs;
delete(handles.figure1)


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


