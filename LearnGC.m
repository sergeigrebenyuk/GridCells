function [ wo ] = LearnGC(pcs,idx,w,yp,ym,noise,w_min);
% 
% pcs (k,1) : x coordinate of k-th place cell (PC)
% pcs (k,2) : y coordinate of k-th PC
% pcs (k,3) : activity of k-th PC
% pcs (k,4) : inh activity of k-th PC
% pcs (k,5) : distance between curent position and k-th PC
%
% idx   : current step of simulation
% w     : synaptic weights of current grid cell
%
% (c) Stepanyuk and Grebenyuk, 2015

%% Learning step    
    for k=1:size(pcs,1) % go through the list of activated place cells
        i = pcs(k,1);
        j = pcs(k,2);
        
        %dwp = (1/idx)*(yp*pcs(k,3) - yp^2*w(i,j));
        %dwm = (1/idx)*(ym*pcs(k,4) - ym^2*w(i,j));
        %dw = dwp-dwm;

        dwp = yp*pcs(k,3); 
        dwm = ym*pcs(k,4);
        dw = (dwp-dwm);
        
        if dw > 0.1 dw = 0.1; end;
        
        w(i,j) = w(i,j) + dw + noise*randn;
        
        if w(i,j) < 0 w(i,j) = 0; end;
    end
    wo=w;
end

