clear; 
close all;
clc

 load('range_azimuth_data.mat')

% 2.1 Plot the absolute value of the image
abs_SAR_image = abs(SAR_image);
space_az = (0:da:length(SAR_image(1,:))*da);
space_range = 0:dr:length(SAR_image(:,1))*dr;

figure
histogram(abs_SAR_image);
title('Histogram of Magnitude of SAR Image');
xlabel('Magnitude');
ylabel('Frequency');

figure
imagesc(space_az,space_range,abs_SAR_image);
caxis([0 1.8]);
colormap("bone");
colorbar;
title('SAR Image of Rotterdam Maritime Port');
xlabel('Azimuth [m]');
ylabel('Range [m]');

%%
%2.3 Resolution of this image

%Creating square waves at the length of da and dr
azimuth_lenght = 0:0.001:2*da;
range_length= 0:0.001:2*dr;

azimuth_pixel = square(2 * pi * (1 / (2*da)) * azimuth_lenght);
range_pixel = square(2 * pi * (1 / (2*dr)) * range_length);


%Taking the FFT to see the zero crossings
fft_azimuth = fftshift(fft(azimuth_pixel));
fft_range = fftshift(fft(range_pixel));

freq_azimuth = linspace(-1/(2*da), 1/(2*da), numel(fft_azimuth));
freq_range = linspace(-1/(2*dr), 1/(2*dr), numel(fft_range));

% The values are found by looking because the zero detecting algorithm
% didn't work.
% Find the frequency values at which FFT crosses zero
%zero_crossings_azimuth = freq_azimuth(find(fft_azimuth >= 0, 1));
%zero_crossings_range = freq_range(find(fft_range >= 0, 1));

zero_crossings_azimuth = 0.028;
zero_crossings_range = 0.005;

resolution_azimuth = 1 / (abs(zero_crossings_azimuth) * length(SAR_image(1,:)));
resolution_range = 1 / (abs(zero_crossings_range) * length(SAR_image(:,1)));

disp(['Azimuth Resolution: ', num2str(resolution_azimuth), ' meters']);
disp(['Range Resolution: ', num2str(resolution_range), ' meters']);

% Plotting the square waves
figure
plot(azimuth_lenght, azimuth_pixel);
title('Square Wave with Length of 0.1883 seconds');
xlabel('Distance (m)');
ylabel('Amplitude');
figure
plot(range_length, range_pixel);
title('Square Wave with Length of 0.4182 seconds');
xlabel('Distance (m)');
ylabel('Amplitude');

%Plotting FFT
figure
subplot(2, 1, 1);
plot(freq_azimuth, abs(fft_azimuth));
title('FFT of Azimuth Pixel');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(freq_range, abs(fft_range));
title('FFT of Range Pixel');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

