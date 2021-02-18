cigarImage = rgb2gray(imread('cigar.png'));  % read images
OriginalJokerImage = imread('jokerimage.png');
% convert image to gray because detectSURFFeatures uses gray images (2
% dimensional matrices)
GrayJokerImage = rgb2gray(OriginalJokerImage); 

cigarPoints = detectSURFFeatures(cigarImage); % Detect feature points in both images
jokerPoints = detectSURFFeatures(GrayJokerImage);

%Extract feature descriptors at the interest points in both images.
[cigarFeatures, cigarPoints] = extractFeatures(cigarImage, cigarPoints); 
[jokerFeatures, jokerPoints] = extractFeatures(GrayJokerImage, jokerPoints);

% take common features
cigarPairs = matchFeatures(cigarFeatures, jokerFeatures);

matchedCigarPoints = cigarPoints(cigarPairs(:, 1), :);
matchedJokerPoints = jokerPoints(cigarPairs(:, 2), :);

%tform has the indexes of matching cigar object in gray joker image
[tform, inlierCigarPoints, inlierJokerPoints] = ...
    estimateGeometricTransform(matchedCigarPoints, matchedJokerPoints, 'affine');

%creating an imaginary rectangle as the size of detected cigar
cigarPolygon = [1, 1;...                           % top-left
        size(cigarImage, 2), 1;...                 % top-right
        size(cigarImage, 2), size(cigarImage, 1);... % bottom-right
        1, size(cigarImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon
    
% defining correct place of rectangle with reindexing tform     
newCigarPolygon = transformPointsForward(tform, cigarPolygon);
flower = imread('flower.png');

%taking the middle of the detected object
verticalmiddle = floor((newCigarPolygon(2,1) + newCigarPolygon(4,1))/2); 
horizantalmiddle = floor((newCigarPolygon(1,2) + newCigarPolygon(3,2))/2);

%putting flower to the middle of polygon so that it covers cigar
OriginalJokerImage( floor( verticalmiddle - size(flower,1)/2) : floor(verticalmiddle + size(flower,1)/2) -1 ,...
    floor(horizantalmiddle - size(flower,2)/2) : floor(horizantalmiddle + size(flower,2)/2) -1,...
    1:3) = flower;

imwrite(OriginalJokerImage,'censored.png','png');