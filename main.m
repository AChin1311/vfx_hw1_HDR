j = 13;

Images = {};
Exposures = zeros(j,1);
Y_Image = {};
Red = {};
Green = {};
Blue = {};
for i = 1:1
    % Read images
    ImagePath = sprintf('exposures/img%02d.jpg', i);
    disp(ImagePath);
    img = imread(ImagePath);
    Images{i} = img; 
   	% Get exposure time of the image
    info = imfinfo(ImagePath);
    Exposures(i) = info.DigitalCamera.ExposureTime;
    
    red = img(:,:,1); % Red channel
    green = img(:,:,2); % Green channel
    blue = img(:,:,3); % Blue channel
    Red{i} = red(:);
    Green{i} = green(:);
    Blue{i} = blue(:);
    
    % Debug
    a = zeros(size(img, 1), size(img, 2));
    just_red = cat(3, red, a, a);
    just_green = cat(3, a, green, a);
    just_blue = cat(3, a, a, blue);
    figure, imshow(img), title('Original image')
    figure, imshow(just_red), title('Red channel')
    figure, imshow(just_green), title('Green channel')
    figure, imshow(just_blue), title('Blue channel')
end

disp(Exposures);
ln_t = log(Exposures);
disp(ln_t);


%[g, lE] = gsolve(Z, B, l, w)