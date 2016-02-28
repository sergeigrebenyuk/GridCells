function [out] = fillMConnections(Rad,Dim,m,amp)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% Create round mask for speed optimization
Mask = ones(Rad*2+1);
RadiusS = Rad^2;
for i=-Rad:Rad
    for j=-Rad:Rad
        if (i^2+j^2 > RadiusS) Mask(i+Rad+1,j+Rad+1) = 0;end
    end
end

m=zeros(Dim,Dim,Dim,Dim);

mRad = 2*(Rad*0.4)^2;
for k1=1:Dim
    for k2=1:Dim

        for i=-Rad:Rad
            for j=-Rad:Rad
                x = k1+i;
                y = k2+j;

                % Torus arena: wrap indices
                xn = mod(x,Dim)+1;
                yn = mod(y,Dim)+1;

                if Mask(i+Rad+1,j+Rad+1) 
                    d = norm([k1;k2] - [x;y]);
                    m(xn,yn,k1,k2) = amp*exp(-(d-0.5)^2/mRad);
                end;

            end
        end
    end
end
out=m;
end

