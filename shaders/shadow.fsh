#version 120
uniform sampler2D texture;
void main(){ if(texture2D(texture,gl_TexCoord[0].st).a<0.10) discard; }
