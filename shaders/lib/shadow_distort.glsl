// Shared by shadow.vsh and lit.fsh: spends more shadow-map texels near the player.
#ifndef CELESTIA_SHADOW_DISTORT
#define CELESTIA_SHADOW_DISTORT
#define SHADOW_RES 1024.0
vec2 shadowDistort(vec2 xy){
    float d=length(xy)*0.85+0.15;
    return xy/d;
}
#endif
