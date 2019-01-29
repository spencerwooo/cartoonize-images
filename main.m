img = imread('image.jpg');

figure(1)
imshow(img);

saturation = 2;

edgeThreshhold = 0.02;
edgeDetector = 'sobel';

spatialSigma = 2;

% 1. 提升饱和度
% Add a degree of saturation, to make image colors more vibrant
imgSaturated = saturateImage(img, saturation);

% 2. 弱化细节（区域平滑)
% Convert the image to the L*a*b colorspace
imgLAB = rgb2lab(imgSaturated);
% Extract an L*a*b patch that contains no sharp edges
patch = imcrop(imgLAB, [34, 71, 60, 55]);
patchSq = patch.^2;
edist = sqrt(sum(patchSq, 3));
patchVar = std2(edist).^2;
% Filter image with bilateral filtering
smoothness = patchVar * 4;
smoothedLABImg = imbilatfilt(imgLAB, smoothness, spatialSigma);
% Convert the image back to the RGB color space
smoothedRBGImg = lab2rgb(smoothedLABImg, 'Out', 'uint8');

% 3. 突出边缘线条
imgGray = rgb2gray(smoothedRBGImg);
edgeMask = uint8(edge(imgGray, edgeDetector, edgeThreshhold));

% Highlight edges using black color.
resultImg(:,:,1) = smoothedRBGImg(:,:,1) - smoothedRBGImg(:,:,1) .* edgeMask;
resultImg(:,:,2) = smoothedRBGImg(:,:,2) - smoothedRBGImg(:,:,2) .* edgeMask;
resultImg(:,:,3) = smoothedRBGImg(:,:,3) - smoothedRBGImg(:,:,3) .* edgeMask;

% 显示图像
% montage({img, resultImg})
% title('Original Image vs. Filtered Image');
figure(2)
imshow(resultImg);