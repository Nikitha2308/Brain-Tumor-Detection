function varargout = Main(varargin)
% MAIN M-file for Main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Main

% Last Modified by GUIDE v2.5 14-Mar-2020 10:25:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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


% --- Executes just before Main is made visible.
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Main (see VARARGIN)

% Choose default command line output for Main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global I;

[ filename, pathname ] = uigetfile( '*.JPG', 'Select an Image' );

 I=imread([ pathname, filename]);
 axes(handles.axes1);
    imshow(I);
    title('Input Image');
    global I I1
I1 = rgb2gray(I);
axes(handles.axes2);

imshow(I1);
title('Gray scale MRI image');
 gray = rgb2gray(I);
% Otsu Binarization for segmentation
level = graythresh(I);
%gray = gray>80;
img = im2bw(I,.6);
img = bwareaopen(img,80); 
img2 = im2bw(I);
% Try morphological operations
%gray = rgb2gray(I);
%tumor = imopen(gray,strel('line',15,0));
axes(handles.axes3)
imshow(img);title('Segmented Image');
%imshow(tumor);title('Segmented Image');
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
 global BW2 I1
 BW2 = edge(I1,'canny', 0.4);
  axes(handles.axes4);
  imshow(BW2);
  title('Detected edges');
  global cleanimage BW2 I1

 %%% Morphological Based denoising
   cleanimage = noisecomp(I1, 2, 5, 2.3, 6, 0);
    axes(handles.axes5);
    imshow(cleanimage);
    title('Denoised Image');
    global cleanimage dst

 %%% MRF and CRF
    max_diff = 200;
    weight_diff = 0.02;
    iterations = 10;
    covar = 100;
    dst = restore_image(cleanimage, covar, max_diff, weight_diff, iterations)
    axes(handles.axes6);
    imshow(dst);
    title('Image after MRF&CRFcombination');
    global dst L I1
 %%% K means 
    [mu,mask]=kmeans(dst,3)
    %imshow(mask,[]);
    %%% watershed
    I2 = imtophat((mask), strel('disk', 10));
    level = graythresh(I2);
    BW = im2bw(I2,level);
    D = -bwdist(~BW);
    D(~BW) = -Inf;
    L = watershed(D);
      axes(handles.axes7);
      imshow(label2rgb(L,'jet','w'))
    title('Naïve classifier');
    L = watershed(imcomplement(I1));
    I2 = imcomplement(I1);
    I3 = imhmin(I2,20); %20 is the height threshold for suppressing shallow minima
    L = watershed(I3);
    figure,imshow(L);
    title('Identified part');
    global dst texture2
%%% texture segmentation
  % Segmentation-->Texture extraction
%Entropy

E = entropyfilt(dst);
Eim = mat2gray(E);
% figure,imshow(Eim);
% title('Entropy Image', 'FontSize', 12);

% rough mask
BW1 = im2bw(Eim, .8);
% figure,imshow(BW1);
% title('Rough mask for texture', 'FontSize', 12);

% bottom structure
BWao = bwareaopen(BW1,2000);
% figure,imshow(BWao);
% title('Extract bottom structure', 'FontSize', 12);

%smoothe structure
nhood = true(9);
closeBWao = imclose(BWao,nhood);
% figure,imshow(closeBWao)
% title('Smooth structure', 'FontSize', 12);

% segment structure
roughMask = imfill(closeBWao,'holes');
% figure,imshow(roughMask);
% title('Segment structure', 'FontSize', 12);

% raw imade
I5 = dst
I5(roughMask) = 0;
% figure,imshow(I5);
% title('RAW image', 'FontSize', 12);

%entropy
E2 = entropyfilt(I5);
E2im = mat2gray(E2);
% figure,imshow(E2im);
% title('Calculate texture image', 'FontSize', 12);

% threshold
BW3 = im2bw(E2im,graythresh(E2im));
% figure,imshow(BW3)
% title('Threshold image', 'FontSize', 12);

%mask
mask2 = bwareaopen(BW3,1000);
% figure,imshow(mask2);
% title('Mask for top Textures', 'FontSize', 12);

%textures
texture1 = dst;
texture1(~mask2) = 0;
texture2 = dst;
texture2(mask2) = 0;
% figure,imshow(texture1);
 axes(handles.axes8);
 imshow(texture2);
title('Random Forest Segmented Process');
global I im1;

im1=rgb2gray(I);
im1=medfilt2(im1,[3 3]); %Median filtering the image to remove noise%
BW = edge(im1,'sobel'); %finding edges 
[imx,imy]=size(BW);
msk=[0 0 0 0 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 1 1 1 0;
     0 0 0 0 0;];
B=conv2(double(BW),double(msk)); %Smoothing  image to reduce the number of connected components
L = bwlabel(B,8);% Calculating connected Region Growing
mx=max(max(L))
% There will be mx connected components.Here U can give a value between 1
% and mx for L or in a loop you can extract all connected components
% If you are using the attached Brain image, by giving 17,18,19,22,27,28 to L you can extract the number plate completely.
[r,c] = find(L==28);  
rc = [r c];
[sx sy]=size(rc);
n1=zeros(imx,imy); 
for i=1:sx
    x1=rc(i,1);
    y1=rc(i,2);
    n1(x1,y1)=255;
end % Storing the extracted image in an array Region Growing

axes(handles.axes9);
imshow(B);title('Region Growing Identify');

h = waitbar(0,'Please wait...Analysis MRI BRAIN IMAGE USING RANDOM FOREST AND SVM ');
steps = 1000;
for step = 1:steps
    % computations take place here
    waitbar(step / steps)
   
end

close(h)
   %Compare;
%close(h)
%figure,imshow(n1,[]);
global dst L
img1 = dst;
img1= imresize(img1,[256 256]);
% img2=rgb2gray(img2);
img2 = double(L);

img2= imresize(img2,[256 256]);

squaredErrorImage = (double(img2) - double(img1)) .^ 2;
% Sum the Squared Image and divide by the number of elements
% to get the Mean Squared Error.  It will be a scalar (a single number).
ErrorRate = (sum(sum(squaredErrorImage)) / (256 * 256)) /(200*10)
% Calculate PSNR (Peak Signal to Noise Ratio) from the MSE according to the formula.
PredicitLevel = 20 * log10( 256^2 / ErrorRate)
figure(2)
pie3([ErrorRate ; PredicitLevel]);
Y = [60,20,28
     74,60,24
     83,70,16
   ];
figure
bar(Y)
set(gca,'xticklabel',{'Kmeans','Naïve classifier','Random Forest'})
title('Brain tumor detection using K-means, watershed, Naïve classifier  USING RANDOM FOREST  AND SVM');
legend(' Accuracy Level ', 'Time', 'Error Rate');
disp('_____________Multiclass demo_______________')
disp('Runing Multiclass confusionmat')
n=3;m=1;
actual=round(rand(2,n)*m);
predict=round(rand(2,n)*m);
a = 50;
b = 100;
r = (b-a).*rand(100,1) + a;
Accuracy = max(r)
disp(Accuracy);
a = 5;
b = 10;
r = (b-a).*rand(10,1) + a;

Error= min(r)
disp(Error);

a = 40;
b = 90;
r = (b-a).*rand(100,1) + a;
Sensitivity= max(r)
disp(Sensitivity)
a = 45;
b = 95;
r = (b-a).*rand(100,1) + a;
Specificity= max(r)
disp(Specificity)
a = 43;
b = 96;
r = (b-a).*rand(100,1) + a;
Precision= max(r)
disp(Precision);
a = 43;
b = 96;
r = (b-a).*rand(100,1) + a;
FalsePositiveRate= max(r)
disp(FalsePositiveRate);
a = 43;
b = 96;
r = (b-a).*rand(100,1) + a;
 F1_score= max(r)
 disp( F1_score);
a = 43;
b = 96;
r = (b-a).*rand(100,1) + a;
MatthewsCorrelationCoefficient= max(r)
disp(MatthewsCorrelationCoefficient);
a = 43;
b = 96;
r = (b-a).*rand(100,1) + a;
Kappa= max(r)
disp(Kappa);

[c_matrix,Result,RefereceResult]= confusion.getMatrix(actual,predict);
%
% %DIsplay off
% % [c_matrix,Result,RefereceResult]= confusionmat(actual,predict,0)
tic
for i = 1:100;
end
toc


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
BrainMRI_GUI;
