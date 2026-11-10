// VERTEX ONLY: derives the time-of-day sky state from the sun/moon uniforms.
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform int moonPhase;
uniform float rainStrength;

vec3 gSunDir;
vec3 gMoonDir;
float gDay;
float gTwil;
float gNight;
float gMoonB;
float gSunVis;

const vec3 DAY_ZENITH    = vec3(0.20, 0.44, 0.88);
const vec3 DAY_HORIZON   = vec3(0.62, 0.79, 0.96);
const vec3 NIGHT_ZENITH  = vec3(0.012, 0.026, 0.080);
const vec3 NIGHT_HORIZON = vec3(0.035, 0.070, 0.165);
const vec3 TWIL_ZENITH   = vec3(0.10, 0.20, 0.48);
const vec3 TWIL_HORIZON  = vec3(0.50, 0.50, 0.62);

void computeSkyVars() {
    mat3 rot = mat3(gbufferModelViewInverse);
    gSunDir  = normalize(rot * sunPosition);
    gMoonDir = normalize(rot * moonPosition);
    float sy = gSunDir.y;

    gDay   = smoothstep(-0.12, 0.22, sy);
    gTwil  = smoothstep(-0.20, 0.02, sy) * (1.0 - smoothstep(0.02, 0.40, sy));
    gNight = 1.0 - smoothstep(-0.30, 0.00, sy);
    gMoonB = abs(4.0 - float(moonPhase)) * 0.25;   // 1 = full moon, 0 = new moon
    float rdim = 1.0 - 0.85 * rainStrength;
    gSunVis = smoothstep(-0.10, 0.08, sy) * rdim;

    vec3 zen = mix(NIGHT_ZENITH, DAY_ZENITH, gDay);
    vec3 hor = mix(NIGHT_HORIZON, DAY_HORIZON, gDay);
    zen = mix(zen, TWIL_ZENITH, gTwil * 0.8);
    hor = mix(hor, TWIL_HORIZON, gTwil * 0.8);
    vec3 overcast = mix(vec3(0.02, 0.025, 0.04), vec3(0.50, 0.54, 0.60), gDay);
    zen = mix(zen, overcast * 0.85, rainStrength * 0.85);
    hor = mix(hor, overcast * 1.10, rainStrength * 0.85);

    float moonVis = smoothstep(-0.05, 0.10, gMoonDir.y) * (0.25 + 0.75 * gMoonB) * (1.0 - gDay) * rdim;

    vHorizon = vec4(hor, gSunVis);
    vSkyA = vec4(gSunDir, gTwil);
#if defined(WATER) || defined(SKY_PASS)
    // Only the sky dome and water reflections need the full gradient + moon halo.
    vZenith  = zen;
    vSkyB = vec4(gMoonDir, moonVis);
#endif
}
