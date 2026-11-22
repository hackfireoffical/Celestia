float hash12(vec2 p){ vec3 p3=fract(vec3(p.xyx)*0.1031); p3+=dot(p3,p3.yzx+33.33); return fract((p3.x+p3.y)*p3.z); }
float hash13(vec3 p){ p=fract(p*0.1031); p+=dot(p,p.zyx+31.32); return fract((p.x+p.y)*p.z); }
float cnoise3(vec3 x){ vec3 i=floor(x), f=fract(x); f=f*f*(3.0-2.0*f); float n=i.x+i.y*57.0+i.z*113.0; return mix(mix(mix(hash13(vec3(n)),hash13(vec3(n+1.0)),f.x),mix(hash13(vec3(n+57.0)),hash13(vec3(n+58.0)),f.x),f.y),mix(mix(hash13(vec3(n+113.0)),hash13(vec3(n+114.0)),f.x),mix(hash13(vec3(n+170.0)),hash13(vec3(n+171.0)),f.x),f.y),f.z); }
float cnoise2(vec2 p){ vec2 i=floor(p),f=fract(p); f=f*f*(3.0-2.0*f); float a=hash12(i),b=hash12(i+vec2(1,0)),c=hash12(i+vec2(0,1)),d=hash12(i+vec2(1,1)); return mix(mix(a,b,f.x),mix(c,d,f.x),f.y); }
vec3 tonemapSoft(vec3 x){ return x/(1.0+x); }
