 %% DEMO IMAGE PROCESSING ALGORITHM

addpath("../functions");
fname = "983b_D10_10000_2";

cycling_threshold = 0.2;

%% READ IMAGE
[raw,meta] = tifread(fname);

    % FUCCI red and green channels
    A_red = raw2img(raw,[0,1,0],'none');
    B_grn = raw2img(raw,[1,0,0],'none');

    % Save
    imwrite(A_red,"A_red.tif");
    imwrite(B_grn,"B_green.tif");

%% GET MASKS
[msk,cvx,innermsk,innercvx,all,filt,msk_raw] = raw2msks(raw);
    
    % Composite image
    C_composite = all;
    
    % Texture filtered image
    D_filtered = filt;
    
    % Identified cell regions
    E_binary = msk_raw;
    
    % Necrotic core mask
    F_necrotic = innermsk;
    
    % Spheroid mask
    G_spheroid = cvx;
    
    % Save
    imwrite(C_composite, "D_composite.tif");
    imwrite(D_filtered,  "D_filtered.tif");
    imwrite(E_binary,    "E_binary.tif");
    imwrite(F_necrotic,  "F_necrotic.tif");
    imwrite(G_spheroid,  "G_spheroid.tif");
    
%% INHIBITED REGION
    
% Get green pixel intensity distribution
[I,R,D] = intensitydist(raw(:,:,2),cvx,'Scale',meta.Resolution,'Clip',0.1,'Mask',msk);
    
% Fit Gompertz curve to pixel intesity distribution
[p,fun] = intensitydistfit(R,I);

% Summarise Gompertz curve to get distance from the periphary
periph  = intensitysummary(p,max(D,[],'all'),cycling_threshold);
    
    
    imshow(B_grn);
    hold on;
    D(D == 0) = -1; % Not on spheroid
    [C,h] = contour(D,0:40:200,'w');
    clabel(C,h, 'Color','w', 'FontName', 'Arial','LabelSpacing',100,'Margin',10);
    exportgraphics(figure(1),"H_distances.eps");

    clf();
    plot(R,I); xlim([0,300]); hold on;
    plot(R,fun(R)); 
    plot([periph,periph],[0,cycling_threshold * fun(0)],'-o');
    ax = gca; grid on;
    ax.XGrid = 'off'; hold off;
    exportgraphics(figure(1),"I_cycling.eps");
    
%% PLOT RESULT
img = raw2img(raw,'none');clf;
imshow(img); hold on;
visboundaries(cvx);
visboundaries(D > periph);
visboundaries(innermsk);
exportgraphics(figure(1),"J_result.eps");


%% GET SCALE
[m,n] = size(raw(:,:,2));
img_length_um = m / meta.Resolution;