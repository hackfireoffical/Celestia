#version 120
/* DRAWBUFFERS:0 */
// Pass 2: bloom. Two jittered rings (tight + wide) around each pixel, fed by bright
// pixels (soft threshold) and the emissive mask written by the terrain pass.
#include "/lib/settings.glsl"
#include "/lib/common.glsl"
uniform sampler2D colortex0; uniform sampler2D colortex1;
uniform float viewWidth; uniform float viewHeight;
varying vec2 texcoord;
vec3 bloomTap(vec2 uv){
    uv=clamp(uv,vec2(0.001),vec2(0.999));
    vec3 c=texture2D(colortex0,uv).rgb;
    float e=texture2D(colortex1,uv).r;
    float l=dot(c,vec3(0.2126,0.7152,0.0722));
    float k=max(smoothstep(BLOOM_THRESHOLD,BLOOM_THRESHOLD+0.2,l)*0.6,e);
    return c*k;
}
void main(){
    vec3 base=texture2D(colortex0,texcoord).rgb;
#ifdef BLOOM
    vec2 px=1.0/vec2(viewWidth,viewHeight);
    float sc=viewHeight/1080.0;
    float rot=ign(gl_FragCoord.xy)*6.2831853;
    vec3 acc=bloomTap(texcoord)*0.2;
    for(int i=0;i<6;i++){
        float a=rot+float(i)*1.0471976;
        vec2 dir=vec2(cos(a),sin(a))*px;
        acc+=bloomTap(texcoord+dir*4.0*sc)*0.1+bloomTap(texcoord+dir*12.0*sc)*0.0333;
    }
    base+=acc*BLOOM_STRENGTH*2.5;
#endif
    gl_FragColor=vec4(base,1.0);
}
