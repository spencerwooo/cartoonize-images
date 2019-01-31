imgPath = 'image2.jpg';
img = imread(imgPath);

saturation = 2;
edgeThreshhold = 0.2;
edgeDetector = 'canny';
sigma = 7;

faceDetector = vision.CascadeObjectDetector();
bbox = step(faceDetector, img);
if isempty(bbox) == 1
    disp('[No face detected]')
else
    saturation = 0.8;
    edgeThreshhold = 0.1;
    sigma = 4;
    disp('[Face detected]');
end

% 1. Saturate
% Add a degree of saturation, to make image colors more vibrant
imgSaturated = saturateImage(img, saturation);

% 2. Bilateral filter
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
imgGray = rgb2gray(smoothedRBGImg);
edgeMask = uint8(edge(imgGray, edgeDetector, edgeThreshhold));

% Highlight edges using black color.
resultImg(:,:,1) = smoothedRBGImg(:,:,1) - smoothedRBGImg(:,:,1) .* edgeMask;
resultImg(:,:,2) = smoothedRBGImg(:,:,2) - smoothedRBGImg(:,:,2) .* edgeMask;
resultImg(:,:,3) = smoothedRBGImg(:,:,3) - smoothedRBGImg(:,:,3) .* edgeMask;

% Display result
montage({img, resultImg})
title('Original Image vs. Filtered Image');
