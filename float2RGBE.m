function RGBE = float2RGBE(Image)
    [row, col, channel] = size(Image);
    RGBE = zeros(row, col, 4);

    % Find the max value amoung R, G, B values in the same pixel
    v = max(Image, [], 3);
    % Find the pixels which values are smaller than 1e - 32
    low = find(v < 1e-32);
    
    % v = v * (2 ^ e)
    [v, e] = log2(v);
    E = 2 .^ e;
    
    % Write R, G, B to RGBE
    for i = 1 : 3
        tmp = round((Image(:, :, i) .* 256) ./ E);
        tmp(low) = 0;
        RGBE(:, :, i) = tmp;
    end

    % Add 128 to e
    e = e + 128;
    e(low) = 0;
    
    % Write Exponent to RGBE
    RGBE(:, :, 4) = e;

end