#version 120
/* DRAWBUFFERS:0 */
#include "/lib/settings.glsl"
uniform sampler2D colortex0; varying vec2 texcoord;
void main(){
    vec3 c=texture2D(colortex0,texcoord).rgb;
    c=c/(vec3(1.0)+max(c-vec3(1.0),vec3(0.0))*0.22);             // highlight roll-off

    // Colour scheme: tint, shadow lift, saturation, contrast.
    vec3 tint=vec3(1.0); vec3 lift=vec3(0.0); float sat=1.08; float con=0.25;
#if COLOR_SCHEME == 1        // Warm Golden
    tint=vec3(1.07,1.00,0.89); lift=vec3(0.010,0.004,0.000); sat=1.18; con=0.28;
#elif COLOR_SCHEME == 2      // Cool Moonlit
    tint=vec3(0.92,0.99,1.10); lift=vec3(0.000,0.005,0.014); sat=0.95; con=0.30;
#elif COLOR_SCHEME == 3      // Pastel Cozy
    tint=vec3(1.04,0.99,1.02); lift=vec3(0.030,0.022,0.030); sat=0.88; con=0.10;
#elif COLOR_SCHEME == 4      // Vivid
    tint=vec3(1.02,1.00,1.00); sat=1.38; con=0.38;
#endif
    c=c*tint+lift;
    float l=dot(c,vec3(0.2126,0.7152,0.0722));
    c=mix(vec3(l),c,sat);
    vec3 cc=clamp(c,0.0,1.0);
    c=mix(c,cc*cc*(3.0-2.0*cc),con);                              // soft S-curve contrast
    gl_FragColor=vec4(c,1.0);
}
