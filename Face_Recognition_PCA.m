clc
clear all
close all
% Define database and image to compare
database = "CroppedYale";
img_file = './CroppedYale_Test/yaleB31_P00A-015E+20.pgm';
K=10; % Number of eigenvectors to be considered.
      % If K=0 then, all the eigenvectors are used.
% Run learn function to obtain information from the given database
[imgMatrix, meanImage, eigenFaces, projectedImages] = learn(database,K);
% Run identify function to get closest match of the image within the database
[subjectID, subjectImg] = identify(img_file, imgMatrix, meanImage, eigenFaces, projectedImages);
% Show subject's ID number in console
fprintf("[INFO]:  Subject's ID number is " + subjectID + '.\n');

% Display given image and closest match
subplot(1,2,1);
imshow(imread(img_file));
title('INPUT IMAGE');
subplot(1,2,2);
imshow(imread([char(database),'/',char(subjectImg)]));
title('MATCHED IMAGE - Subject ID: ' + subjectID);