#version 120
/* DRAWBUFFERS:0 */
// Pass 1: screen-space godrays. Marches towards the active light (sun or moon) and counts
// how much open sky it sees, so trees/terrain/buildings cut real shafts into the glow.
#include "/lib/settings.glsl"
#include "/lib/common.glsl"
uniform sampler2D colortex0; uniform sampler2D depthtex0;
uniform mat4 gbufferProjection; uniform mat4 gbufferModelViewInverse;
uniform vec3 shadowLightPosition; uniform vec3 sunPosition;
uniform float rainStrength; uniform float viewWidth; uniform float viewHeight;
uniform ivec2 eyeBrightnessSmooth;
varying vec2 texcoord;
void main(){
    vec3 base=texture2D(colortex0,texcoord).rgb;
#ifdef GODRAYS
    vec3 sunW=normalize(mat3(gbufferModelViewInverse)*sunPosition);
    float day=smoothstep(-0.08,0.22,sunW.y);
    float twil=1.0-smoothstep(0.0,0.35,abs(sunW.y));
    vec3 lightW=normalize(mat3(gbufferModelViewInverse)*shadowLightPosition);
    float lightUp=smoothstep(-0.02,0.15,lightW.y);
    vec4 lc=gbufferProjection*vec4(shadowLightPosition,1.0);
    float front=step(0.001,lc.w);
    vec2 luv=lc.xy/max(lc.w,0.001)*0.5+0.5;
    vec2 dv=texcoord-luv; dv.x*=viewWidth/viewHeight;
    float falloff=pow(clamp(1.0-length(dv)*0.5,0.0,1.0),2.0);
    float outdoors=smoothstep(0.35,0.90,float(eyeBrightnessSmooth.y)/240.0);
    float amt=GODRAY_STRENGTH*falloff*front*lightUp*outdoors*(1.0-rainStrength*0.7);
    if(amt>0.002){
        const int N=GODRAY_SAMPLES;
        vec2 stepv=(luv-texcoord)*(0.9/float(N));
        vec2 p=texcoord+stepv*ign(gl_FragCoord.xy);
        float sum=0.0; float decay=1.0; float wsum=0.0;
        for(int i=0;i<N;i++){
            p+=stepv;
            float inb=step(0.0,p.x)*step(p.x,1.0)*step(0.0,p.y)*step(p.y,1.0);
            float sky=step(0.99999,texture2D(depthtex0,clamp(p,0.001,0.999)).r);
            sky=mix(1.0,sky,inb);                    // off-screen counts as open sky
            sum+=sky*decay; wsum+=decay; decay*=0.95;
        }
        float rays=sum/wsum; rays*=rays;             // contrast: sharper shafts
        float selfSky=step(0.99999,texture2D(depthtex0,texcoord).r);
        vec3 col=mix(vec3(1.0,0.86,0.62),vec3(1.0,0.52,0.28),twil);
        col=mix(vec3(0.45,0.58,1.0)*0.35,col,day);
        base+=col*rays*amt*mix(1.0,0.35,selfSky)*0.55;
    }
#endif
    gl_FragColor=vec4(base,1.0);
}
