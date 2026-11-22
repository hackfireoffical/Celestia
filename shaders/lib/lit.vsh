varying vec2 vTex; varying vec4 vColor; varying vec2 vLight; varying vec3 vNormal; varying vec3 vViewPos; varying vec4 vShadowPos;
uniform mat4 gbufferModelViewInverse; uniform mat4 shadowModelView; uniform mat4 shadowProjection;
void main(){
    gl_Position=ftransform(); vTex=gl_MultiTexCoord0.st; vColor=gl_Color;
    vLight=gl_MultiTexCoord1.st; vNormal=normalize(gl_NormalMatrix*gl_Normal);
    vec4 viewPos=gl_ModelViewMatrix*gl_Vertex; vViewPos=viewPos.xyz;
    vec4 worldPos=gbufferModelViewInverse*viewPos;
    vShadowPos=shadowProjection*shadowModelView*worldPos;
}
