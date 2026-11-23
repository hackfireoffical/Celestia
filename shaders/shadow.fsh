#version 120
uniform sampler2D texture;
varying vec2 vTex;
void main(){
    if(texture2D(texture,vTex).a<0.10) discard;
}
