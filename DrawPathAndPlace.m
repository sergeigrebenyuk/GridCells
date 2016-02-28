function [] = DrawPathAndPlace(hdl,path,pc,dim)
    plot(hdl.place_fields,path(1,:),path(2,:),'-rs');
    hold(hdl.place_fields, 'on');    
    scatter(hdl.place_fields,pc(:,1),pc(:,2)); 
    hold(hdl.place_fields, 'off');
    axis(hdl.place_fields,[0 dim+1 0 dim+1]);
end

