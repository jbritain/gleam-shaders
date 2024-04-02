
/*
const int colortex0Format = RGBA16F; // albedo
const int colortex1Format = RGB16; // normal (encoded)
const int colortex2Format = RGB16; // lightmap coords
const int colortex3Format = RGBA16F; // position in shadow space

const int noiseTextureResolution = 128;

const bool shadowHardwareFiltering = true;      shadowHardwareFiltering = true
const bool shadowHardwareFiltering0 = true;     shadowHardwareFiltering[0] = true
const bool shadowHardwareFiltering1 = true;     shadowHardwareFiltering[1] = true
*/

#define AMBIENT_LIGHT 5.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]

const float sunPathRotation = -40; // [-90 -80 -70 -60 -50 -40 -30 -20 -10 0 10 20 30 40 50 60 70 80 90]

#define SHADOW_DISTORT_ENABLED
#define SHADOW_DISTORT_FACTOR 0.10 // [0.00 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.10 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.20 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.30 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.40 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.50 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.60 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.70 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.80 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.90 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.00]
#define SHADOW_BIAS 0.001 // [0.001 0.002 0.003 0.004 0.005 0.006 0.007 0.008 0.009 0.1]
#define SHADOWS

#define EXCLUDE_FOLIAGE

#define PCF_SAMPLE_COUNT 4 // [1 2 3 4 5]

const int shadowMapResolution = 4096; // [128 256 512 1024 2048 4096 8192]

#define SATURATION 1.4 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define BRIGHTNESS 1.0 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]

const vec3 artificialLightColor = vec3(1, 0.725, 0.5);

#define ARTIFICIAL_LIGHT_BRIGHTNESS 0.1

#define GAMMA 2.2

#define FOG