// Low-step volumetric slab. Cellular erosion creates a chunky, sculpted cloud edge.
float cloudDensity(vec3 p){
    float broad=cnoise3(p*0.72);
    float detail=cnoise3(p*1.75+vec3(7.1,2.4,4.8));
#if CLOUD_QUALITY >= 2
    detail=detail*0.65+cnoise3(p*3.4+vec3(2.0,8.0,1.0))*0.35;
#endif
    float shape=broad*0.78+detail*0.22;
    float vertical=1.0-smoothstep(0.02,0.34,abs(p.y));
    return smoothstep(0.57-CLOUD_AMOUNT*0.22,0.76-CLOUD_AMOUNT*0.12,shape)*vertical;
}
vec3 renderVolumetricClouds(vec3 rd, vec3 sunDir, float time){
#if CLOUD_MODE == 0
    return vec3(0.0);
#else
    if(rd.y<0.035) return vec3(0.0);
    float t0=(0.48-rd.y*0.04)/max(rd.y,0.035);
    float t1=(0.68-rd.y*0.04)/max(rd.y,0.035);
    vec3 drift=vec3(time*0.000018*CLOUD_SPEED,0.0,time*0.000009*CLOUD_SPEED);
    float trans=1.0; vec3 accum=vec3(0.0);
#if CLOUD_QUALITY == 1
    const int STEPS=5;
#elif CLOUD_QUALITY == 2
    const int STEPS=7;
#else
    const int STEPS=10;
#endif
    float stepLen=(t1-t0)/float(STEPS);
    for(int i=0;i<STEPS;i++){
        float t=t0+(float(i)+0.5)*stepLen;
        vec3 p=vec3(rd.xz*(t*6.0),0.0).xzy+drift; p.y=(t-t0)/max(t1-t0,0.0001)-0.5;
        float d=cloudDensity(p);
        if(d>0.025){
            // Approximate normal from density gradient: deliberately crisp / blocky.
            vec3 e=vec3(0.018,0.018,0.018);
            vec3 n=normalize(vec3(cloudDensity(p+e.xyy)-cloudDensity(p-e.xyy),cloudDensity(p+e.yxy)-cloudDensity(p-e.yxy),cloudDensity(p+e.yyx)-cloudDensity(p-e.yyx))+vec3(0.0001));
            float sunlit=max(dot(n,normalize(sunDir)),0.0);
            float phase=0.35+0.65*max(dot(rd,normalize(sunDir)),0.0);
            vec3 light=mix(vec3(0.34,0.42,0.56),vec3(1.0,0.88,0.68),clamp(0.22+sunlit*0.72+phase*0.18,0.0,1.0));
            float a=d*0.34;
            accum+=trans*a*light;
            trans*=1.0-a;
        }
    }
    return accum;
#endif
}
