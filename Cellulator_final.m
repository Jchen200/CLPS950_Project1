image = imread('/Users/jacquelinecho/Downloads/cell.png');
grayimage = rgb2gray(image);
imshow(grayimage)

%using a 2D median filtering command to remove the background noise, which
%allows us to ignore any non-cellular components in the image
noise_removal = medfilt2(grayimage)