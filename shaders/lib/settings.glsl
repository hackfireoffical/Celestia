// =============================================================================
//  Celestia Mobile - user settings
//  Every #define below is exposed in the Iris shader settings screen.
//  Defaults match the MEDIUM preset.
//  Target: Minecraft 1.21.11 (Iris + Sodium)
// =============================================================================

// ---- Sky & clouds
#define CLOUD_MODE 1              //[0 1]
#define CLOUD_QUALITY 2           //[1 2 3]
#define CLOUD_AMOUNT 0.50         //[0.20 0.35 0.50 0.65 0.80]
#define CLOUD_SPEED 1.0           //[0.0 0.5 1.0 1.5 2.0]
#define SKY_GLOW 1.0              //[0.5 0.75 1.0 1.25 1.5]
#define HAZE_START 0.55           //[0.35 0.45 0.55 0.70 0.85]

// ---- Night sky
#define STARS
#define STAR_QUALITY 1            //[1 2]
#define STAR_DENSITY 1.0          //[0.5 0.75 1.0 1.5 2.0]
#define STAR_TWINKLE
#define MILKY_WAY
#define COMETS
#define COMET_FREQUENCY 1.0       //[0.5 1.0 2.0 3.0]
#define METEOR_SHOWERS
#define AURORA
#define AURORA_QUALITY 2          //[1 2 3]
#define AURORA_INTENSITY 1.0      //[0.5 0.75 1.0 1.25 1.5]

// ---- Glow
#define BLOCK_GLOW
#define BLOCK_GLOW_STRENGTH 1.0   //[0.5 1.0 1.5 2.0]

// ---- The End
#define BLACK_HOLE
#define BH_SIZE 0.10              //[0.05 0.075 0.10 0.14 0.18]
#define BH_GLOW 1.0               //[0.5 1.0 1.5 2.0]

// ---- Lighting
#define SUN_DIRECTIONAL 1.0       //[0.0 0.5 1.0 1.5 2.0]
#define MIN_LIGHT 0.05            //[0.0 0.03 0.05 0.08 0.12]

// ---- Realtime directional shadows (sun + moon). Lightweight, no shadow maps.
#define SHADOWS
#define SHADOW_STRENGTH 1.0       //[0.5 0.75 1.0 1.25 1.5]
#define COLORED_SHADOWS
#define ENTITY_SHADOWS

// ---- Water
#define WATER_REFLECTIONS
#define WATER_WAVES
#define WATER_REFLECT_STRENGTH 0.55 //[0.25 0.40 0.55 0.70]
