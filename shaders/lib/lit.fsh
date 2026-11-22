#include "/lib/settings.glsl"
varying vec2 vTex; varying vec4 vColor; varying vec2 vLight; varying vec3 vNormal; varying vec3 vViewPos; varying vec4 vShadowPos;
uniform sampler2D texture; uniform sampler2D lightmap; uniform sampler2D shadowtex0;
uniform vec3 sunPosition; uniform vec3 moonPosition; uniform float rainStrength;
vec3 celestiaShade(vec3 base){
    vec3 n=normalize(vNormal); vec3 l=normalize(sunPosition);
    float ndl=max(dot(n,l),0.0); float shade=MIN_LIGHT+(1.0-MIN_LIGHT)*(0.30+0.70*ndl*SUN_DIRECTIONAL);
#ifdef SHADOWS
    vec3 sc=vShadowPos.xyz/vShadowPos.w*0.5+0.5;
    if(sc.x>0.002&&sc.x<0.998&&sc.y>0.002&&sc.y<0.998&&sc.z>0.0&&sc.z<1.0){
        float stored=texture2D(shadowtex0,sc.xy).r;
        float visibility=(sc.z-0.0018<=stored)?1.0:0.22;
#if SHADOW_QUALITY >= 1
        visibility+=((sc.z-0.0018<=texture2D(shadowtex0,sc.xy+vec2(0.0012,0.0)).r)?1.0:0.22);
        visibility+=((sc.z-0.0018<=texture2D(shadowtex0,sc.xy+vec2(0.0,0.0012)).r)?1.0:0.22);
        visibility+=((sc.z-0.0018<=texture2D(shadowtex0,sc.xy-vec2(0.0012,0.0)).r)?1.0:0.22);
        visibility*=0.25;
#endif
#if SHADOW_QUALITY >= 2
        visibility+=((sc.z-0.0018<=texture2D(shadowtex0,sc.xy+vec2(0.0012,0.0012)).r)?1.0:0.22);
        visibility+=((sc.z-0.0018<=texture2D(shadowtex0,sc.xy-vec2(0.0012,0.0012)).r)?1.0:0.22);
        visibility+=((sc.z-0.0018<=texture2D(shadowtex0,sc.xy+vec2(0.0012,-0.0012)).r)?1.0:0.22);
        visibility+=((sc.z-0.0018<=texture2D(shadowtex0,sc.xy-vec2(0.0012,-0.0012)).r)?1.0:0.22);
        visibility*=0.2;
#endif
        shade*=mix(1.0,visibility,SHADOW_STRENGTH);
    }
#endif
    vec3 lm=texture2D(lightmap,clamp(vLight,0.0,1.0)).rgb;
    return base*max(vec3(shade),lm*0.92);
}
void main(){
    vec4 tex=texture2D(texture,vTex)*vColor;
#ifdef HAND
    gl_FragColor=tex; return;
#endif
    if(tex.a<0.08) discard;
    vec3 rgb=celestiaShade(tex.rgb);
    // Preserve bright emissive pixels and add a restrained warm torch lift.
    rgb+=tex.rgb*pow(max(dot(tex.rgb,vec3(0.2126,0.7152,0.0722))-0.72,0.0),2.0)*0.12;
    gl_FragColor=vec4(rgb,tex.a);
}
