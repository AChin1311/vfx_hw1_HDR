j = 13;

Img = {};
Exposure = zeros(j,1);
Y_Image = {};
for i = 1:j
    ImagePath = sprintf('/Users/Daphne/Desktop/vfx_hw1_HDR/exposures/img%02d.jpg', i);
    img = imread(ImagePath);
    Images{i} = img; 
   	info = imfinfo(ImagePath);
    Exposures(i) = info.DigitalCamera.ExposureTime;
    disp(ImagePath);
    imshow(Images{i});
end
disp(Exposures);
ln_t = log(Exposures);
disp(ln_t);


%[g, lE] = gsolve(Z, B, l, w)