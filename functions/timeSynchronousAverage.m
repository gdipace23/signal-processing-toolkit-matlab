function [signalSync, angleVecSync] = timeSynchronousAverage(signalTheta, samplesPerRev, numRevs, plotFlag)
%TIMESYNCHRONOUSAVERAGE Computes the Time Synchronous Average (TSA) of an angular signal.
%
%   [signalSync, angleVecSync] = timeSynchronousAverage(signalTheta, samplesPerRev, numRevs, plotFlag)
%
%   Input:
%       signalTheta     - Angular resampled signal (column vector)
%       samplesPerRev   - Number of samples per revolution
%       numRevs         - Number of revolutions included in signalTheta
%       plotFlag        - (optional) true/false to display the plot (default: false)
%
%   Output:
%       signalSync      - Averaged signal over one revolution
%       angleVecSync    - Corresponding angle vector [rad]

    if nargin < 4 || isempty(plotFlag)
        plotFlag = false;
    end

    % Create uniform angle vector
    deltaAngle = 2 * pi / samplesPerRev;
    angleVecSync = (0:samplesPerRev - 1)' * deltaAngle;

    % Reshape the signal into columns (one per revolution) and compute the mean
    signalMatrix = reshape(signalTheta(1:samplesPerRev * numRevs), samplesPerRev, numRevs);
    signalSync = mean(signalMatrix, 2);  % Average column-wise

    % Optional plot
    if plotFlag
        figure;
        plot(angleVecSync, signalSync);
        title('Time Synchronous Averaging');
        xlabel('Angle [rad]');
        ylabel('Amplitude');
    end
end
