// Lightweight 2D cloud layer: a planar projection of cheap fbm value noise.
// No ray marching. Needs common.glsl + settings.glsl.
float cloudFbm(vec2 p) {
    float s = vnoise(p) * 0.5;
    p = p * 2.03 + vec2(17.1, 9.2);
    s += vnoise(p) * 0.25;
#if CLOUD_QUALITY >= 2
    p = p * 2.03 + vec2(31.7, 12.9);
    s += vnoise(p) * 0.125;
    return s / 0.875;
#else
    return s / 0.75;
#endif
}

vec2 cloudUV(vec3 d, float t) {
    return d.xz / (d.y + 0.25) * 2.0 + vec2(1.0, 0.42) * (t * 0.0065 * CLOUD_SPEED);
}

float cloudMask(vec3 d, float t) {
    if (d.y < 0.02) return 0.0;
    vec2 uv = cloudUV(d, t);
    float c = cloudFbm(uv * 0.55);
    float amount = CLOUD_AMOUNT;
    float dens = smoothstep(1.0 - amount, 1.0 - amount + 0.25, c);
    float fade = smoothstep(0.02, 0.18, d.y);
    return dens * fade;
}
