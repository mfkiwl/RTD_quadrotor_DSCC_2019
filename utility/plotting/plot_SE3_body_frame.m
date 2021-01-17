function plot_data = plot_SE3_body_frame(R,varargin)
% plot_data = plot_SE3_body_frame(orientation,position,varargin)
%
% Given a pose in SE(3) as a rotation matrix (3x3) and a position (3x1),
% plot a right-handed coordinate frame representing the pose. The default
% is to plot the local x-axis in red, y in green, and z in blue, each with
% length 1. This function also returns the figure handle and handles to the
% plot data if more output arguments are specified.
%
% USAGE:
% Default usage assumes p = (0,0,0):
%    plot_SE3_body_frame(R)
% 
% Plot the coordinate frame centered at p:
%    plot_SE3_body_frame(R,p)
%
% Use varargin options:
%    plot_SE3_body_frame(R,p,'option1',option1,'option2',option2,...)
%
% VARARGIN OPTIONS:
% The varargin options are the same as the options for plot3, plus the
% following that are specific to this function:
%
% 'Colors' - takes a 3-by-3 matrix where each row specifies the color of a
%            coordinate vector in the order x-y-z
% 
% 'Scale'  - specifies the length of the plotted unit vectors
%
% 'Data'   - takes in the plot_data object output by this function; this
%            is used to update the plots instead of completely refreshing
%            the plot (which causes a jittery appearance)

    args_list = {} ;

    if isempty(varargin)
            p = zeros(3,1) ;
    else
        if ~ischar(varargin{1})
            p = varargin{1} ;
            arg_in_idxs = 2:2:length(varargin) ;
        else
            p = zeros(3,1) ;
            arg_in_idxs = 1:2:length(varargin) ;
        end

        for idx = arg_in_idxs
            switch varargin{idx}
                case 'Colors'
                    c = varargin{idx+1} ;
                case 'Scale'
                    s = varargin{idx+1} ;
                case 'Data'
                    plot_data = varargin{idx+1} ;
                otherwise
                    args_list = [args_list, varargin(idx:idx+1)] ;
            end
        end
    end
    
    % set up default variables
    if ~exist('c','var')
        c = eye(3) ;
    end
    
    if ~exist('s','var')
        s = 1 ;
    end

    % create vectors to plot
    e1 = [p, s.*R(:,1) + p] ;
    e2 = [p, s.*R(:,2) + p] ;
    e3 = [p, s.*R(:,3) + p] ;
    
    % start new plot if none is available
    if ~exist('plot_data','var')
        hold on

        % plot 'em!
        e1_data = plot3(e1(1,:),e1(2,:),e1(3,:),'Color',c(1,:),args_list{:}) ;
        e2_data = plot3(e2(1,:),e2(2,:),e2(3,:),'Color',c(2,:),args_list{:}) ;
        e3_data = plot3(e3(1,:),e3(2,:),e3(3,:),'Color',c(3,:),args_list{:}) ;

        hold off

        % create output
        if nargout > 0
            plot_data.e1_data = e1_data ;
            plot_data.e2_data = e2_data ;
            plot_data.e3_data = e3_data ;
        end
    else
        % get data
        e1_data = plot_data.e1_data ;
        e2_data = plot_data.e2_data ;
        e3_data = plot_data.e3_data ;
        
        % update axes
        e1_data.XData = e1(1,:) ;
        e1_data.YData = e1(2,:) ;
        e1_data.ZData = e1(3,:) ;
        
        e2_data.XData = e2(1,:) ;
        e2_data.YData = e2(2,:) ;
        e2_data.ZData = e2(3,:) ;
        
        e3_data.XData = e3(1,:) ;
        e3_data.YData = e3(2,:) ;
        e3_data.ZData = e3(3,:) ;
        
        % update plot_data
        plot_data.e1_data = e1_data ;
        plot_data.e2_data = e2_data ;
        plot_data.e3_data = e3_data ;
    end
end