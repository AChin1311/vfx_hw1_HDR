function drawImage(R_g, G_g, B_g)
		x = 1:1:256;

		rResImg = plot(R_g, 'r', 'LineWidth', 1);
		title('Red Response Curve');
		xlabel('pixel value Z');
		ylabel('log exposures X');
		saveas(rResImg, 'images/response_curve/r_response_curve.png');

		gResImg = plot(G_g, 'g', 'LineWidth', 1);
		title('Green Response Curve');
		xlabel('pixel value Z');
		ylabel('log exposures X');
		saveas(gResImg, 'images=/response_curve/g_response_curve.png');

		bResImg = plot(B_g, 'b', 'LineWidth', 1);
		title('Blue Response Curve');
		xlabel('pixel value Z');
		ylabel('log exposures X');
		saveas(bResImg, 'images/response_curve/b_response_curve.png');

		rgbResImg = plot(x, R_g, 'r', x, G_g, 'g', x, B_g, 'b', 'LineWidth', 1);
		title('Camera Response Curve');
		xlabel('pixel value Z');
		ylabel('log exposures X');
		% saveas(rgbResImg, 'rgb_response_curve.png');

end