lambda = 10;
samples = 200;

Images = {};

directory = 'pic/';
files = dir([directory, '*.jpg']);
j = length(files);

img_info = imfinfo([directory, files(1).name]);
imgRow = img_info.Height;
imgCol = img_info.Width;
img_array = zeros(imgRow, imgCol, 3, j);
gimg_array = zeros(imgRow, imgCol, j);
Exposures = zeros(j);

disp('Get images from directory');
for i = 1 : j
	ImagePath = [directory, files(i).name];
	img = imread(ImagePath);
	img_array(:, :, :, i) = img;
	gimg_array(:, :, i) = rgb2gray(img);
	info = imfinfo(ImagePath);
	Exposures(i) = info.DigitalCamera.ExposureTime;
end

disp('Image Alignment');
for i = 1 : j - 1
	shift_rtn = zeros(2, 1);
	shift = zeros(2, 1);
	shift = alignment(gimg_array(:, :, i), gimg_array(:, :, i + 1), 4, shift_rtn);
	disp(shift);
	img_array(:, :, :, i + 1) = imtranslate(img_array(:, :, :, i + 1), shift,'FillValues',0);
	gimg_array(:, :, i + 1) = imtranslate(gimg_array(:, :, i + 1), shift,'FillValues',0);
end

for i = 1:j
    Images{i} = reshape(img_array(:, :, :, i), imgRow*imgCol, 3);
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
for i = 0:255
    w(i+1) = min(i, 255-i);
end


for color = 1:channel
    [g{color}, lE{color}] = gsolve(simage{color}, ln_t, lambda, w);
end

disp('Construct HDR radiance map');
HDR_img = reshape(HDR_Map(Images, g, ln_t, w, j), imgRow, imgCol, 3);
figure, imshow(HDR_img), title('HDR image');
disp('Write HDR image to file');
writeHDR(HDR_img, 'img');

tone_img = ToneMapping('global', HDR_img);
writeHDR(tone_img, 'TM_global_img');
imwrite(tone_img, 'TM_global.png');

tone_img = ToneMapping('local', HDR_img);
writeHDR(tone_img, 'TM_local_img');
imwrite(tone_img, 'TM_local.png');
% Remove code before upload
%disp('Draw response curves')

disp('done');
%figure,drawImage(R_g, G_g, B_g);
