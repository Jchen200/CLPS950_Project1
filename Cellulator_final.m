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


%we need to fill in the cells as a singlular color so that it will be
%counted as one cell.
filled_image = imfill(~binary_image, 'holes');
imshow(filled_image);

%we are outlining the edges of each cell so that individual cells will be
%counted as one.
edge_detection = edge(filled_image, 'sobel');
imshow(edge_detection);

%we want to find the average number of pixels in one cell. This information
%will be used in future commands to filter through componenets in the
%image.
%pixel_size = regionprops(edge_detection,'PixelValues');
%average_pixel = average(pixel_size)
