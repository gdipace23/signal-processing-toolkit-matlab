function [spectrum, freq] = computeFFT(signal, fs, plotType, windowType)
%COMPUTEFFT Computes the spectrum of a signal using windowing and FFT.
%   [spectrum, freq] = computeFFT(signal, fs, plotType, windowType)
%   returns the full complex spectrum (double-sided) of the signal.
%
%   Input:
%       signal     - Time-domain signal (row or column vector)
%       fs         - Sampling frequency [Hz]
%       plotType   - (optional) Plot type: 'none' (default), 'single', 'double'
%       windowType - (optional) Window type: 'rect' (default), 'hann', 'hamming'
%
%   Output:
%       spectrum - Normalized complex spectrum (double-sided)
%       freq     - Frequency vector [Hz] (double-sided)

    % Handle optional arguments
    if nargin < 3 || isempty(plotType)
        plotType = 'none';
    end
    if nargin < 4 || isempty(windowType)
        windowType = 'rect';
    end

    % Ensure column vector
    signal = signal(:);
    N = length(signal);

    % Build window
    switch lower(windowType)
        case 'rect'
            win = ones(N, 1);  % Rectangular window (no modification)
        case 'hann'
            win = 0.5 * (1 - cos(2 * pi * (0:N-1)' / (N - 1)));
        case 'hamming'
            win = 0.54 - 0.46 * cos(2 * pi * (0:N-1)' / (N - 1));
        otherwise
            error('Window type "%s" not recognized. Use "rect", "hann", or "hamming".', windowType);
    end

    % Apply window to the signal
    windowedSignal = win .* signal;

    % Compute window normalization factor
    windowGain = N / sum(win);

    % Compute FFT and normalize
    spectrum = fft(windowedSignal);
    spectrum = windowGain / N * spectrum;

    % Corresponding frequency vector
    freq = (0:N-1)' * fs / N;

    % Optional plot
    switch lower(plotType)
        case 'single'
            halfN = floor(N/2) + 1;
            figure;
            stem(freq(1:halfN), abs(spectrum(1:halfN)));
            title(['Single-Sided Spectrum (', upper(windowType), ' window)']);
            xlabel('Frequency [Hz]');
            ylabel('Amplitude');

        case 'double'
            figure;
            stem(freq, abs(spectrum));
            title(['Double-Sided Spectrum (', upper(windowType), ' window)']);
            xlabel('Frequency [Hz]');
            ylabel('Amplitude');

        case 'none'
            % No plot
        otherwise
            warning('plotType "%s" not recognized. No plot will be displayed.', plotType);
    end

end
