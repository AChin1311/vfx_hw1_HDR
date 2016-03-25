function HDR_img = HDR_Map(images, g, ln_t, w, P)
    length = size(images{1}, 1);
    lE = zeros(length, 3);
    
    for color = 1:3
        for pixel = 1:length
            sum_w = 0;
            for j = 1:P
                Zij = images{j}(pixel, color); 
                lE(pixel, color) = lE(pixel, color) + w(Zij+1)*(g{color}(Zij+1)-ln_t(j));
                sum_w = sum_w + w(Zij+1);
            end
            lE(pixel, color) = lE(pixel, color)/sum_w;
        end
    end
    
    HDR_img = exp(lE);
    index = find(isnan(HDR_img) | isinf(HDR_img));
    HDR_img(index) = 0;
end