j = 13;

Img = {};
Exposure = zeros(j,1);
Y_Image = {};
for i = 1:j
    ImagePath = sprintf('/Users/Daphne/Desktop/NTU/�j�T�U/�Ʀ��ı�ĪG/HDR_hw/exposures/img%02d.jpg', i);
    img = imread(ImagePath);
    Images{i} = img; 
   	info = imfinfo(ImagePath);
    Exposures(i) = info.DigitalCamera.ExposureTime;
    disp(ImagePath);
    imshow(Images{i});
    
    disp(size(Images{i}));
    imageSize = size(Images{i});
    YCBCR = rgb2ycbcr(Images{i});
    Y_Image{i} = YCBCR(1:imageSize(1), 1:imageSize(2), 1);
    imshow(Y_Image{i});
end
disp(Exposures);
ln_t = log(Exposures);
disp(ln_t);

%[g, lE] = gsolve(Z, B, l, w)