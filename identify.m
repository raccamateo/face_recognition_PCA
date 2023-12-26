%% IDENTIFY FUNCTION

function [subjectID, subjectImg] = identify(img, imgMatrix, meanImage, eigenFaces, projectedImages)
%IDENTIFY Find the best match for a given image and a
% set of features.
%   INPUT:
%      - img                Image to compare against the database
%      - imgMatrix          Matrix holding the ID number of the subjects
%      - meanImage          Mean image of all images in the database
%      - eigenFaces         Matrix holding the eigen faces of the images in
%                           the DB
%      - projectedImages    Matrix with the feature vector of each image
%
%   OUTPUT:
%      - subjectID          Subject's ID number of the closest match
%      - subjectImg         Image of the closest match
%##########################################################################
%% IMAGES FEATURES
% Reads the input image and calculates its PCA features
%##########################################################################
fprintf("[INFO]:  Obtaining PCA features... ");
inputImg = imread(img);
temp = inputImg(:,:,1);
[rows, cols] = size(temp);
InImage = reshape(temp',rows * cols,1);
Difference = double(InImage) - meanImage;
projectedInputImage = eigenFaces' * Difference;
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% EUCLIDEAN DISTANCES
% Calculates the euclidean distances between the input image and the ones
% in the database.
%##########################################################################
fprintf("[INFO]:  Obtaining Euclidean distances... ");
samplesNumber = size(eigenFaces,2);
euclideanDistance = [];
for i = 1 : samplesNumber
    projectedImg = projectedImages(:,i);
    distance = (norm(projectedInputImage - projectedImg))^2;
    euclideanDistance = [euclideanDistance distance];
end
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% SUBJECT ID NUMBER
% Obtains the index of the lowest euclidean distance and uses it to obtain
% the subject's ID number from imgMatrix.
%##########################################################################
fprintf("[INFO]:  Obtaining closest match... ");
[minDistance, recognizedIndex] = min(euclideanDistance);
subjectID = extractBetween(string(imgMatrix(recognizedIndex)), 6, 7);
subjectImg = 'yaleB' + subjectID + '/' + string(imgMatrix(recognizedIndex));
fprintf(repmat('\b complete.\n', 1, 1));

end

