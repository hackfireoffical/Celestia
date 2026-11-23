varying vec2 vTex; varying vec4 vColor; varying vec2 vLight;
varying vec3 vNormal; varying vec3 vWorldNormal; varying vec3 vShadowPos;
varying vec3 vSun;       // x = day, y = twilight, z = height of the active light (sun or moon)
varying vec3 vLightDir;  // view-space direction of the active light
varying float vEmit;
uniform mat4 gbufferModelViewInverse; uniform mat4 shadowModelView; uniform mat4 shadowProjection;
uniform vec3 sunPosition; uniform vec3 shadowLightPosition;
#if defined(TERRAIN) || defined(WATER)
attribute vec4 mc_Entity;
#endif
void main(){
    gl_Position=ftransform();
    vTex=(gl_TextureMatrix[0]*gl_MultiTexCoord0).st;
    vColor=gl_Color;
    vLight=(gl_TextureMatrix[1]*gl_MultiTexCoord1).st;
    vNormal=normalize(gl_NormalMatrix*gl_Normal);
    vWorldNormal=normalize(mat3(gbufferModelViewInverse)*vNormal);
    vLightDir=normalize(shadowLightPosition);
    vec3 sd=normalize(mat3(gbufferModelViewInverse)*sunPosition);
    vec3 ld=normalize(mat3(gbufferModelViewInverse)*shadowLightPosition);
    vSun=vec3(smoothstep(-0.10,0.22,sd.y),1.0-smoothstep(0.0,0.38,abs(sd.y)),ld.y);
    vec4 wp=gbufferModelViewInverse*(gl_ModelViewMatrix*gl_Vertex);
    // Normal-offset bias: removes acne without peter-panning.
    wp.xyz+=vWorldNormal*(0.05+0.15*(1.0-abs(dot(vWorldNormal,ld))));
    vShadowPos=(shadowProjection*(shadowModelView*wp)).xyz;
    vEmit=0.0;
#if defined(TERRAIN) || defined(WATER)
    if(abs(mc_Entity.x-10002.0)<0.5) vEmit=1.0;
#endif
}
