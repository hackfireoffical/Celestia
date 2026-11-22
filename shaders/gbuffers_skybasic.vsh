#version 120
varying vec3 vRay; uniform mat4 gbufferModelViewInverse;
void main(){ gl_Position=ftransform(); vRay=normalize(mat3(gbufferModelViewInverse)*(gl_ModelViewMatrix*gl_Vertex).xyz); }
