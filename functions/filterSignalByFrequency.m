function [filteredSignal, timeVec] = filterSignalByFrequency(signal, fs, fmin, fmax, plotFlag)
%FILTERSIGNALBYFREQUENCY Filters a signal in the frequency domain between fmin and fmax Hz.
%
%   [filteredSignal, timeVec] = filterSignalByFrequency(signal, fs, fmin, fmax, plotFlag)
%
%   Input:
%       signal         - Input signal (column or row vector)
%       fs             - Sampling frequency [Hz]
%       fmin           - Minimum frequency of the band-pass filter [Hz]
%       fmax           - Maximum frequency of the band-pass filter [Hz]
%       plotFlag       - (optional) true/false to display the plot (default: false)
%
%   Output:
%       filteredSignal - Filtered time-domain signal
%       timeVec        - Time vector associated [s]

    if nargin < 5 || isempty(plotFlag)
        plotFlag = false;
    end

    % Ensure column vector
    signal = signal(:);
    N = length(signal);
    timeVec = (0:N-1)' / fs;

    % Compute FFT of the signal
    spectrum = fft(signal) / N;

    % Frequency vector and mask definition
    freq = (0:N-1)' * fs / N;
    mask = (freq >= fmin & freq <= fmax) | (freq >= fs - fmax & freq <= fs - fmin);

    % Apply band-pass mask
    filteredSpectrum = zeros(N, 1);
    filteredSpectrum(mask) = spectrum(mask);

    % Reconstruct the filtered time-domain signal
    filteredSignal = real(ifft(filteredSpectrum) * N);

    % Optional plot
    if plotFlag
        figure;
        plot(timeVec, filteredSignal);
        title('Signal Filtering');
        xlabel('Time [s]');
        ylabel('Amplitude');
    end
end
