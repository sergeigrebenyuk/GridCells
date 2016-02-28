function [ actv_pc ] = pcActivations( pc, pfStruct, animalPath, uniform, fromFile )
% For each position from animal trajectory calculates activation of
% affected place cells
% (c) Stepanyuk and Grebenyuk, 2015

% INPUT
% pc            : place cells scattered over arena
% fldRad        : Radius of place fileds
% animalPath    : Animal trajectory
% loadFile      : If nonzero, load stored data from disk

% OUTPUT
% path_a        : Activated place cells at each trajectory position

    Dim = size(pc,1);
    h=0;
    if ~fromFile
        
        h = waitbar(0,'Preparing to activate place cells...');

        %% Calculate activation of place cells along the animal trajectory
        
        fldRad =     pfStruct.Rad;
        fldRadInh =  pfStruct.Rad / pfStruct.EISizeRatio;
        fldAmp =     pfStruct.Amp;
        fldAmpInh =  pfStruct.Amp / pfStruct.EIAmpRatio;
        
        ex_div = (0.03*2*fldRad^2);
        inh_div = (0.03*2*fldRadInh^2);

        rng('shuffle','combRecursive');
        
        %noisefactor = pfStruct.Rad*0.1;
        
        % Create round mask for speed optimization
        Mask = ones(fldRad*2+1);
        RadiusS = fldRad^2;
        for i=-fldRad:fldRad
            for j=-fldRad:fldRad
                if (i^2+j^2 > RadiusS) Mask(i+fldRad+1,j+fldRad+1) = 0;end
            end
        end
        
        % For each trajectory position
        a_size = size(animalPath,2); 
        actv_pc = cell(Dim,Dim); 
        
        %for k=1:a_size
        for k1=1:Dim
            for k2=1:Dim
                %pos = animalPath(:,k1);
                nbrs=[];

                pr = k1/a_size;
                if mod(100*pr, 20)==0 waitbar(pr,h,'Calculating activation of place cells for each point of arena...'); end;

                for i=-fldRad:fldRad
                    for j=-fldRad:fldRad
                        xidx = k1+i;
                        yidx = k2+j;

                        % Torus arena: wrap indices
                        xidxn = mod(xidx,Dim)+1;
                        yidxn = mod(yidx,Dim)+1;

                        % Non-torus arena: Skip for next iteration if out of boundaries
                        %if (xidx < 1) || (xidx > Dim) || (yidx < 1) || (yidx > Dim) continue; end;

                        if Mask(i+fldRad+1,j+fldRad+1) 
                            % we are within the circle of radius fldRad 
                            if pc(xidxn,yidxn)== 1

                                d = norm([xidx;yidx] - [k1;k2]);%*noisefactor;      % euclidian distance between the center of a place and the animal position

                                ex_a = fldAmp*exp(-(d-0.5).^2/ex_div);         % potentiation component
                                inh_a = fldAmpInh*exp(-(d).^2/inh_div);         % depression component

                                nbrs = [nbrs;[xidxn,yidxn,ex_a,inh_a,d]];
                            end
                        end
                    end
                end
                % Center data to zero mean
                nbrs(:,3) = nbrs(:,3)-mean(nbrs(:,3));
                nbrs(:,4) = nbrs(:,4)-mean(nbrs(:,4));
                actv_pc{k1,k2}=nbrs;
                %actv_pc(k).nb = nbrs;
            end
        end
        close(h);
    
        %% Save generated data to disk    
        save pc_actv actv_pc

    else % ~fromFile

        load pc_actv

    end % ~fromFile

end

