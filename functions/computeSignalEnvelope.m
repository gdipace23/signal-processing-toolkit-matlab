function [signalEnvelope, timeVec] = computeSignalEnvelope(signal, fs, plotFlag)
%COMPUTESIGNALENVELOPE Computes the envelope of a signal using the Hilbert transform.
%
%   [signalEnvelope, timeVec] = computeSignalEnvelope(signal, fs, plotFlag)
%
%   Input:
%       signal         - Input signal (row or column vector)
%       fs             - Sampling frequency [Hz]
%       plotFlag       - (optional) true/false to display the plot (default: false)
%
%   Output:
%       signalEnvelope - Signal envelope (magnitude of the analytic signal)
%       timeVec        - Time vector [s]

    if nargin < 3 || isempty(plotFlag)
        plotFlag = false;
    end

    % Ensure column vector
    signal = signal(:);
    N = length(signal);

    % Compute the envelope using the Hilbert transform
    signalEnvelope = abs(hilbert(signal));

    % Time vector
    timeVec = (0:N-1)' / fs;

    % Optional plot
    if plotFlag
        figure;
        plot(timeVec, signalEnvelope);
        title('Signal Envelope');
        xlabel('Time [s]');
        ylabel('Amplitude');
    end
end
