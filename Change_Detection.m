clear
close all
clc

load('geocoded_data.mat')

% Extract absolute values of SAR images
abs_SAR_image_master = abs(M);
abs_SAR_image_slave = abs(S);

figure
subplot(2, 1, 1);
histogram(abs_SAR_image_master);
title('Histogram of Master');
xlabel('Magnitude');
ylabel('Frequency');

subplot(2, 1, 2);
histogram(abs_SAR_image_slave);
title('Histogram of Slave');
xlabel('Magnitude');
ylabel('Frequency');

% 3.1 Plot the two images side by side
figure
subplot(1, 2, 1);
grid2image(abs_SAR_image_master, R);
caxis([0 1.8]);
colormap("bone");
title('SAR Image - Master');
colorbar;

subplot(1, 2, 2);
grid2image(abs_SAR_image_slave, R);
caxis([0 1.8]);
colormap("bone");
title('SAR Image - Slave');
colorbar;

% 3.2 Exporting .tif files (They have been commented to prevent new files 
%                           from being created on your computer.)
%geotiffwrite("SAR_Master.tif", abs_SAR_image_master, R)
%geotiffwrite("SAR_Slave.tif", abs_SAR_image_slave, R)


% 3.3 Reducing the speckle noise by implementing a Gaussian Filter
filter_size = 5;
standard_deviation = 2; 

% Applying Gaussian filter to master
filtered_image_master = imgaussfilt(abs_SAR_image_master, standard_deviation, 'FilterSize', filter_size);
figure
grid2image(filtered_image_master, R);
caxis([0 1.8]);
colormap("bone");
title('Filtered SAR Image - Master');
colorbar;

% Applying Gaussian filter to slave
filtered_image_slave = imgaussfilt(abs_SAR_image_slave, standard_deviation, 'FilterSize', filter_size);
figure
grid2image(filtered_image_slave, R);
caxis([0 1.8]);
colormap("bone");
title('Filtered SAR Image - Slave');
colorbar;

%geotiffwrite("Filtered_SAR_Master.tif", filtered_image_master, R)
%geotiffwrite("Filtered_SAR_Master.tif", filtered_image_slave, R)


% 3.4 The changes between master and slave SAR amplitude images
change_image = abs(M) - abs(S);

figure
histogram(change_image);
title('Histogram of Amplitude Changes Between Master and Slave');
xlabel('Magnitude');
ylabel('Frequency');

figure
grid2image(change_image,R);
caxis([0 1.8]);
title('Amplitude Changes Between Master and Slave Images');
colormap(bone);
colorbar;

%geotiffwrite("Change_SAR.tif", change_image, R)


%% 3.5 Interferometric coherence
 clear; close all; clc
load('geocoded_data.mat');
window_sizes = [3, 5, 10, 15];

progress_bar = waitbar(0, 'Processing...','Name',"Progress Bar");

% Plot interferometric coherence for different window sizes
for i = 1:length(window_sizes)
    waitbar(i / length(window_sizes), progress_bar, sprintf('Processing Window Size %d...', window_sizes(i)));

    window_size = window_sizes(i);
    sum_MS_conjugate = conv2(M .* conj(S), ones(window_size) / window_size^2, 'same');
    sum_mag_squared_M = conv2(abs(M).^2, ones(window_size) / window_size^2, 'same');
    sum_mag_squared_S = conv2(abs(S).^2, ones(window_size) / window_size^2, 'same');

    interferometric_coherence = sum_MS_conjugate ./ sqrt(sum_mag_squared_M .* sum_mag_squared_S);
    
    figure
    grid2image(abs(interferometric_coherence), R);
   
    title(['Interferometric Coherence (Window Size = ' num2str(window_size) ')']);
    colormap('bone');
    colorbar;

    %geotiffwrite(['tiffcoherence' num2str(window_size) '.tif'], abs(interferometric_coherence), R);
end

close(progress_bar);

