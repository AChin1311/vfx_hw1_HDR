function tone_map_img = ToneMapping(img)
    delta = 1e-6;
    a = 0.18;
    white = 0.5;
    Lw = 0.2126 * img(:,:,1) + 0.7152 * img(:,:,2) + 0.0722 * img(:,:,3);
    LwMean = exp(mean(mean(log(delta + Lw))));
    Lm = (a / LwMean) * Lw;
    Ld = (Lm .* (1 + Lm / (white * white))) ./ (1 + Lm);
    for channel = 1:3
        Cw = img(:,:,channel) ./ Lw;
        tone_map_img(:,:,channel) = Cw .* Ld;
    end
    imwrite(tone_map_img, 'tone_mapped.png');
end