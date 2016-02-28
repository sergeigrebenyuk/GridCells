%% Plots current activity maps, statistics and the status of simulation
% (c) Stepanyuk and Grebenyuk, 2015

% Draw the move to the new position

%axes(hndl.place_fields); line('XData',[x_old(1),x(1)],'YData',[x_old(2),x(2)],'LineStyle','-', 'Color','r','LineWidth',2);
plot(hndl.place_fields,Path(1,:),Path(2,:),'-rs');
hold(hndl.place_fields, 'on'); 

% draw all place cells
scatter(hndl.place_fields, PCD(:,1),PCD(:,2)); 
axis(hndl.place_fields,[0 pcSize+1 0 pcSize+1]);

% draw activation of place cells at current (last) position
scatter(hndl.place_fields, pcs(:,1),pcs(:,2),50,pcs(:,3), 'fill');
hold(hndl.place_fields, 'off');        

% plot weight-distance depenence
scatter(hndl.weights, pcs(:,5),pcs(:,3)-pcs(:,4));

mr = round(gcSize/2);
pcolor(hndl.lateral_weights,M(:,:,mr,mr)'); colormap(hndl.lateral_weights,'gray'); shading(hndl.lateral_weights,'interp'); 


A1=A(:,:,1,1)'; 
A2=A(:,:,2,1)'; 
%C = real(fft2(conv2(fft2(A1),fft2(A2))));
C = xcorr2(A1,A2);
pcolor(hndl.phase_plot,C); colormap(hndl.phase_plot,'jet'); shading(hndl.phase_plot,'interp');

pcolor(hndl.gc1,A1); colormap(hndl.gc1,'jet'); shading(hndl.gc1,'interp');
%pcolor(hndl.gc2,A2); colormap(hndl.gc2,'jet'); shading(hndl.gc2,'interp');

S1 = shiftdim(A,2);
S2 = S1(:,:,x(1,1),x(2,1));
pcolor(hndl.GC,S2');
colormap(hndl.GC,'jet');
shading(hndl.GC,'interp');



% pcolor(hndl.axes4,A(:,:,1,2)');
% colormap(hndl.axes4,'jet');
% shading(hndl.axes4,'interp');

