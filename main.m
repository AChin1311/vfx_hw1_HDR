%j = 13;
j = 16;

lambda = 10;
Images = {};
%Exposures = zeros(j,1);

Exposures = [0.03125 0.0625 0.125 0.25 0.5 1 2 4 8 16 32 64 128 256 512 1024];
disp(Exposures);

Red = {};
Green = {};
Blue = {};
for i = 1:j

    % Read a Image
    %ImagePath = sprintf('exposures/img%02d.jpg', i);
    ImagePath = sprintf('Memorial_SourceImages/memorial%04d.png', 60+i);
    
    disp(['Reading ',ImagePath]);
    img = imread(ImagePath);
    Images{i} = img; 
   	% Get the exposure time
%     info = imfinfo(ImagePath);
%     disp(info.DigitalCamera);
%     Exposures(i) = info.DigitalCamera.ExposureTime;
    
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


% fileID = fopen('Memorial_SourceImages/memorial.hdr_image_list.txt');
% tline = fgetl(fileID); % Read first line
% tline = fgetl(fileID); % Read Number of Images
% j = sscanf(tline, '%d');
% tline = fgetl(fileID); % Read File Name....
% % format: memorial0061.ppm 0.03125 8 0 0
% C = textscan(fileID,'%s %f %d %d %d');
% disp(C{2});
% fclose(fileID);
% Exposures = str2double(C{2});

disp(Exposures);
ln_t = log2(Exposures);
disp(ln_t);


% Select 200 pixels randomly
rdm = randi([1, imgRow * imgCol], 1, 200);
%disp(rdm);

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

%disp(Rimage);
%disp(Gimage);
%disp(Bimage);

% weight function
for i = 0:255
    w(i+1) = min(i, 255-i);
end

[R_g, R_lE] = gsolve(Rimage, ln_t, lambda, w);
[G_g, G_lE] = gsolve(Gimage, ln_t, lambda, w);
[B_g, B_lE] = gsolve(Bimage, ln_t, lambda, w);

% Construct HDR radiance map
disp('Construct HDR map');

HDR_img = zeros(imgRow, imgCol, 3);
HDR_img_R = HDR_Map(Red, R_g, R_lE, ln_t, w, j);
HDR_img(1:imgRow, 1:imgCol, 1) = reshape(HDR_img_R, imgRow, imgCol);
HDR_img_G = HDR_Map(Green, G_g, G_lE, ln_t, w, j);
HDR_img(1:imgRow, 1:imgCol, 2) = reshape(HDR_img_G, imgRow, imgCol);
HDR_img_B = HDR_Map(Blue, B_g, B_lE, ln_t, w, j);
HDR_img(1:imgRow, 1:imgCol, 3) = reshape(HDR_img_B, imgRow, imgCol);
figure, imshow(HDR_img), title('HDR image');

% Remove code before upload
disp('draw response curves');
drawImage(R_g, G_g, B_g);
