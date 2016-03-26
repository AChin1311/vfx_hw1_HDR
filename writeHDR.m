function writeHDR(Image)

	fd = fopen('img.hdr', 'w');
	[row, col, channel] = size(Image);

    % Write necessary information to file
	fprintf(fd,'#?RADIANCE\n');
    fprintf(fd,'FORMAT=32-bit_rle_rgbe\n');
    fprintf(fd,'EXPOSURE= 1.0000000000000\n\n');
    fprintf(fd,'-Y %d +X %d\n', row, col);

    % Convert float to RGBE
    RGBEbuffer = float2RGBE(Image);

    % Reshape of data
    data = zeros(row * col * 4, 1);

    for i = 1 : 4;
		C = i : 4 : (row * col * 4);
		data(C) = reshape(RGBEbuffer(:, :, i)', row * col, 1);
    end

    % Write image data to file
    fwrite(fd, data,'uint8');
    fclose(fd);

end