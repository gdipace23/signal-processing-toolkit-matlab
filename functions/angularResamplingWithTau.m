function [signalTheta, angleVec, samplesPerRev, numRevs] = angularResamplingWithTacho(...
    signal, fs, tacho, pulsesPerRev, triggerLevel, plotFlag)
%ANGULARRESAMPLINGWITHTACHO Performs angular resampling of a signal using a tachometer signal.
%
%   [signalTheta, angleVec, samplesPerRev, numRevs] =
%       angularResamplingWithTacho(signal, fs, tacho, pulsesPerRev, triggerLevel, plotFlag)
%
%   Input:
%       signal        - Signal to be resampled (vector)
%       fs            - Sampling frequency [Hz]
%       tacho         - Tachometer signal (same length as signal)
%       pulsesPerRev  - Number of tach pulses per revolution
%       triggerLevel  - Threshold level for detecting rising edges
%       plotFlag      - (optional) true/false to display plot (default: false)
%
%   Output:
%       signalTheta   - Signal resampled as a function of angle
%       angleVec      - Angle vector [rad]
%       samplesPerRev - Number of interpolated samples per revolution
%       numRevs       - Number of revolutions detected

    if nargin < 6 || isempty(plotFlag)
        plotFlag = false;
    end

    % Ensure column vectors
    signal = signal(:);
    tacho = tacho(:);
    N = length(signal);
    timeVec = (0:N-1)' / fs;

    % Detect rising edges in the tacho signal (crossing threshold)
    triggerTimes = zeros(N, 1);
    triggerCount = 0;
    for i = 1:N-1
        if tacho(i) <= triggerLevel && tacho(i+1) > triggerLevel
            triggerCount = triggerCount + 1;
            triggerTimes(triggerCount) = ...
                (triggerLevel - tacho(i)) / (tacho(i+1) - tacho(i)) * ...
                (timeVec(i+1) - timeVec(i)) + timeVec(i);
        end
    end
    triggerTimes = triggerTimes(1:triggerCount);
    numRevs = triggerCount - 2;

    % Compute mean rotational frequency
    freqMean = 0;
    for i = 1:triggerCount - 1
        freqMean = freqMean + 1 / (triggerTimes(i+1) - triggerTimes(i));
    end
    freqMean = freqMean / ((triggerCount - 1) * pulsesPerRev);

    % Number of interpolated samples between two tach pulses
    samplesPerPulse = floor(fs / (freqMean * pulsesPerRev));

    % Total samples per revolution (samplesPerPulse × pulses per rev)
    samplesPerRev = samplesPerPulse * pulsesPerRev;

    % Angular step between samples
    deltaTheta = 2 * pi / samplesPerRev;

    % Total angle vector
    totalPoints = samplesPerPulse * numRevs;
    angleVec = (0:totalPoints - 1)' * deltaTheta;

    % Compute time instants corresponding to each angle
    timeAtAngle = zeros(totalPoints, 1);
    offset = 0;

    for i = 1:numRevs
        t1 = triggerTimes(i);
        t2 = triggerTimes(i+1);
        t3 = triggerTimes(i+2);
        delta = 2 * pi / pulsesPerRev;

        % Time-angle interpolation coefficients (CRAMER method)
        Db0 = 2*delta*t1*t2^2 + delta*t1^2*t3 - 2*delta*t1^2*t2 - delta*t3^2*t1;
        Db1 = delta*t3^2 + 2*delta*t1^2 - delta*t1^2 - 2*delta*t2^2;
        Db2 = 2*delta*t2 + delta*t1 - delta*t3 - 2*delta*t1;
        D = t3^2*t2 + t1*t2^2 + t1^2*t3 - t1^2*t2 - t2^2*t3 - t3^2*t1;

        b0 = Db0 / D;
        b1 = Db1 / D;
        b2 = Db2 / D;

        for k = 0:samplesPerPulse - 1
            theta = k * deltaTheta;
            timeAtAngle(offset + k + 1) = (1 / (2 * b2)) * (sqrt(4 * b2 * (theta - b0) + b1^2) - b1);
        end
        offset = offset + samplesPerPulse;
    end

    % Interpolate signal using computed time instants
    signalTheta = interp1(timeVec, signal, timeAtAngle, 'spline');

    % Optional plot
    if plotFlag
        figure;
        plot(angleVec, signalTheta);
        title('Angular Resampling with Tacho');
        xlabel('Angle [rad]');
        ylabel('Amplitude');
    end
end
