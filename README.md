# 🔧 Signal Processing toolkit (MATLAB)

A MATLAB toolbox for spectral analysis, angular resampling, time synchronous averaging and filtering of signals acquired from accelerometers, microphones, tachometers, and other rotating machine sensors.

This toolbox is designed for advanced analysis of rotating machinery vibration or acoustic signals, making it easier to extract synchronous information and study dynamic behavior.

---

## ✨ Features

- ✅ FFT and Power Spectral Density (PSD) computation
- ✅ Short-Time Fourier Transform (STFT)
- ✅ Envelope analysis using Hilbert transform
- ✅ Frequency-domain band-pass filtering
- ✅ Angular resampling using tachometer signals
- ✅ Transformation to driven shaft using transmission ratio (τ)
- ✅ Time synchronous average (TSA)

---

## 🗂️ Repository structure

```
repository-root/
├── functions
│ └── % MATLAB functions (main toolbox)
├── examples/ % Example scripts
│ └── demoAngularResampling.m
├── README.md
└── LICENSE (MIT)
```

---

## ⚙️ Requirements

- MATLAB R2016b or newer
- Compatible with GNU Octave (some plotting functions may vary)

---

## 🚀 Quick start

### Clone the repository

```bash
git clone https://github.com/gdipace23/rotating-machine-signal-processing-matlab.git
cd rotating-machine-signal-processing-matlab
```

### Run the example script

```matlab
examples/demoAngularResampling.m
```

This script will:

- Generate an artificial rotating signal with speed fluctuations
- Simulate a tachometer signal
- Perform angular resampling
- Compute time synchronous average (TSA)
- Compute and display FFT, PSD, and signal envelope

---

## 💻 Function overview

| Function                    | Description                                           |
|-----------------------------|-------------------------------------------------------|
| `angularResamplingWithTacho`| Angular resampling using a tachometer signal         |
| `angularResamplingWithTau`  | Angular transformation using transmission ratio      |
| `timeSynchronousAverage`    | Time synchronous averaging (TSA)                     |
| `computeFFT`                | FFT with windowing (single- or double-sided)        |
| `computePSD`                | Power Spectral Density (PSD) using Welch's method   |
| `computeSTFT`               | Short-Time Fourier Transform (STFT)                  |
| `computeSignalEnvelope`     | Signal envelope using Hilbert transform             |
| `filterSignalByFrequency`   | Frequency-domain band-pass filtering                |

---

## 📚 Documentation

Each function is fully documented in its header.  
Check the main folder for detailed descriptions and usage examples.

---

## 👤 Author

Developed by **Giuseppe Dipace**.

---

## 📄 License

This project is licensed under the MIT License.  
See `LICENSE.md` for details.

---

## ⭐ Contributing

Pull requests and suggestions are welcome!  
Feel free to open an [issue](https://github.com/gdipace23/signal-processing-toolkit-matlab/issues) or create a PR.

---
