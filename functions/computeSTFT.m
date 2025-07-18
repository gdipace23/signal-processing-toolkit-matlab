function [stftMatrix, tVec, fVec] = computeSTFT(signal, fs, windowLength, overlap, plotType, windowType)
%COMPUTESTFT Computes the Short-Time Fourier Transform (STFT) with windowing.
%
%   [stftMatrix, tVec, fVec] = computeSTFT(signal, fs, windowLength, overlap, plotType, windowType)
%
%   Input:
%       signal       - Time-domain signal (vector)
%       fs           - Sampling frequency [Hz]
%       windowLength - Window length (Nw)
%       overlap      - Number of samples overlapping between windows (Noverlap)
%       plotType     - (optional) 'none' (default), '2d', '3d', 'both'
%       windowType   - (optional) 'rect' (default), 'hann', 'hamming'
%
%   Output:
%       stftMatrix - STFT matrix (rows: time frames, columns: frequencies)
%       tVec       - Time vector [s]
%       fVec       - Frequency vector [Hz]

    % Optional arguments
    if nargin < 5 || isempty(plotType)
        plotType = 'none';
    end
    if nargin < 6 || isempty(windowType)
        windowType = 'rect';
    end

    % Ensure column vector
    signal = signal(:);
    N = length(signal);
    Nw = windowLength;

    % Build window
    switch lower(windowType)
        case 'rect'
            win = ones(Nw, 1);
        case 'hann'
            win = 0.5 * (1 - cos(2 * pi * (0:Nw-1)' / (Nw - 1)));
        case 'hamming'
            win = 0.54 - 0.46 * cos(2 * pi * (0:Nw-1)' / (Nw - 1));
        otherwise
            error('Invalid window type "%s". Use: rect, hann, or hamming.', windowType);
    end

    % Window normalization gain
    winGain = Nw / sum(win);

    % Number of time frames
    hopSize = Nw - overlap;
    numFrames = floor((N - overlap) / hopSize);

    % Initialize output
    stftMatrix = zeros(numFrames, Nw);
    tVec = ((0:numFrames-1) * hopSize) / fs;
    fVec = (0:Nw-1)' * fs / Nw;

    % Compute STFT
    for k = 1:numFrames
        startIdx = (k-1) * hopSize + 1;
        segment = signal(startIdx : startIdx + Nw - 1);
        windowedSegment = win .* segment;
        stftMatrix(k, :) = winGain / Nw * fft(windowedSegment);
    end

    % Visualization
    switch lower(plotType)
        case '2d'
            figure;
            surf(fVec, tVec, abs(stftMatrix));
            shading interp; view(0, 90);
            colormap hot; colorbar;
            title(['STFT - 2D View (', upper(windowType), ' window)']);
            xlabel('Frequency [Hz]');
            ylabel('Time [s]');

        case '3d'
            figure;
            surf(fVec, tVec, abs(stftMatrix));
            shading interp;
            colormap hot; colorbar;
            title(['STFT - 3D View (', upper(windowType), ' window)']);
            xlabel('Frequency [Hz]');
            ylabel('Time [s]');
            zlabel('Amplitude');

        case 'both'
            figure;

            % 2D subplot
            subplot(2, 1, 1);
            surf(fVec, tVec, abs(stftMatrix));
            shading interp; view(0, 90);
            colormap hot; colorbar;
            title(['STFT - 2D View (', upper(windowType), ' window)']);
            xlabel('Frequency [Hz]');
            ylabel('Time [s]');

            % 3D subplot
            subplot(2, 1, 2);
            surf(fVec, tVec, abs(stftMatrix));
            shading interp;
            colormap hot; colorbar;
            title(['STFT - 3D View (', upper(windowType), ' window)']);
            xlabel('Frequency [Hz]');
            ylabel('Time [s]');
            zlabel('Amplitude');

        case 'none'
            % No visualization
        otherwise
            warning('plotType "%s" not recognized. No plot will be displayed.', plotType);
    end

end
