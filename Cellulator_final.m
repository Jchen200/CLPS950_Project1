image = imread('/Users/jacquelinecho/Downloads/cell.png');

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

%to correct the cell count to be more accurate, we want to calculate a
%minimum and maximum size threshold for the cells
statistics = regionprops('table', binary_image, 'Area');
mean_size = mean(statistics.Area);
standard_deviation_size = std(statistics.Area);
minimum_size_threshold = mean_size - standard_deviation_size;
maximum_size_threshold = mean_size + standard_deviation_size;

%convert the image into a matrix with zeros. we can use this matrix to
%track the number of pixels that belong in an individual cell. then, we
%initialize the num_cells variable to begin counting before our for loop.
[x,y] = size(binary_image);
matrix_image = zeros(x,y);
num_cells = 0;

%we want to write a loop that will go through each of the pixels of the
%binary image and check if it is part of a cell.
for iter = 1:x
    for iter2 = 1:y
        if binary_image(iter,iter2) == 0 && matrix_image(iter,iter2) == 0
            num_cells = num_cells + 1;
            queue = [iter,iter2];
            pixel_count = 0;
            max_count = x*y;
            while ~isempty(queue) 
                current_queue = queue(1,:);
                queue(1,:) = [];
                current_queue_row = current_queue(1);
                current_queue_column = current_queue(2);
                matrix_image(current_queue_row, current_queue_column)= num_cells;
                pixel_count = 1+pixel_count;
                for iter3 = current_queue_row-1:current_queue_row+1
                    for iter4 = current_queue_column-1:current_queue_column+1;
                        if iter3 <= x && iter3 >= 1 && iter4 <= y && iter4 >= 1
                            if binary_image(iter3,iter4) == 0 && matrix_image(iter3,iter4) == 0
                                queue(end+1,:) = [iter3,iter4];
                                matrix_image(iter3,iter4) = num_cells;
                                pixel_count = pixel_count + 1;
                            end
                        end
                    end
                end
            end
             %check to see if the identified cells are within the minimum
            %and maximum size threshold
            if pixel_count < minimum_size_threshold 
                matrix_image(matrix_image == num_cells) = 0;
                num_cells = num_cells - 1; 
            end
            if pixel_count > maximum_size_threshold
                matrix_image(matrix_image == num_cells) = 0;
                num_cells = num_cells + 4;
            end
        end
    end
end


            %calculate the cell concentration 
            volume = 20; %in microliters
            end_volume = volume/1000;
            concentration = num_cells/end_volume;

            %display the total cell count and concentration of the image as
            %a figure
            fprintf('Total Cell Count: %d\n', num_cells);
            disp(['Cell Concentration = ', num2str(concentration), 'cells/mL']);
            figure;
            colormap(gray);
            imagesc(matrix_image);
            title('Cell Count and Concentration');
            axis off;

            title(sprintf('Total Cell Count: %d\nConcentration: %d cells/mL', num_cells, concentration));
            



            