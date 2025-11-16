clc; clear; close all;

%% ================== PATH SETTINGS ============================
datasetFolder = 'C:\Userse\images';   % Folder path to  images

% Only process these specific HRF images
imageList = {
    '01_dr.jpg'
    '01_g.jpg'
    '01_h.jpg'
    '02_dr.jpg'
    '02_g.jpg'
    '02_h.jpg'
};

fprintf('\n🔍 Looking for HRF images...\n');

%% ================== PROCESS EACH IMAGE =======================
for i = 1:length(imageList)

    fprintf('\n============================================\n');
    fprintf('▶ Processing Image: %s\n', imageList{i});
    fprintf('============================================\n');

    filename = fullfile(datasetFolder, imageList{i});
    if ~exist(filename,'file')
        warning('⚠ Image %s not found. Skipping.', imageList{i});
        continue;
    end

    %% STEP 1: READ + RESIZE
    I = imread(filename);
    I = imresize(I, [512 512]);

    %% STEP 2: GREEN CHANNEL EXTRACTION
    green = im2double(I(:,:,2));

    %% STEP 3: CLAHE CONTRAST ENHANCEMENT
    green_eq = adapthisteq(green, 'ClipLimit', 0.01, 'Distribution', 'rayleigh');


    %% ✅ STEP 4: SVD DENOISING (Keeps Vessel Strong Edges)
    A = green_eq;
    [U,S,V] = svd(A);
    k = 80;   % KEEP TOP SINGULAR VALUES (80 works best for HRF)
    S(k:end,:) = 0;
    svd_clean = U * S * V';
    svd_clean = mat2gray(svd_clean);


    %% ✅ STEP 5: DCT LOW-FREQUENCY ENHANCEMENT
    d = dct2(svd_clean);
    [m,n] = size(d);
    mask = zeros(m,n);
    mask(1:round(m/6),1:round(n/6)) = 1;  % Keep low freq
    d_filt = d .* mask;
    dct_enh = idct2(d_filt);
    dct_enh = mat2gray(dct_enh);


    %% STEP 6: SHARPEN IMAGE (Final Smooth Enhancement)
    sharp_im = imsharpen(dct_enh, 'Radius', 2, 'Amount', 1.8);


    %% STEP 7: FRANGI FILTER (FOR VESSELNESS)
    options = struct('FrangiScaleRange', [1 8], ...
                     'FrangiScaleRatio', 1.5, ...
                     'FrangiBetaOne', 0.5, ...
                     'FrangiBetaTwo', 15, ...
                     'BlackWhite', true, ...
                     'verbose', false);

    vesselness = FrangiFilter2D(sharp_im, options);
    vesselness = mat2gray(vesselness);


    %% STEP 8: ADAPTIVE THRESHOLD + CLEANUP
    T = adaptthresh(vesselness, 0.25);
    bw = imbinarize(vesselness, T);

    bw = imclose(bw, strel('disk', 2));
    bw = bwmorph(bw, 'bridge');
    bw = bwmorph(bw, 'clean');
    bw = bwmorph(bw, 'spur', 5);


    %% STEP 9: RED OVERLAY
    overlay = I;
    overlay(:,:,1) = I(:,:,1) + uint8(bw.*255);


    %% STEP 10: DISPLAY RESULTS
    figure('Name',['Processing - ' imageList{i}], 'NumberTitle','off');

    subplot(3,3,1), imshow(I), title('Original');
    subplot(3,3,2), imshow(green), title('Green Channel');
    subplot(3,3,3), imshow(green_eq), title('CLAHE');

    subplot(3,3,4), imshow(svd_clean), title('SVD Denoised');
    subplot(3,3,5), imshow(dct_enh), title('DCT Enhanced');
    subplot(3,3,6), imshow(sharp_im), title('Sharpened');

    subplot(3,3,7), imshow(vesselness), title('Frangi Vesselness');
    subplot(3,3,8), imshow(bw), title('Final Vessel Segmentation');
    subplot(3,3,9), imshow(overlay), title('Overlay (Final)');

end

disp('✅ Processing Completed Successfully!'); ADD TO THIS ONE