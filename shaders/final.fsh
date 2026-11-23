#version 120
/* DRAWBUFFERS:0 */
uniform sampler2D colortex0; varying vec2 texcoord;
void main(){
    vec3 c=texture2D(colortex0,texcoord).rgb;
    c=c/(vec3(1.0)+max(c-vec3(1.0),vec3(0.0))*0.22);             // highlight roll-off
    float l=dot(c,vec3(0.2126,0.7152,0.0722));
    c=mix(vec3(l),c,1.08);                                       // gentle vibrance
    c=c*c*(3.0-2.0*c)*0.25+c*0.75;                               // soft S-curve contrast
    gl_FragColor=vec4(c,1.0);
}
