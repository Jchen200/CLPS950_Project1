image = imread('/Users/jacquelinecho/Downloads/cell.png');
grayimage = rgb2gray(image);
imshow(grayimage);

%using a 2D median filtering command to remove the background noise, which
%allows us to ignore any non-cellular components in the image
noise_removal = medfilt2(grayimage);
imshow(noise_removal)

%using Otsu's method, we convert our grayscale image to a binary image to
%allow for easier counting of cells. the first step is to calculate a
%threshold using the command 'graythresh.'
threshold = graythresh(noise_removal);

%then, we binarize the image using the threshold.
binary_image = imbinarize(noise_removal,threshold);
imshow(binary_image)