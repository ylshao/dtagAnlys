function plotStaAccel(TagData)
    figure;
    plot(TagData.timeHour, TagData.AccelStat.totalAccel(:,1)); hold on;
    plot(TagData.timeHour, TagData.AccelStat.staticAccel(:,1), 'c')
    xlabel('time [hour]'); ylabel('accel X [m/s^2]')
    legend('total', 'static')
    