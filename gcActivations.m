function [ Yp Ym ] = gcActivations( pcs,wgc, gc,gcm, m )
% gcActivations - calculates activity for all Grid Cells at the beginning
% of current learning step
%   
% pcs   : set of active place cells
% wgc     : weight matrix of grid cells

%% Calculate Grid Cells activations
    pcs_size = size(pcs,1);
    gc_size = size(gc,1);
    persistent tp tm;   
    tp = gc;   
    tm = gcm;   
    for i=1:gc_size
        for j=1:gc_size
            w = wgc(:,:,i,j); % select the weight matrix
            s1 = sum(sum(m(:,:,i,j).*gc,1),2); % weighted sum of gc activity
            %s2 = s1 - m(i,j)*gc(i,j); % grid cell doesn project to itself, remove its impact to s
            
            yp = 0;
            ym = 0;
            for k=1:pcs_size 
                w1 = w(pcs(k,1),pcs(k,2));
                yp = yp + w1*pcs(k,3);
                ym = ym + w1*pcs(k,4);
            end        
            tp(i,j) = yp + s1;
            tm(i,j) = ym;
        end
    end
    Yp = tp;
    Ym = tm;
    
%     yp=zeros(gc_size);
%     ym=zeros(gc_size);
%     for i=1:gc_size
%         for j=1:gc_size
%             mi = mod(i,gc_size)+1;
%             mj = mod(j,gc_size)+1;
%             Yp(i,j) = Yp(i,j) + s2 - m(mi,mj)*Yp(i,j);
%             Ym(i,j) = ym;
%         end
%     end
    

end

