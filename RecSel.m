function [ind] = RecSel(time, data)

if nargin < 2
    help SelectPt_wrapup
end

    done = 0 ;
    ind = [] ;
    h = plot(0,0,'r.') ;        % dummy plot to make a handle
    set(h,'MarkerSize',5) ;

%     fprintf(' Select points in Fig 2 by enclosing in rectangles using the left mouse button\n') ;
%     fprintf(' Press any key to end\n')
%     
    while ~done,
       if(~waitforbuttonpress),
          pt1 = get(gca,'CurrentPoint') ;        % button down detected
          finalRect = rbbox ;                    % return figure units
          pt2 = get(gca,'CurrentPoint') ;        % button up detected
          q = sort([pt1(1,1:2);pt2(1,1:2)]) ;    % extract x and y
          ind = union(ind,find(time>q(1,1) & time<q(2,1) & data>q(1,2) & data<q(2,2))) ;
          set(h,'XData',time(ind),'YData',data(ind)) ;
%           subplot(211)
%           set(hg,'XData',k(ind)/1000,'YData',data(ind)) ;
%           subplot(212)
       else
          done = 1 ;
       end
    end
    
%     time_sel = time(ind);
%     data_sel = data(ind);