function dataF_SeisSal = MultiDim_Spectral_Saliency_v05_Simplified(data, wsize)
% Compute 3-D FFT using overlapping windows
% data: SS_Dataset
% wsize(1): Window Size x direction
% wsize(2): Window size y direction
% wsize(3): Window size t direction
% Output
% dataF_SeisSal:  Multidim Spectral FFT

%% Start of program
[M,N,T] = size(data);
wsize_x = wsize(1);    % Window Size x direction
wsize_y = wsize(2);    % Window size y direction
wsize_t = wsize(3);    % window size t direction
hw_x    = (wsize(1)-1)/2;  % Half windows
hw_y    = (wsize(2)-1)/2;
hw_t    = (wsize(3)-1)/2;

% Mirror reflection for border condition; no overlapping in x and y
data_Padded = EdgeMirror3(data, [hw_x, hw_y, hw_t]);

% Projections
% Time
Wt_Time_T_YDir  = zeros(wsize_x,wsize_y,wsize_t);
Wt_Time_S_XZDir = zeros(wsize_x,wsize_y,wsize_t);
% Crossline
Wt_Crl_T_XDir   = zeros(wsize_x,wsize_y,wsize_t);
Wt_Crl_S_YZDir  = zeros(wsize_x,wsize_y,wsize_t);
% Inline
Wt_Inl_T_ZDir   = zeros(wsize_x,wsize_y,wsize_t);
Wt_Inl_S_XYDir  = zeros(wsize_x,wsize_y,wsize_t);

%% Projections Calculations
for i = 1:wsize_x
    for j = 1:wsize_y
        for k = 1:wsize_t
            % Mid points
            i0 = i-1-hw_x;
            j0 = j-1-hw_y;
            k0 = k-1-hw_t;
            tmp= sqrt(i0^2+j0^2+k0^2);
            
            if tmp==0
                % Spectral center (i0=j0=k0=0) being DC value, discard
                Wt_Inl_T_ZDir(i,j,k)  = 0;
                Wt_Inl_S_XYDir(i,j,k) = 0;
                    Wt_Crl_T_XDir(i,j,k)  = 0;
                    Wt_Crl_S_YZDir(i,j,k) = 0;
                        Wt_Time_T_YDir(i,j,k)=0;
                        Wt_Time_S_XZDir(i,j,k)=0;
            else
                % Spectral value is to be divided between the components
                % according to its location in the spectrum.
                % Inline
                Wt_Inl_T_ZDir(i,j,k)   = abs(k0/tmp);               
                Wt_Inl_S_XYDir(i,j,k)  = abs(sqrt(i0^2+j0^2)/tmp);  
                % Crossline
                Wt_Crl_T_XDir(i,j,k)   = abs(j0/tmp);
                Wt_Crl_S_YZDir(i,j,k)  = abs(sqrt(i0^2+k0^2)/tmp);
                % Time
                Wt_Time_T_YDir(i,j,k)  = abs(i0/tmp);
                Wt_Time_S_XZDir(i,j,k) = abs(sqrt(j0^2+k0^2)/tmp);
            end
        end
    end
end

%% Saliency computation
parfor indk = 1:T
    for indj = 1:M
        for indi = 1:N
            % Prepare data cubes and apply 3D FFT
            dataCube = data_Padded(indj:indj+wsize_x-1, indi:indi+wsize_y-1, indk:indk+wsize_t-1);
            specCube = fftshift(fftn(dataCube));
            % **********************************************************************************
            % Seismic Saliency: Spectral projections
            % *********** Inline: 
            Inl_2D  = abs(specCube.*(Wt_Inl_S_XYDir));
            dF_Inl_2D(indj,indi,indk)  = mean(Inl_2D(:));
            % *********** Crossline: 
            Crl_2D  = abs(specCube.*(Wt_Crl_S_YZDir));
            dF_Crl_2D(indj,indi,indk)  = mean(Crl_2D(:));
            % *********** Time: 
            Time_2D = abs(specCube.*(Wt_Time_S_XZDir));
            dF_Time_2D(indj,indi,indk) = mean(Time_2D(:));
        end
    end
end

%% Temporal and Spatial Saliency
% Multi-Dim Spectral projections
dataF_SeisSal{1} = dF_Crl_2D;
dataF_SeisSal{2} = dF_Time_2D;  
dataF_SeisSal{3} = dF_Inl_2D;


