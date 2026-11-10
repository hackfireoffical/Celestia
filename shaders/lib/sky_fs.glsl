// FRAGMENT: analytic sky gradient + sunrise/sunset glow + sun & moon halos.
// Used by the sky dome, by distance fog on terrain and by water reflections.
#if defined(SKY_PASS) || defined(WATER)
vec3 skyBase(vec3 d) {
    // Below the horizon we reuse the horizon colour so fog and sky always match.
    // The 1e-4 keeps normalize() finite when looking straight down.
    vec3 dn = normalize(vec3(d.x, max(d.y, 0.0) + 1e-4, d.z));
    float y = dn.y;
    float inv = 1.0 - y;
    float i2 = inv * inv;
    float t = i2 * i2 * inv;                       // (1-y)^5 : gradient hugs the horizon
    vec3 col = mix(vZenith, vHorizon.rgb, t);

    float twil = vSkyA.w;
    float sd = dot(dn, vSkyA.xyz);
    float sp = max(sd, 0.0);
    float s2 = sp * sp;
    float s4 = s2 * s2;
    float s8 = s4 * s4;
    float s16 = s8 * s8;
    float s32 = s16 * s16;

    // Golden glow along the horizon, strongest around the sun.
    float m4 = i2 * i2;
    vec3 glowCol = mix(vec3(1.0, 0.46, 0.18), vec3(1.0, 0.68, 0.40), clamp(y * 3.0, 0.0, 1.0));
    float glow = clamp(twil * m4 * (0.22 + 0.78 * s2) * 0.9 * SKY_GLOW, 0.0, 1.0);
    col = mix(col, glowCol, glow);

    // Soft purple belt on the opposite side of the sky.
    float om = max(-sd, 0.0);
    om *= om;
    col = mix(col, vec3(0.60, 0.44, 0.72), clamp(twil * m4 * om * 0.35, 0.0, 1.0));

    // Sun halo / atmospheric scattering.
    vec3 haloCol = mix(vec3(1.0, 0.93, 0.78), vec3(1.0, 0.64, 0.32), twil);
    col += haloCol * ((s32 * 0.45 + s8 * 0.10 + s2 * 0.04) * vHorizon.a * SKY_GLOW);

    // Moon halo.
    float mp = max(dot(dn, vSkyB.xyz), 0.0);
    float p2 = mp * mp;
    float p4 = p2 * p2;
    float p8 = p4 * p4;
    float p16 = p8 * p8;
    float p32 = p16 * p16;
    col += vec3(0.50, 0.64, 1.0) * ((p32 * 0.30 + p8 * 0.08 + p2 * 0.02) * vSkyB.w * SKY_GLOW);
    return col;
}
#endif

// Cheap distance-fog colour for terrain/entities: horizon haze + twilight glow + sun halo.
// Needs only vHorizon and vSkyA, so ordinary geometry passes interpolate far fewer varyings.
vec3 skyFog(vec3 d) {
    float twil = vSkyA.w;
    float sd = dot(d, vSkyA.xyz);
    float sp = max(sd, 0.0);
    float s2 = sp * sp;
    float s4 = s2 * s2;
    float s8 = s4 * s4;
    float s16 = s8 * s8;
    float s32 = s16 * s16;
    vec3 col = vHorizon.rgb;
    col = mix(col, vec3(1.0, 0.46, 0.18), clamp(twil * (0.22 + 0.78 * s2) * 0.9 * SKY_GLOW, 0.0, 1.0));
    float om = max(-sd, 0.0);
    col = mix(col, vec3(0.60, 0.44, 0.72), clamp(twil * om * om * 0.35, 0.0, 1.0));
    vec3 haloCol = mix(vec3(1.0, 0.93, 0.78), vec3(1.0, 0.64, 0.32), twil);
    col += haloCol * ((s32 * 0.45 + s8 * 0.10 + s2 * 0.04) * vHorizon.a * SKY_GLOW);
    return col;
}
