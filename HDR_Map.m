function HDR_img = HDR_Map(images, g, lE, ln_t, w, P)
    length = size(images{1});
    lE = zeros(length);
    
    for pixel = 1:length
        sum_w = 0;
        for j = 1:P
            Zij = images{j}(pixel); 
            lE(pixel) = lE(pixel) + w(Zij+1)*(g(Zij+1)-ln_t(j));
            sum_w = sum_w + w(Zij+1);
        end
        lE(pixel) = lE(pixel)/sum_w;
    end
    HDR_img = exp(lE);
    %index = find(isnan(HDR_img) | isinf(HDR_img));
    %HDR_img(index) = 0;
end