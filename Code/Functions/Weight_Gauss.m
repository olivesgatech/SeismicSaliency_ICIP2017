function [ Pix_Arr ] = Weight_Gauss( Pix_Arr )

            
    switch length(Pix_Arr) 
        case 1  % Window 3
        case 2  % Window 5
            Pix_Arr = Pix_Arr(:).*[1; 0.7];
        case 3  % Window 7
            Pix_Arr = Pix_Arr(:).*[1; 0.7; 0.66];
        case 4  % Window 9
            Pix_Arr = Pix_Arr(:).*[1; 0.7; 0.66; 0.5];
        case 5  % Window 11
            Pix_Arr = Pix_Arr(:).*[1; 0.7; 0.66; 0.5; 0.33];
        case 6  % Window 13
            Pix_Arr = Pix_Arr(:).*[1; 0.7; 0.66; 0.5; 0.33; 0.18];
    end


end

