function Comb_Sal = DCS_Comparison( data_Comb, WinSize, Wt_sal )
% data_Comb: Spectral Saliency Data
% WinSize:   Window Size for Center surroudn 1-13 
% Sal_Wt:    Weights to combine saliency maps

%% Parameters
H_Win_i = (WinSize(1)-1)/2;
H_Win_j = (WinSize(2)-1)/2;
H_Win_k = (WinSize(3)-1)/2;

dataF        = data_Comb{1};
dataF_Padded = EdgeMirror3(dataF,[H_Win_i,H_Win_j,H_Win_k]);   

%% Calculate saliency map
% Horizontal
i_ind = 1; 
for i=H_Win_i+1:size(dataF_Padded,1)-H_Win_i
    j_ind = 1;
    for j=H_Win_j+1:size(dataF_Padded,2)-H_Win_j
        k_ind = 1;
        for k=H_Win_k+1:size(dataF_Padded,3)-H_Win_k
            Centerr = dataF_Padded(i,j,k);
            if i-H_Win_i <= 0
               L1 = Centerr;
            else
               L1 = dataF_Padded(i-H_Win_i:i-1,j,k);
            end
            if i+H_Win_i >= size(dataF_Padded,1)
               R1 = Centerr;
            else
               R1 = dataF_Padded(i+1:i+H_Win_i,j,k);
            end
            L1 = Weight_Gauss(L1);
            R1 = Weight_Gauss(R1);
            Diff_H = abs(Centerr-L1) + abs(Centerr-R1);
            salMapX(i_ind,j_ind,k_ind) = sum(Diff_H(:));
            k_ind = k_ind+1;
        end
    j_ind = j_ind+1;
    end
i_ind = i_ind+1; 
end
dataF        = data_Comb{2};
dataF_Padded = EdgeMirror3(dataF,[H_Win_i,H_Win_j,H_Win_k]);   

%% Calculate saliency map
% Vertical
i_ind = 1; 
for i=H_Win_i+1:size(dataF_Padded,1)-H_Win_i
    j_ind = 1;
    for j=H_Win_j+1:size(dataF_Padded,2)-H_Win_j
        k_ind = 1;
        for k=H_Win_k+1:size(dataF_Padded,3)-H_Win_k
            Centerr = dataF_Padded(i,j,k);
            if j-H_Win_j <= 0
               U1 = Centerr;
            else
               U1 = dataF_Padded(i,j-H_Win_j:j-1,k);
            end
            if j+H_Win_j >= size(dataF_Padded,2)
               D1 = Centerr;
            else
               D1 = dataF_Padded(i,j+1:j+H_Win_j,k);
            end            
            U1 = Weight_Gauss(U1);
            D1 = Weight_Gauss(D1);
            Diff_V = abs(Centerr-U1) + abs(Centerr-D1);
            salMapY(i_ind,j_ind,k_ind) = sum(Diff_V(:));
            k_ind = k_ind+1;
        end
    j_ind = j_ind+1;
    end
i_ind = i_ind+1; 
end
dataF        = data_Comb{3};
dataF_Padded = EdgeMirror3(dataF,[H_Win_i,H_Win_j,H_Win_k]);   

%% Calculate saliency map
% Z, Time
i_ind = 1; 
for i=H_Win_i+1:size(dataF_Padded,1)-H_Win_i
    j_ind = 1;
    for j=H_Win_j+1:size(dataF_Padded,2)-H_Win_j
        k_ind = 1;
        for k=H_Win_k+1:size(dataF_Padded,3)-H_Win_k
            Centerr = dataF_Padded(i,j,k);
            if k-H_Win_k <= 0
               B1 = Centerr;
            else
               B1 = dataF_Padded(i,j,k-H_Win_k:k-1);
            end
            if k+H_Win_k >= size(dataF_Padded,3)
               T1 = Centerr;
            else
               T1 = dataF_Padded(i,j,k+1:k+H_Win_k);
            end            
            B1 = Weight_Gauss(B1);
            T1 = Weight_Gauss(T1);
            Diff_T = abs(Centerr-T1) + abs(Centerr-B1);
            salMapZ(i_ind,j_ind,k_ind) = sum(Diff_T(:));
            k_ind = k_ind+1;
        end
    j_ind = j_ind+1;
    end
i_ind = i_ind+1; 
end
Comb_Sal = Wt_sal(1)*salMapX + Wt_sal(2)*salMapY + Wt_sal(3)*salMapZ;


