function [psd, freq] = computePSD(signal, fs, segmentLength, windowLength, noverlap, windowType, plotFlag)
%COMPUTEPSD Computes the Power Spectral Density (PSD) using Welch's method.
%   [psd, freq] = computePSD(signal, fs, segmentLength, windowLength, noverlap, windowType, plotFlag)
%
%   Computes the PSD by averaging FFTs over overlapping segments of the signal,
%   using a specified window and proper normalization.
%
%   Input:
%       signal        - Time-domain signal (row or column vector)
%       fs            - Sampling frequency [Hz]
%       segmentLength - Duration (in seconds) of the signal to analyze
%       windowLength  - Number of samples per window segment (Nw)
%       noverlap      - Number of samples overlapped between segments
%       windowType    - (optional) 'rect' (default), 'hann', 'hamming'
%       plotFlag      - (optional) true/false to display the plot (default: false)
%
%   Output:
%       psd   - Power spectral density [signal unit^2 / Hz]
%       freq  - Frequency vector [Hz]

    % Optional arguments
    if nargin < 6 || isempty(windowType)
        windowType = 'rect';
    end
    if nargin < 7 || isempty(plotFlag)
        plotFlag = false;
    end

    % Ensure column vector
    signal = signal(:);

    % Number of samples to analyze
    N = round(fs * segmentLength);
    signal = signal(1:min(N, end));  % truncate if needed

    % Build window
    switch lower(windowType)
        case 'rect'
            w = ones(windowLength, 1);
        case 'hann'
            w = 0.5 * (1 - cos(2 * pi * (0:windowLength-1)' / (windowLength - 1)));
        case 'hamming'
            w = 0.54 - 0.46 * cos(2 * pi * (0:windowLength-1)' / (windowLength - 1));
        otherwise
            error('Window type "%s" not recognized.', windowType);
    end

    % Normalization factors
    sumW = sum(w);
    sumW2 = sum(w.^2);
    Aw = windowLength / sumW;
    Be = (fs * sumW2) / (sumW^2);

    % Number of segments
    step = windowLength - noverlap;
    M = floor((length(signal) - noverlap) / step);

    % Initialize PSD
    psd = zeros(windowLength, 1);

    % Loop over segments
    for m = 1:M
        startIdx = (m-1) * step + 1;
        segment = signal(startIdx : startIdx + windowLength - 1);
        segment = segment .* w;  % apply window
        spectrum = fft(segment);
        psd = psd + abs(spectrum).^2;
    end

    % Final PSD normalization
    psd = (Aw^2 / (windowLength^2 * Be * M)) * psd;

    % Associated frequency vector
    freq = (0:windowLength-1)' * fs / windowLength;

    % Optional plot
    if plotFlag
        figure;
        stem(freq, psd);
        title(['Power Spectral Density (', upper(windowType), ' window)']);
        xlabel('Frequency [Hz]');
        ylabel('Amplitude [unit^2/Hz]');
    end
end
