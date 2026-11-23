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
    float sd=max(dot(d,sun),0.0);
    float sunDisc=pow(sd,900.0); float halo=pow(sd,24.0);
    sky+=vec3(1.0,0.82,0.58)*(sunDisc*1.8+halo*0.12*SKY_GLOW);
#ifdef NIGHT_STARS
    if(day<0.08&&d.y>0.0){
        vec3 cell=floor(d*620.0); float h=hash13(cell);
        float star=step(1.0-0.0028*STAR_DENSITY,h);
        float tw=0.65+0.35*sin(frameTimeCounter*2.5+h*400.0);
        sky+=vec3(0.72,0.82,1.0)*star*tw*(1.0-day*12.5)*smoothstep(0.0,0.15,d.y)*(1.0-rainStrength);
    }
#endif
    vec4 cl=renderBoxyClouds(d,sun,frameTimeCounter,day,twilight,rainStrength);
    sky=sky*(1.0-cl.a)+cl.rgb;
    gl_FragColor=vec4(sky,1.0);
}
