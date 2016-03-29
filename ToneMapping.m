function tone_map_img = ToneMapping(type, img)
    a = 0.18;
    delta = 1e-6;     
    Lw = 0.2126 * img(:,:,1) + 0.7152 * img(:,:,2) + 0.0722 * img(:,:,3);
    LwMean = exp(mean(mean(log(delta + Lw))));
    Lm = (a / LwMean) * Lw;
    switch type
        case 'global'
            disp('global tone mapping');
            white = 2.5;
            % white = 0.5;
            Ld = (Lm .* (1 + Lm / (white * white))) ./ (1 + Lm);
            Ld(isnan(Ld))=0;
            
        case 'local'
            disp('local tone mapping');
            phi = 8.0;
            epsilon = 0.05;
            alpha = 0.3;
            Lblur_s = zeros(size(Lw,1), size(Lw,2), 9);
            for i = 0:8
                s = 1.6^i;
                g = fspecial('gaussian', floor(6*s+1), s);
                Lblur_s(:,:,i+1) = imfilter(Lm,g);
                %figure;imshow(Lblur_s(:,:,i+1));
            end
            for i = 1:size(Lw,1)
                for j = 1:size(Lw,2)
                    smax = 1;
                    for k = 0:7
                        s = 1.6^k;
                        denominator = (((2^phi)*alpha)/s*s) + Lblur_s(i,j,k+1);
                        if denominator == 0
                            Vsij = 0;
                        else
                            Vsij = (Lblur_s(i,j,k+1)-Lblur_s(i,j,k+2)) / denominator;
                        end
                        if abs(Vsij) < epsilon
                            smax = k+1;
                        end
                        if (1+Lblur_s(i,j,smax)) == 0
                            Ld(i,j) = 0;
                        else
                            Ld(i,j) = (Lm(i,j) / (1+Lblur_s(i,j,smax))); 
                        end
                    end
                end
            end
    end
    
    for channel = 1:3
        Cw = img(:,:,channel) ./ Lw;
        tone_map_img(:,:,channel) = Cw .* Ld;
    end
end