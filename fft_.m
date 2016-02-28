 global GC GCm A 
% A1=A(:,:,x,y)'; 
% pcolor(hndl.gc1,A1);
% colormap(hndl.gc1,'jet');
% shading(hndl.gc1,'interp');
figure(10);
subplot(2,2,1);
r = 1;



sz=round(9*pi);
F=zeros(sz);
rng('shuffle');

for z=1:10
    offsx = rand*pi*2;
    offsy = rand*pi*2;
    al = 0;%rand*pi/2;
    g1=pi*0/180+al;
    g2=pi*60/180+al;
    g3=pi*120/180+al;    
    for xi=1:sz
        for yi=1:sz
            x = xi+ offsx;
            y = yi+ offsy;
            r1=x*sin(g1)+y*cos(g1);
            r2=x*sin(g2)+y*cos(g2);
            r3=x*sin(g3)+y*cos(g3);
            F(xi,yi,z) = sin(r1)+sin(r2)+sin(r3);
        end;
    end
    
    
end


C=F(:,:,1);
co = zeros(2,2,10);
for z=2:10
    C = conv2(C,F(:,:,z));
    co(:,:,z) = cov(F(:,:,1),F(:,:,2));
end
%V = xcorr2(F(:,:,1),F(:,:,2));
V = real(fftshift(fft2(F(:,:,3))));
pcolor(V)
colormap('jet');
shading('interp');
line([sz,0],[sz,sz]);


