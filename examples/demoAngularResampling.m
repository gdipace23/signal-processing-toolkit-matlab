%% demoAngularResampling.m - Demo Test Script for Angular Signal Processing Toolbox
%
% Example script to demonstrate angular resampling functions.
% This script generates an artificial rotating signal with speed fluctuations,
% simulates a tachometer signal, performs angular resampling,
% computes the Time Synchronous Average (TSA), FFT, PSD, and envelope.
%
% Author: Giuseppe Dipace
% Date: 16/07/2025
% License: MIT

% Add functions folder to path
addpath('..');

clear; close all; clc;

%% Generate artificial signal

fs = 5000;              % Sampling frequency [Hz]
T = 2;                  % Duration [s]
t = (0:1/fs:T-1/fs)';   % Time vector

% Main rotating frequency (simulated shaft frequency)
f_rot = 20;    % Mean rotation frequency [Hz]
modAmp = 2;         % Modulation amplitude [Hz]
modFreq = 10;       % Modulation frequency [Hz]

% Simulated vibration components
signal = 0.5 * sin(2*pi*f_rot*t) + ...
         0.3 * sin(2*pi*3*f_rot*t) + ...
         0.1 * sin(2*pi*5*f_rot*t);

% Additive Gaussian noise
signal = signal + 0.02 * randn(size(signal));

% Simulated tacho signal (square wave to mimic pulses)
pulsesPerRev = 1;

% Instantaneous rotation frequency (simulate slight speed variation)
f_inst = f_rot + modAmp * sin(2*pi*modFreq*t);

% Instantaneous phase (integral of frequency)
phase = cumsum(f_inst) / fs * 2*pi;

% Tacho signal: square wave based on instantaneous phase
tacho = 0.5 + 0.5 * square(phase);

%% Compute FFT on original signal

[spectrum, freq] = computeFFT(signal, fs, 'single', 'hann');

%% Compute PSD on original signal

[psd, freqPsd] = computePSD(signal, fs, 1, 1024, 512, 'hann', true);

%% Compute envelope of original signal

[envelope, tEnv] = computeSignalEnvelope(signal, fs, true);

%% Angular resampling

triggerLevel = 0.5;

[signalTheta, angleVec, samplesPerRev, numRevs] = ...
    angularResamplingWithTacho(signal, fs, tacho, pulsesPerRev, triggerLevel, true);

%% Time synchronous average

[signalSync, angleSync] = timeSynchronousAverage(signalTheta, samplesPerRev, numRevs, true);

%% Plot summary

figure;
subplot(3,1,1);
plot(t, signal);
title('Original noisy signal');
xlabel('Time [s]');
ylabel('Amplitude');

subplot(3,1,2);
plot(angleVec, signalTheta);
title('Angular resampled signal');
xlabel('Angle [rad]');
ylabel('Amplitude');

subplot(3,1,3);
plot(angleSync, signalSync);
title('Time synchronous average (TSA)');
xlabel('Angle [rad]');
ylabel('Amplitude');

sgtitle('Summary of simulated signal processing');
