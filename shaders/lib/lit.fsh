#include "/lib/settings.glsl"
#include "/lib/common.glsl"
#include "/lib/shadow_distort.glsl"
varying vec2 vTex; varying vec4 vColor; varying vec2 vLight;
varying vec3 vNormal; varying vec3 vWorldNormal; varying vec3 vShadowPos;
varying vec3 vSun; varying vec3 vLightDir; varying float vEmit;
uniform sampler2D texture; uniform sampler2D lightmap; uniform sampler2D shadowtex1;

#if defined(SHADOWS) && !defined(HAND)
// Rotated-disc PCF on the opaque shadow map (translucents don't cast), with edge fade.
float shadowVisibility(float ndl){
    vec3 sp=vShadowPos;
    float edge=1.0-smoothstep(0.80,0.98,length(sp.xy));
    vec2 xy=shadowDistort(sp.xy)*0.5+0.5;
    float z=sp.z*0.5+0.5;
    if(xy.x<0.0||xy.x>1.0||xy.y<0.0||xy.y>1.0||z>1.0) return 1.0;
    float bias=0.0006+0.0014*(1.0-ndl);
#if SHADOW_QUALITY == 0
    const int N=1; const float rad=0.0;
#elif SHADOW_QUALITY == 1
    const int N=4; const float rad=1.8/SHADOW_RES;
#else
    const int N=8; const float rad=2.2/SHADOW_RES;
#endif
    float rot=ign(gl_FragCoord.xy)*6.2831853;
    float vis=0.0;
    for(int i=0;i<N;i++){
        float a=rot+float(i)*2.3999632;
        float r=sqrt((float(i)+0.5)/float(N))*rad;
        vis+=step(z-bias,texture2D(shadowtex1,xy+vec2(cos(a),sin(a))*r).r);
    }
    return mix(1.0,vis/float(N),edge);
}
#endif

void main(){
    vec4 tex=texture2D(texture,vTex)*vColor;
    if(tex.a<0.08) discard;
    float day=vSun.x; float twil=vSun.y;
    float lightUp=smoothstep(-0.02,0.14,vSun.z);          // smooth sun<->moon hand-over
    float ndl=dot(normalize(vNormal),normalize(vLightDir));
    float facing=smoothstep(0.0,0.2,ndl);
    float vis=1.0;
#if defined(SHADOWS) && !defined(HAND)
    if(facing>0.0) vis=shadowVisibility(clamp(ndl,0.0,1.0));
#endif
    vis=mix(1.0,vis,SHADOW_STRENGTH);
    float amount=clamp(facing*vis*lightUp*SUN_DIRECTIONAL,0.0,1.0);

    vec3 sunCol=mix(vec3(1.07,1.00,0.90),vec3(1.0,0.60,0.32),twil);
    vec3 lightCol=mix(vec3(0.85,0.95,1.25),sunCol,day);
    vec3 shadeCol=mix(vec3(0.78,0.86,1.00),vec3(0.52,0.60,0.82),day);   // cool, tinted shade
    shadeCol=mix(shadeCol,vec3(0.56,0.50,0.70),twil*0.4);
    vec3 lit=mix(shadeCol,lightCol,amount);
    float skyMask=smoothstep(0.30,0.92,vLight.y)*(1.0-0.65*vLight.x);   // caves / torch-lit areas keep vanilla light
    vec3 light=mix(vec3(1.0),lit,skyMask);
    float face=mix(0.78,1.0,vWorldNormal.y*0.5+0.5);

    vec3 lm=texture2D(lightmap,clamp(vLight,0.0,1.0)).rgb;
    vec3 rgb=tex.rgb*lm*light*face;
    rgb=max(rgb,tex.rgb*vec3(0.80,0.90,1.00)*MIN_LIGHT);

    float lum=dot(tex.rgb,vec3(0.2126,0.7152,0.0722));
    float emit=vEmit*smoothstep(0.30,0.80,lum);
    rgb=mix(rgb,tex.rgb*1.3,emit);

    gl_FragData[0]=vec4(rgb,tex.a);
    gl_FragData[1]=vec4(emit,0.0,0.0,1.0);                 // emissive mask for bloom
}
