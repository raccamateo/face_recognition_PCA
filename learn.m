function [imgMatrix, meanImage, eigenFaces, projectedImages] = learn(database,K)
%LEARN Extracts the features within a give database
%   INPUT:
%      - database           Database path
%
%   OUTPUT:
%      - imgMatrix          Matrix holding the ID number of the subjects
%      - meanImage          Mean image of all images in the database
%      - eigenFaces         Matrix holding the eigen faces of the images in
%                           the DB
%      - projectedImages    Matrix with the feature vector of each image
%##########################################################################
fprintf("[INFO]:  Using " + database + " database.\n");
databaseChar = char(database);
dBPath = [databaseChar,'/yale*'];
people = dir(dBPath);

%##########################################################################
%% X MATRIX
% Iterates over the folders (subjects) within the database, reads the 
% images of all the subjects and save the pixels values in columns of the 
% xMatrix.
% The subject of each folder is also saved in imgMatrix to be able to map 
% each column with the relevant person.
%##########################################################################
fprintf("[INFO]:  Obtaining X matrix... ");
Xmatrix = [];
imgMatrix = {};
for f = 1:length(people)
    %person = string(people(f).name);
    person = people(f).name;
    personPath=[databaseChar,'/',people(f).name,'/','*.pgm'];
    %images = dir(fullfile(database+"\"+person, "*.pgm"));
    images = dir(personPath);
    for i = 1:length(images)
        imageName = images(i).name;
        %image = imread(database+"\"+person+"\"+imageName);
        imgPath=[databaseChar,'/',person,'/',imageName];
        image = imread(imgPath);
        [rows, cols] = size(image);
        vector = reshape(image', rows*cols, 1);
        Xmatrix = [Xmatrix vector];
        imgMatrix = [imgMatrix, imageName]; %Saving filenames in a matrix
    end
end
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% MEAN IMAGE
% Calculates mean value of each pixel of all images loaded in xMatrix
%##########################################################################
fprintf("[INFO]:  Obtaining mean image... ");
meanImage = mean(Xmatrix,2);
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% DEVIATION MATRIX
% Iterates over all the columns of xMatrix (each image) and substract the
% value of the mean image for each pixel. The result is saved in
% deviationMatrix.
%##########################################################################
fprintf("[INFO]:  Obtaining deviation matrix... ");
samplesNumber = size(Xmatrix,2);
deviationMatrix = [];  
for i = 1 : samplesNumber
    imgDeviation = double(Xmatrix(:,i)) - meanImage;
    deviationMatrix = [deviationMatrix imgDeviation];
end
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% EIGENVECTORS
% Calculates the eigenvectors and the diagonal matrix of the surrogate
% (transposed matrix * matrix) of deviationMatrix.
%##########################################################################
fprintf("[INFO]:  Obtaining eigenvectors... ");
surrogateCovMatrix = deviationMatrix' * deviationMatrix;
[eigenVectors, diagonalMatrix] = eig(surrogateCovMatrix);
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% PRINCIPAL COMPONENT
% Iterates over the diagonal values of diagonalMatrix and stores the
% relevant eigenvectors in principalCompMatrix
%##########################################################################
fprintf("[INFO]:  Obtaining principal component matrix... ");
principalCompMatrix = [];
for i = 1 : size(eigenVectors,2) 
    if(diagonalMatrix(i,i)>1)
        principalCompMatrix = [principalCompMatrix eigenVectors(:,i)];
    end
end
if K>0
principalCompMatrix=principalCompMatrix(:,1:K);
end
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% EIGENFACES
% Calculates the eigenvectors (or eigenfaces) by multipliying 
% deviationMatrix by principalCompMatrix
%##########################################################################
fprintf("[INFO]:  Obtaining eigenfaces... ");
eigenFaces = deviationMatrix * principalCompMatrix; 
fprintf(repmat('\b complete.\n', 1, 1));


%##########################################################################
%% PROJECTED IMAGES
% Calculates the feature vector of each image and stores the result in 
% projectedImages
%##########################################################################
fprintf("[INFO]:  Obtaining projected images... ");
projectedImages = [];
for i = 1 : samplesNumber
    featureVector = eigenFaces' * deviationMatrix(:,i);
    projectedImages = [projectedImages featureVector]; 
end
fprintf(repmat('\b complete.\n', 1, 1));

end
