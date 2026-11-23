#version 120
#include "/lib/shadow_distort.glsl"
varying vec2 vTex;
void main(){
    vec4 p=ftransform();
    p.xy=shadowDistort(p.xy);
    gl_Position=p;
    vTex=gl_MultiTexCoord0.st;
}
