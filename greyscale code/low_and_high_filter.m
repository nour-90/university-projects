%========================================
% GRAYSCALE FREQUENCY DOMAIN FILTERING
%========================================

clc;
close all;
clear;

%% Load required packages
pkg load image;

% Load image and convert to grayscale
img = imread('kid.png');
img = rgb2gray(img);
figure, imshow(img)

% Compute 2D FFT
ft2 = fft2(double(img));
ft = fftshift(ft2);       % shift low frequency into the centre
Fmag = log(1 + abs(ft2));
fftshiftmag = fftshift(Fmag);

figure('Name','Magnitude Fourier');
imshow(Fmag, []);

figure('Name','Fourier frequency shift');
imshow(fftshiftmag, []);

% Create circular filters
[row, col] = size(ft);
radius = 40;
rm = row / 2;
clm = col / 2;
[x, y] = meshgrid(-rm:rm-1, -clm:clm-1);
z = sqrt(x.^2 + y.^2);  % distance from center
cL = z < radius;         % Low filter: 1 inside circle, 0 outside
cH = ~cL;                % High filter: 1 outside circle, 0 inside

% Apply filters in frequency domain
l_ft = ft .* cL;
h_ft = ft .* cH;

% Inverse FFT to get spatial domain images
low_filtered_image = ifft2(ifftshift(l_ft));
high_filtered_image = ifft2(ifftshift(h_ft));
low_f = uint8(real(low_filtered_image));
high_f = uint8(real(high_filtered_image));

% Display results
figure
subplot(2, 2, 1); imshow(cL, []); title('Low-frequency filter'); axis on;
subplot(2, 2, 2); imshow(cH, []); title('High-frequency filter'); axis on;
subplot(2, 2, 3); imshow(low_f, []); title('Low-frequency-image'); axis on;
subplot(2, 2, 4); imshow(high_f, []); title('High-frequency-image'); axis on;
