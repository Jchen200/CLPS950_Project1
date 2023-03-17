image = imread('/Users/josephinechen/Downloads/cell.png');

%first, we are loading the image in grayscale to remove any colors that
%would disrupt cell counting.
grayimage = rgb2gray(image);
imshow(grayimage);


%using a 2D median filtering command to remove the background noise, which
%allows us to ignore any non-cellular components in the image
noise_removal = medfilt2(grayimage);
imshow(noise_removal);


%using Otsu's method, we convert our grayscale image to a binary image to
%allow for easier counting of cells. the first step is to calculate a
%threshold using the command 'graythresh.'
threshold = graythresh(noise_removal);


%then, we binarize the image using the threshold.
binary_image = imbinarize(noise_removal,threshold);
imshow(binary_image)

%convert the image into a matrix with zeros. we can use this matrix to
%track the number of pixels that belong in an individual cell. then, we
%initialize the num_cells variable to begin counting before our for loop.
[x,y] = size(binary_image);
matrix_image = zeros(x,y);
num_cells = 0;

%we want to write a loop that will go through each of the pixels of the
%binary image and check if it is part of a cell.
for x = 1:height
    for y = 1:width
        if binary_image(x,y) == 0 && matrix_image(x,y) == 0
            num_cells = num_cells + 1



