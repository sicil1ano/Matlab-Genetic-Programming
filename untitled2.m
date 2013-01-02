function varargout = untitled2(varargin)
% UNTITLED2 MATLAB code for untitled2.fig
%      UNTITLED2, by itself, creates a new UNTITLED2 or raises the existing
%      singleton*.
%
%      H = UNTITLED2 returns the handle to a new UNTITLED2 or the handle to
%      the existing singleton*.
%
%      UNTITLED2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED2.M with the given input arguments.
%
%      UNTITLED2('Property','Value',...) creates a new UNTITLED2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled2

% Last Modified by GUIDE v2.5 31-Dec-2012 15:12:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled2_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled2_OutputFcn, ...
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
%Flag che contengono lo stato per funzioni del function set



% End initialization code - DO NOT EDIT


% --- Executes just before untitled2 is made visible.
function untitled2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled2 (see VARARGIN)

% Choose default command line output for untitled2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function population_Callback(hObject, eventdata, handles)
% hObject    handle to population (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of population as text
%        str2double(get(hObject,'String')) returns contents of population as a double
p=str2double(get(hObject,'String'));
save p p;

% --- Executes during object creation, after setting all properties.
function population_CreateFcn(hObject, eventdata, handles)
% hObject    handle to population (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function generations_Callback(hObject, eventdata, handles)
% hObject    handle to generations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of generations as text
%        str2double(get(hObject,'String')) returns contents of generations as a double
g=str2double(get(hObject,'String'));
save g g;
% --- Executes during object creation, after setting all properties.
function generations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to generations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function transfFunction_Callback(hObject, eventdata, handles)
% hObject    handle to transfFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of transfFunction as text
%        str2double(get(hObject,'String')) returns contents of transfFunction as a double
tr_sf=char(get(hObject,'String'));
save tr_sf tr_sf;

% --- Executes during object creation, after setting all properties.
function transfFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to transfFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function mut_rate_Callback(hObject, eventdata, handles)
% hObject    handle to mut_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mut_rate as text
%        str2double(get(hObject,'String')) returns contents of mut_rate as a double
mutate=str2double(get(hObject,'String'));
save mutate mutate;


% --- Executes during object creation, after setting all properties.
function mut_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mut_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cross_rate_Callback(hObject, eventdata, handles)
% hObject    handle to cross_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cross_rate as text
%        str2double(get(hObject,'String')) returns contents of cross_rate as a double
cross=str2double(get(hObject,'String'));
save cross cross;

% --- Executes during object creation, after setting all properties.
function cross_rate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cross_rate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rangeCostInferiori_Callback(hObject, eventdata, handles)
% hObject    handle to rangeCostInferiori (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rangeCostInferiori as text
%        str2double(get(hObject,'String')) returns contents of rangeCostInferiori as a double
rangeCostInf=str2double(get(hObject,'String'));
save rangeCostInf rangeCostInf;

% --- Executes during object creation, after setting all properties.
function rangeCostInferiori_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangeCostInferiori (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rangeCostSuperiore_Callback(hObject, eventdata, handles)
% hObject    handle to rangeCostSuperiore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rangeCostSuperiore as text
%        str2double(get(hObject,'String')) returns contents of rangeCostSuperiore as a double
rangeCostSup=str2double(get(hObject,'String'));
save rangeCostSup rangeCostSup;

% --- Executes during object creation, after setting all properties.
function rangeCostSuperiore_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rangeCostSuperiore (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pEstremoInf_Callback(hObject, eventdata, handles)
% hObject    handle to pEstremoInf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pEstremoInf as text
%        str2double(get(hObject,'String')) returns contents of pEstremoInf as a double
pEstrInf=str2double(get(hObject,'String'));
save pEstrInf pEstrInf;

% --- Executes during object creation, after setting all properties.
function pEstremoInf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pEstremoInf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pEstremoSup_Callback(hObject, eventdata, handles)
% hObject    handle to pEstremoSup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pEstremoSup as text
%        str2double(get(hObject,'String')) returns contents of pEstremoSup as a double
pEstrSup=str2double(get(hObject,'String'));
save pEstrSup pEstrSup;

% --- Executes during object creation, after setting all properties.
function pEstremoSup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pEstremoSup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p1EstremoInf_Callback(hObject, eventdata, handles)
% hObject    handle to p1EstremoInf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1EstremoInf as text
%        str2double(get(hObject,'String')) returns contents of p1EstremoInf as a double
p1EstrInf=str2double(get(hObject,'String'));
save p1EstrInf p1EstrInf;

% --- Executes during object creation, after setting all properties.
function p1EstremoInf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1EstremoInf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p1EstremoSup_Callback(hObject, eventdata, handles)
% hObject    handle to p1EstremoSup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p1EstremoSup as text
%        str2double(get(hObject,'String')) returns contents of p1EstremoSup as a double
p1EstrSup=str2double(get(hObject,'String'));
save p1EstrSup p1EstrSup;

% --- Executes during object creation, after setting all properties.
function p1EstremoSup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p1EstremoSup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p2EstremoInf_Callback(hObject, eventdata, handles)
% hObject    handle to p2EstremoInf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2EstremoInf as text
%        str2double(get(hObject,'String')) returns contents of p2EstremoInf as a double
p2EstrInf=str2double(get(hObject,'String'));
save p2EstrInf p2EstrInf;

% --- Executes during object creation, after setting all properties.
function p2EstremoInf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2EstremoInf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function p2EstremoSup_Callback(hObject, eventdata, handles)
% hObject    handle to p2EstremoSup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p2EstremoSup as text
%        str2double(get(hObject,'String')) returns contents of p2EstremoSup as a double
p2EstrSup=str2double(get(hObject,'String'));
save p2EstrSup p2EstrSup;

% --- Executes during object creation, after setting all properties.
function p2EstremoSup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p2EstremoSup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in timesTag.
function timesTag_Callback(hObject, eventdata, handles)
% hObject    handle to timesTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timesTag
activeTIMES = 0;
if(get(hObject,'Value') == get(hObject,'Max'))
	activeTIMES = 1;
else
	activeTIMES = 0;
end
save activeTIMES activeTIMES;
% --- Executes on button press in minusTag.
function minusTag_Callback(hObject, eventdata, handles)
% hObject    handle to minusTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of minusTag
activeMINUS = 0;
if(get(hObject,'Value') == get(hObject,'Max'))
	activeMINUS = 1;
else
	activeMINUS = 0;
end
save activeMINUS activeMINUS;

% --- Executes on button press in plusTag.
function plusTag_Callback(hObject, eventdata, handles)
% hObject    handle to plusTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plusTag
activePLUS = 0;
if(get(hObject,'Value') == get(hObject,'Max'))
	activePLUS = 1;
else
	activePLUS = 0;
end
save activePLUS activePLUS;

% --- Executes on button press in divideTag.
function divideTag_Callback(hObject, eventdata, handles)
% hObject    handle to divideTag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of divideTag
activeDIVIDE = 0;
if(get(hObject,'Value') == get(hObject,'Max'))
	activeDIVIDE = 1;
else
	activeDIVIDE = 0;
end
save activeDIVIDE activeDIVIDE;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
commandwindow;
clc;
run ('./gpdemo1');
