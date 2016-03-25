j = 13;
lambda = 10;
samples = 200;

Images = {};
Exposures = zeros(j);
for i = 1:j
    ImagePath = sprintf('exposures/img%02d.jpg', i);
    disp(['Reading ',ImagePath]);
    img = imread(ImagePath);
    if i == 1
       [imgRow, imgCol, channel]= size(img);
    end
    Images{i} = reshape(img, imgRow*imgCol, 3);
    
    % Get the exposure time
    info = imfinfo(ImagePath);
    Exposures(i) = info.DigitalCamera.ExposureTime;
end
ln_t = log(Exposures);

disp('Select sample pixels');
rdm = randi([1, imgRow * imgCol], 1, samples);
simage = {};
for number = 1:j
    for pixel = 1:samples
        for color = 1:channel
            simage{color}(pixel, number) = Images{number}(rdm(pixel), color);
        end
    end
end

disp('solve g function');
g = {};
lE = {};
for color = 1:channel
    
    [g{color}, lE{color}] = gsolve(simage{color}, ln_t, lambda, w);
end

for i = 0:255
    w(i+1) = min(i, 255-i);
end

disp('Construct HDR radiance map');
HDR_img = reshape(HDR_Map(Images, g, ln_t, w, j), imgRow, imgCol, 3);
figure, imshow(HDR_img), title('HDR image');

disp('Write HDR image to file');
writeHDR(HDR_img);

% Remove code before upload
disp('Draw response curves')
%figure,drawImage(R_g, G_g, B_g);