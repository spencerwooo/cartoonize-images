imgPath = 'image2.jpg';

saturation = 0.8;

edgeThreshhold = 0.05;
edgeDetector = 'canny';

sigma = 7;

img = imread(imgPath);

% figure(1)
% imshow(img);

% 1. Saturate
% Add a degree of saturation, to make image colors more vibrant
imgSaturated = saturateImage(img, saturation);

faceDetector = vision.CascadeObjectDetector();
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[0 255 255]);
bbox = step(faceDetector, imgSaturated);
disp(bbox)
% Draw boxes around detected faces and display results
I_faces = step(shapeInserter, imgSaturated, int32(bbox));

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
montage({I_faces, resultImg})
title('Original Image vs. Filtered Image');
% figure(2)
% imshow(resultImg);
