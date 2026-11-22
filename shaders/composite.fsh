#version 120
/* DRAWBUFFERS:0 */
#include "/lib/settings.glsl"
uniform sampler2D colortex0; uniform sampler2D depthtex0;
uniform int viewWidth; uniform int viewHeight; uniform vec3 sunPosition; uniform mat4 gbufferProjection;
varying vec2 texcoord;
vec3 scene(vec2 uv){ return texture2D(colortex0,clamp(uv,vec2(0.001),vec2(0.999))).rgb; }
void main(){
    vec2 uv=gl_TexCoord[0].st; vec3 base=scene(uv); vec2 px=1.0/vec2(float(viewWidth),float(viewHeight));
#ifdef BLOOM
    vec3 bloom=vec3(0.0); float w=0.0;
    for(int x=-2;x<=2;x++) for(int y=-2;y<=2;y++){
        vec3 c=scene(uv+vec2(float(x),float(y))*px*2.0);
        float l=max(max(c.r,c.g),c.b); float k=max(l-BLOOM_THRESHOLD,0.0);
        bloom+=c*k; w+=k;
    }
    bloom/=max(w,0.0001); base+=bloom*BLOOM_STRENGTH;
#endif
#ifdef GODRAYS
    vec4 sunClip=gbufferProjection*vec4(normalize(sunPosition),1.0);
    vec2 sunUV=sunClip.xy/max(abs(sunClip.w),0.001)*0.5+0.5;
    vec2 delta=(uv-sunUV)*0.075; vec2 p=uv; float rays=0.0;
    for(int i=0;i<8;i++){ p-=delta; vec3 s=scene(p); float bright=max(max(s.r,s.g),s.b); rays+=max(bright-0.62,0.0)*(1.0-float(i)/9.0); }
    float depth=texture2D(depthtex0,uv).r;
    base+=vec3(1.0,0.78,0.48)*rays*GODRAY_STRENGTH*0.018*step(0.9999,depth);
#endif
    gl_FragColor=vec4(base,1.0);
}
