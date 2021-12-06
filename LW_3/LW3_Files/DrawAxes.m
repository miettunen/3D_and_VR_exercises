%--------------------------------------------------------------------------
%   Draw 'xyz' axes 
%
%   Author: Filipe Gama
%   Email: filipe.gama@tuni.fi
%   Version: 1.0 
%--------------------------------------------------------------------------
function DrawAxes(R,t,mag, txt, txtDist, targetCenter)
    
    if(~exist('txtDist', 'var') || isempty(txtDist))
        txtDist = 0.1;
    end
    
    if(~exist('targetCenter', 'var') || isempty(targetCenter))
       targetCenter = [0 0 0]; 
    end
    
    plot3([targetCenter(1) t(1)], [targetCenter(2) t(2)], [targetCenter(3) t(3)], 'k--');
    hold on;
    plot3(targetCenter(1),targetCenter(2),targetCenter(3), 'k.', 'MarkerSize', 5);
    x = R(:,1) .* mag;
    y = R(:,2) .* mag;
    z = R(:,3) .* mag;
    
    plot3([t(1), t(1)+x(1)], [t(2), t(2)+x(2)], [t(3), t(3)+x(3)], 'r', 'LineWidth', 2);
    text(t(1)+x(1)+txtDist,t(2)+x(2)+txtDist,t(3)+x(3)+txtDist,'X', 'Color', 'r', 'FontWeight', 'bold');
    
    plot3([t(1), t(1)+y(1)], [t(2), t(2)+y(2)], [t(3), t(3)+y(3)], 'g', 'LineWidth', 2);
    text(t(1)+y(1)+txtDist,t(2)+y(2)+txtDist,t(3)+y(3)+txtDist,'Y', 'Color', 'g', 'FontWeight', 'bold');
    
    plot3([t(1), t(1)+z(1)], [t(2), t(2)+z(2)], [t(3), t(3)+z(3)], 'b', 'LineWidth', 2);
    text(t(1)+z(1)+txtDist,t(2)+z(2)+txtDist,t(3)+z(3)+txtDist,'Z', 'Color', 'b', 'FontWeight', 'bold');
    
    if(nargin>3)
        text(t(1)+txtDist,t(2)+txtDist,t(3)+txtDist, txt, 'Color', 'k', 'FontWeight', 'bold');
    end

end