#version 120
/* DRAWBUFFERS:0 */
uniform sampler2D colortex0; varying vec2 texcoord;
void main(){ vec3 c=texture2D(colortex0,gl_TexCoord[0].st).rgb; c=c/(vec3(1.0)+max(c-vec3(1.0),vec3(0.0))*0.22); gl_FragColor=vec4(c,1.0); }
