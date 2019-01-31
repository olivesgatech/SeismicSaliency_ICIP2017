function [ Norm_SS ] = Vol_Normalize( grayImage , rangenorm )

    originalMinValue = double(min(min(min(grayImage))));
    originalMaxValue = double(max(max(max(grayImage))));
    originalRange = originalMaxValue - originalMinValue;

    % Get a double image in the range 0 to +1
    desiredMin = rangenorm(1);
    desiredMax = rangenorm(2);
    desiredRange = desiredMax - desiredMin;

    for i = 1:size(grayImage,3)
        Norm_SS(:,:,i) = desiredRange * (double(grayImage(:,:,i)) - originalMinValue) / originalRange + desiredMin;
    end


end

