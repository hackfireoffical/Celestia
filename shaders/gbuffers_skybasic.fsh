#version 120
/* DRAWBUFFERS:0 */
#include "/lib/settings.glsl"
#include "/lib/common.glsl"
#include "/lib/clouds.glsl"
varying vec3 vRay; uniform vec3 sunPosition; uniform mat4 gbufferModelViewInverse; uniform float rainStrength; uniform float frameTimeCounter;
void main(){
    vec3 d=normalize(vRay); vec3 sun=normalize(mat3(gbufferModelViewInverse)*sunPosition);
    float day=smoothstep(-0.12,0.20,sun.y); float twilight=1.0-smoothstep(0.0,0.35,abs(sun.y));
    vec3 sky=mix(vec3(0.012,0.025,0.075),vec3(0.22,0.48,0.82),day);
    sky=mix(sky,vec3(0.92,0.43,0.22),twilight*pow(1.0-max(d.y,0.0),2.0)*0.7);
    sky=mix(sky,vec3(0.30,0.37,0.48),rainStrength*0.65);
    float horizon=pow(1.0-max(d.y,0.0),5.0); sky=mix(sky,vec3(0.62,0.76,0.88),horizon*day*0.42);
    float sunDisc=pow(max(dot(d,sun),0.0),900.0); float halo=pow(max(dot(d,sun),0.0),24.0);
    sky+=vec3(1.0,0.82,0.58)*(sunDisc*1.8+halo*0.12*SKY_GLOW);
#ifdef NIGHT_STARS
    if(day<0.08){ vec3 cell=floor(d*850.0); float star=step(0.9975,hash12(cell.xy+cell.z)); sky+=vec3(0.72,0.82,1.0)*star*STAR_DENSITY*(1.0-day); }
#endif
    vec3 clouds=renderVolumetricClouds(d,sun,frameTimeCounter);
    float cloudAlpha=clamp(max(max(clouds.r,clouds.g),clouds.b)*1.8,0.0,0.82);
    sky=mix(sky,clouds*1.35,cloudAlpha);
    gl_FragColor=vec4(sky,1.0);
}
