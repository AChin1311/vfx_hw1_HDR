j = 13;

Images = {};
Exposure = zeros(j,1);
Y_Image = {};
for i = 1:j
    ImagePath = sprintf('exposures/img%02d.jpg', i);
    img = imread(ImagePath);
    Images{i} = img; 
   	info = imfinfo(ImagePath);
    Exposures(i) = info.DigitalCamera.ExposureTime;
    disp(ImagePath);
    imshow(Images{i});
end

[imgRow, imgCol, channel]= size(Images{1});
disp(imgRow);
disp(imgCol);
disp(channel);

% Select 200 pixels randomly
rdm = randi([1, 768 * 1024], 1, 200);
disp(rdm);

% filling z matrix
zimage = zeros(200, j, channel);


%disp(Exposures);
ln_t = log(Exposures);
%disp(ln_t);

% random select pixels

% [g, lE] = gsolve(Z, B, l, w)