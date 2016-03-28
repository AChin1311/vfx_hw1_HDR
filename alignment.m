function shift = alignment(img1, img2, shift_bits, shift)

	current_shift = zeros(2, 1);

	[row1, col1] = size(img1);
	[row2, col2] = size(img2);

	tb1 = zeros(row1, col1);
	tb2 = zeros(row2, col2);
	eb1 = zeros(row1, col1);
	eb2 = zeros(row2, col2);
    
    % Calculate shift value recursively
    if shift_bits > 0
    	half_img1 = imresize(img1, 0.5);
    	half_img2 = imresize(img2, 0.5);

    	current_shift = alignment(half_img1, half_img2, shift_bits - 1, current_shift);
    	current_shift = current_shift .* 2;
    else
    	current_shift = zeros(2, 1);
    end

    % Construct MTB and EB
    threshold1 = median(img1(:));
    threshold2 = median(img2(:));

    tb1(img1 > threshold1) = 1;
    tb2(img2 > threshold2) = 1;
    eb1(img1 < threshold1 - 4 || img1 > threshold1 + 4) = 1;
    eb2(img2 < threshold2 - 4 || img2 > threshold2 + 4) = 1;

    % Alignment
    min_err = row1 * col1;
    for i = -1 : 1
    	for j = -1 : 1
    		shift_x = current_shift(1) + i;
    		shift_y = current_shift(2) + j;

    		shift_tb2 = imtranslate(tb2, [shift_x, shift_y], 'FillValues', 0);
    		shift_eb2 = imtranslate(eb2, [shift_x, shift_y], 'FillValues', 0);

    		diff_bits = and(and(xor(tb1, shift_tb2), eb1), shift_eb2);
    		err = sum(diff_b(:));

    		if err < min_err
    			shift = [shift_x, shift_y];
    			min_err = err;
    	end
    end

end