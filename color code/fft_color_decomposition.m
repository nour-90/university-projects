%========================================
% COLOR FREQUENCY DOMAIN FILTERING
%========================================
clc;
close all;
clear;

pkg load image;


%% -------------------------------------------------------
%  LOAD IMAGE
%% -------------------------------------------------------

img = imread('kid.png');

% Figure 1: Original Color Image
figure('Name', 'Original Color Image');
imshow(img);
title('Original Color Image');


%% -------------------------------------------------------
%  PREPARE DATA
%% -------------------------------------------------------

img_d = double(img);

R = img_d(:,:,1);
G = img_d(:,:,2);
B = img_d(:,:,3);


%% -------------------------------------------------------
%  FFT — BEFORE SHIFT
%% -------------------------------------------------------

FR2 = fft2(R);
FG2 = fft2(G);
FB2 = fft2(B);

% Log-magnitude before shift
FR_mag_before = log(1 + abs(FR2));
FG_mag_before = log(1 + abs(FG2));
FB_mag_before = log(1 + abs(FB2));

% Normalize to [0, 255]
FR_before_norm = FR_mag_before / max(FR_mag_before(:) + eps) * 255;
FG_before_norm = FG_mag_before / max(FG_mag_before(:) + eps) * 255;
FB_before_norm = FB_mag_before / max(FB_mag_before(:) + eps) * 255;

% Figure 2: Combined color spectrum before shift
color_spectrum_before = uint8(cat(3, FR_before_norm, FG_before_norm, FB_before_norm));

figure('Name', 'Combined Color Spectrum (Before Shift)');
imshow(color_spectrum_before);
title('Combined Color Log Magnitude Spectrum (Before Shift)');


%% -------------------------------------------------------
%  FFT — AFTER SHIFT
%% -------------------------------------------------------

FR = fftshift(FR2);
FG = fftshift(FG2);
FB = fftshift(FB2);

% Log-magnitude after shift
FR_mag_after = log(1 + abs(FR));
FG_mag_after = log(1 + abs(FG));
FB_mag_after = log(1 + abs(FB));

% Normalize to [0, 255]
FR_after_norm = FR_mag_after / max(FR_mag_after(:) + eps) * 255;
FG_after_norm = FG_mag_after / max(FG_mag_after(:) + eps) * 255;
FB_after_norm = FB_mag_after / max(FB_mag_after(:) + eps) * 255;

% Figure 3: Combined color spectrum after shift
color_spectrum_after = uint8(cat(3, FR_after_norm, FG_after_norm, FB_after_norm));

figure('Name', 'Combined Color Spectrum (After Shift)');
imshow(color_spectrum_after);
title('Combined Color Log Magnitude Spectrum (After Shift)');


%% -------------------------------------------------------
%  RGB CHANNELS SPECTRUM — BEFORE SHIFT
%% -------------------------------------------------------

% Figure 4: R, G, B log spectra before shift
figure('Name', 'RGB Log Magnitude Spectrum (Before Shift)');

subplot(1, 3, 1);
imshow(uint8(FR_before_norm));
title('Red Channel (Before Shift)');
axis on;

subplot(1, 3, 2);
imshow(uint8(FG_before_norm));
title('Green Channel (Before Shift)');
axis on;

subplot(1, 3, 3);
imshow(uint8(FB_before_norm));
title('Blue Channel (Before Shift)');
axis on;


%% -------------------------------------------------------
%  RGB CHANNELS SPECTRUM — AFTER SHIFT
%% -------------------------------------------------------

% Figure 5: R, G, B log spectra after shift
figure('Name', 'RGB Log Magnitude Spectrum (After Shift)');

subplot(1, 3, 1);
imshow(uint8(FR_after_norm));
title('Red Channel (After Shift)');
axis on;

subplot(1, 3, 2);
imshow(uint8(FG_after_norm));
title('Green Channel (After Shift)');
axis on;

subplot(1, 3, 3);
imshow(uint8(FB_after_norm));
title('Blue Channel (After Shift)');
axis on;

% This part just shows the results and compare it

%% -------------------------------------------------------
%  CREATE CIRCULAR FILTER MASKS
%% -------------------------------------------------------

[row, col] = size(R);
radius = 10;
rm     = row / 2;
clm    = col / 2;

[x, y] = meshgrid(-clm:clm-1, -rm:rm-1);
z  = sqrt(x.^2 + y.^2);

cL = z < radius;   % Low-pass  mask (1: inside, 0:outside)
cH = ~cL;          % High-pass mask (0:inside, 1:outside)


%% -------------------------------------------------------
%  APPLY LOW-PASS FILTER
%% -------------------------------------------------------

FR_low = FR .* cL;
FG_low = FG .* cL;
FB_low = FB .* cL;

R_low = real(ifft2(ifftshift(FR_low)));
G_low = real(ifft2(ifftshift(FG_low)));
B_low = real(ifft2(ifftshift(FB_low)));

low_img = uint8(cat(3, ...
    min(max(R_low, 0), 255), ...
    min(max(G_low, 0), 255), ...
    min(max(B_low, 0), 255)));


%% -------------------------------------------------------
%  APPLY HIGH-PASS FILTER
%% -------------------------------------------------------

FR_high = FR .* cH;
FG_high = FG .* cH;
FB_high = FB .* cH;

R_high = real(ifft2(ifftshift(FR_high))) + 128;
G_high = real(ifft2(ifftshift(FG_high))) + 128;
B_high = real(ifft2(ifftshift(FB_high))) + 128;

high_img = uint8(cat(3, ...
    min(max(R_high, 0), 255), ...
    min(max(G_high, 0), 255), ...
    min(max(B_high, 0), 255)));


%% -------------------------------------------------------
%  FIGURE 6: MASKS + FILTERED RESULTS
%% -------------------------------------------------------

figure('Name', 'Filter Masks and Results');

subplot(2, 2, 1);
imshow(cL, []);
title('Low-pass Filter Mask');
axis on;

subplot(2, 2, 2);
imshow(cH, []);
title('High-pass Filter Mask');
axis on;

subplot(2, 2, 3);
imshow(low_img);
title('Low-pass Color Image');
axis on;

subplot(2, 2, 4);
imshow(high_img);
title('High-pass Color Image');
axis on;
