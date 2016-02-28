function [ pc, pc_draw ] = GenerateRandomPC(pcNum,Dim, uniform, fromFile)
% GenerateRandomPC places place cells at random locations over a square
% arena and calculates firing rates of place cells for every position of the
% animal trajectory
% (c) Stepanyuk and Grebenyuk, 2015
%
% pcNum     : Number of place cells
% Dim       : Dimentions of the square arena
% loadFile  : If nonzero, load stored data from disk

if ~fromFile
    h = waitbar(0,'Initializing waitbar...');
    if ~uniform
    %% Generate place fileds
        par.mhp = 2.0;
        par.random_centers = 1;

        m = Dim;
        n = pcNum;
        mh = par.mhp;

        %om=ones(m,1);
        on=ones(n,1);
        dxy=[-m/24 ];

        if par.random_centers
            xyc=(m-2*dxy)*rand(n,2)+dxy ;

        end;
        xyc0=xyc;
        dxc=xyc(:,1)*on'-on*xyc(:,1)';
        dyc=xyc(:,2)*on'-on*xyc(:,2)';
        dl=sqrt( dxc.^2+dyc.^2);
        dl(dl<eps)=max(max(dl))*2;
        if par.random_centers
           eta_pre=1*0.05*mean(min(dl));
        else
           eta_pre=0;
        end
        Ax=4*2.0;
        alpha1=0.02;
        bet1=0.4; %0*1/mh^2/10;
        bet0=1;
        mh0=mh*0.5*2;

        Nin=30; % Greater than 30 doesn't make arrangment better

        %% Even re-arranging of random fields
        for tin=1:Nin
            t = 100*tin/Nin;
            if (mod(t,20)==0) waitbar(t,h,'Arranging place cells...'); end;

            dxc=xyc(:,1)*on'-on*xyc(:,1)';
            dyc=xyc(:,2)*on'-on*xyc(:,2)';
            R=Ax*exp(-0.5*(dxc.^2+dyc.^2)./mh0./mh0)/mh0^2; 
            R2=1./sqrt(dxc.^2+dyc.^2+eps);                  
            R2((n+1)*(0:n-1)+1)=1;
            R3=bet0*R + bet1*R2.^3;

            % scattering and attraction to the center
            dxyc=[sum(dxc.*R3,2)  sum(dyc.*R3,2)];
            xyc = xyc + eta_pre*(dxyc -alpha1*(xyc-m/2).*(abs(xyc-m/2)>0)) +eta_pre*0.5*randn(size(xyc));    
            if tin<60
               xyc(xyc<dxy)=dxy;
               xyc(xyc>m+-dxy)=m+-dxy;
            end
            if tin==Nin

            end

        end %for tin=1:Nin

    % Rearrange into integer positions
        pc = zeros(Dim);
        pc_draw = [];
        for i=1:size(xyc,1)
            xind = round(xyc(i,1)); if (xind < 1) || (xind > Dim) continue; end;
            yind = round(xyc(i,2)); if (yind < 1) || (yind > Dim) continue; end;
            pc(xind,yind) = 1;
            pc_draw = [pc_draw;[xind,yind]];
        end
    %% Save generated data to disk    
    else
        pc = zeros(Dim);
        pc_draw = [];
        step = round(Dim / round(sqrt(pcNum)));
        pc(1:step:end,1:step:end) = 1;
        k = 1:step:Dim;
        for i=1:Dim
            for j=1:Dim
                if pc(i,j) pc_draw = [pc_draw;[i,j]]; end
            end
        end
        
    end
    save pcells pc pc_draw
    close(h);

else % ~fromFile

    load pcells
       
end % ~fromFile

%out.pcSize = n;

end

