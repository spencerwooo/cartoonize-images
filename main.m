% % % % % % % % % % % % % % % % % % % % % % % % % 
% Change below according to your configurations %
% % % % % % % % % % % % % % % % % % % % % % % % % 
imgPath = '1.jpg';
url = 'http://192.168.1.7:8080/video';

% Prompt question: form of input
answer = questdlg('Do I fetch the image from local folder or webcam?', ...
    'Question', ...
	'Local image', 'Webcam', 'Local image');
% Handle response
switch answer
    case 'Local image'
        % Load images from local folder
        img = imread(imgPath);
    case 'Webcam'        
        % Get snapshot from webcam
        cam = ipcam(url);
        img = snapshot(cam);
end

f = waitbar(0, 'Loading images...');
saturation = 1.5;
edgeThreshold = 0.15;
edgeDetector = 'canny';
sigma = 10;

f = waitbar(0.25, f, 'Detecting faces...');
faceDetector = vision.CascadeObjectDetector();
bbox = step(faceDetector, img);
disp(bbox)
if isempty(bbox) == 1
    disp('[No face detected]')
else
    saturation = 0.8;
    edgeThreshold = 0.2;
    sigma = 5;
    disp('[Face detected]');
end

% 1. Saturate
% Add a degree of saturation, to make image colors more vibrant
waitbar(0.5, f, 'Adding saturation...');
imgSaturated = saturateImage(img, saturation);

% 2. Bilateral filter
waitbar(0.75, f, 'Smoothing colors...');
% Convert the image to the L*a*b colorspace
imgLAB = rgb2lab(imgSaturated);
% Extract an L*a*b patch that contains no sharp edges
patch = imcrop(imgLAB, [34, 71, 60, 55]);
patchSq = patch.^2;
edist = sqrt(sum(patchSq, 3));
patchVar = std2(edist).^2;
% Filter image with bilateral filtering
smoothness = patchVar * 4;
smoothedLABImg = imbilatfilt(imgLAB, smoothness, sigma);
% Convert the image back to the RGB color space
smoothedRBGImg = lab2rgb(smoothedLABImg, 'Out', 'uint8');

% 3. Highlight edges
waitbar(0.95, f, 'Adding edges...');
imgGray = rgb2gray(smoothedRBGImg);
edgeMask = uint8(edge(imgGray, edgeDetector, edgeThreshold));

% Highlight edges using black color.
resultImg(:,:,1) = smoothedRBGImg(:,:,1) - smoothedRBGImg(:,:,1) .* edgeMask;
resultImg(:,:,2) = smoothedRBGImg(:,:,2) - smoothedRBGImg(:,:,2) .* edgeMask;
resultImg(:,:,3) = smoothedRBGImg(:,:,3) - smoothedRBGImg(:,:,3) .* edgeMask;

% Display result
montage({img, resultImg})
title('Original Image vs. Filtered Image');
close(f);
clear cam;
