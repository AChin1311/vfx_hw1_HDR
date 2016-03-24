j = 13;

lambda = 10;
Images = {};
Exposures = zeros(j,1);

Y_Image = {};
Red = {};
Green = {};
Blue = {};
for i = 1:j

    % Read a Image
    ImagePath = sprintf('exposures/img%02d.jpg', i);
    disp(['Reading ',ImagePath]);
    img = imread(ImagePath);
    Images{i} = img; 
   	% Get the exposure time
    info = imfinfo(ImagePath);
    Exposures(i) = info.DigitalCamera.ExposureTime;
    % Seperate RGB channels
    red = img(:,:,1); % Red channel
    green = img(:,:,2); % Green channel
    blue = img(:,:,3); % Blue channel
    Red{i} = red(:);
    Green{i} = green(:);
    Blue{i} = blue(:);
    
    % Debug
%     a = zeros(size(img, 1), size(img, 2));
%     just_red = cat(3, red, a, a);
%     just_green = cat(3, a, green, a);
%     just_blue = cat(3, a, a, blue);
%     figure, imshow(img), title('Original image')
%     figure, imshow(just_red), title('Red channel')
%     figure, imshow(just_green), title('Green channel')
%     figure, imshow(just_blue), title('Blue channel')
end

[imgRow, imgCol, channel]= size(Images{1});
disp(imgRow);
disp(imgCol);
disp(channel);

disp(Exposures);
ln_t = log(Exposures);
%disp(ln_t);


% Select 200 pixels randomly
rdm = randi([1, imgRow * imgCol], 1, 200);
disp(rdm);

% filling z matrix
Rimage = zeros(200, j);
Gimage = zeros(200, j);
Bimage = zeros(200, j);

for number = 1:j
	for pixel = 1:200
		Rimage(pixel, number) = Red{number}(rdm(pixel));
		Gimage(pixel, number) = Green{number}(rdm(pixel));
		Bimage(pixel, number) = Blue{number}(rdm(pixel));
	end
end

disp(Rimage);
disp(Gimage);
disp(Bimage);

% weight function
for i = 0:255
    w(i+1) = min(i, 255-i);
end

% [g, lE] = gsolve(Z, B, l, w)