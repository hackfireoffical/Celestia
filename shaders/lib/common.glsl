float hash12(vec2 p){ vec3 p3=fract(vec3(p.xyx)*0.1031); p3+=dot(p3,p3.yzx+33.33); return fract((p3.x+p3.y)*p3.z); }
float hash13(vec3 p){ p=fract(p*0.1031); p+=dot(p,p.zyx+31.32); return fract((p.x+p.y)*p.z); }
float cnoise2(vec2 p){ vec2 i=floor(p),f=fract(p); f=f*f*(3.0-2.0*f); float a=hash12(i),b=hash12(i+vec2(1.0,0.0)),c=hash12(i+vec2(0.0,1.0)),d=hash12(i+vec2(1.0,1.0)); return mix(mix(a,b,f.x),mix(c,d,f.x),f.y); }
// Interleaved gradient noise: cheap per-pixel dither for PCF / godray jitter.
float ign(vec2 p){ return fract(52.9829189*fract(dot(p,vec2(0.06711056,0.00583715)))); }
