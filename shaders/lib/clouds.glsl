// Boxy volumetric clouds ("Cloud 2" look): mounds of stacked cubes marched with a 3D DDA.
// Every cube has a crisp face normal (top lit, sides dimmer, undersides dark), thickness
// gives soft light absorption, and a one-cell sun probe gives cheap self-shadowing.
// Needs common.glsl + settings.glsl.
#define CLOUD_LAYERS 3.0
#define CLOUD_BASE 120.0
#define CLOUD_CELL_Y 7.0

#if CLOUD_QUALITY == 1
const int CLOUD_STEPS = 10;
#elif CLOUD_QUALITY == 2
const int CLOUD_STEPS = 16;
#else
const int CLOUD_STEPS = 24;
#endif

// Number of filled cubes stacked in one column (0 = clear sky).
float cloudLayersAt(vec2 col, float amount){
    float h=cnoise2(col*0.17+vec2(11.3,4.7))*0.68+cnoise2(col*0.43+vec2(2.1,9.4))*0.24+hash12(col)*0.08;
    float thr=0.74-amount*0.45;
    if(h<=thr) return 0.0;
    return clamp(floor((h-thr)*CLOUD_LAYERS*9.0)+1.0,1.0,CLOUD_LAYERS);
}

// 1 when the neighbouring cube towards the sun is solid (this cube is in cloud shade).
float cloudSunShadow(vec3 c, vec3 sunDir, float amount){
    vec3 q=c+floor(sunDir*1.5+0.5);
    if(q.y<0.0||q.y>=CLOUD_LAYERS) return 0.0;
    return step(q.y+0.5,cloudLayersAt(q.xz,amount));
}

// returns premultiplied colour in rgb, coverage in a
vec4 renderBoxyClouds(vec3 rd, vec3 sunDir, float time, float day, float twil, float rain){
#if CLOUD_MODE == 0
    return vec4(0.0);
#else
    float fade=smoothstep(0.045,0.24,rd.y);
    if(fade<=0.0) return vec4(0.0);
    float amount=clamp(CLOUD_AMOUNT+rain*0.30,0.0,0.95);
    vec3 cs=vec3(CLOUD_CELL,CLOUD_CELL_Y,CLOUD_CELL);
    vec2 drift=vec2(1.1,0.45)*(time*CLOUD_SPEED);

    // Enter the slab at its underside, then walk cube to cube.
    vec3 p=rd*(CLOUD_BASE/rd.y); p.y=0.0001; p.xz+=drift;
    vec3 c=floor(p/cs);
    vec3 fr=p/cs-c;
    vec3 stp=vec3(rd.x>=0.0?1.0:-1.0,1.0,rd.z>=0.0?1.0:-1.0);
    vec3 inv=1.0/max(abs(rd),vec3(0.0001));
    vec3 tDelta=cs*inv;
    vec3 tMax=mix(fr,1.0-fr,step(0.0,stp))*cs*inv;

    vec3 ambient=mix(vec3(0.11,0.14,0.26),vec3(0.60,0.68,0.84),day);
    ambient=mix(ambient,vec3(0.66,0.52,0.52),twil*0.4);
    vec3 sunC=mix(vec3(1.05,0.98,0.88),vec3(1.0,0.54,0.26),twil)*day;
    ambient=mix(ambient,vec3(dot(ambient,vec3(0.3333)))*0.8,rain*0.7);
    sunC*=1.0-rain*0.8;
    float silver=pow(max(dot(rd,sunDir),0.0),7.0);

    vec3 n=vec3(0.0,-1.0,0.0);
    float s=0.0; float trans=1.0; vec3 col=vec3(0.0);
    float layers=cloudLayersAt(c.xz,amount);
    for(int i=0;i<CLOUD_STEPS;i++){
        if(c.y>=CLOUD_LAYERS) break;
        float sNext=min(tMax.x,min(tMax.y,tMax.z));
        if(c.y<layers){
            float a=1.0-exp(-(sNext-s)*0.085);
            float ndl=max(dot(n,sunDir),0.0);
            float sh=cloudSunShadow(c,sunDir,amount);
            vec3 lit=ambient*(0.58+0.42*(n.y*0.5+0.5))
                    +sunC*(ndl*(1.0-sh*0.9)+silver*0.30*(1.0-sh*0.6));
            col+=trans*a*lit;
            trans*=1.0-a;
            if(trans<0.04) break;
        }
        s=sNext;
        bool newCol=false;
        if(tMax.x<=tMax.y&&tMax.x<=tMax.z){ c.x+=stp.x; tMax.x+=tDelta.x; n=vec3(-stp.x,0.0,0.0); newCol=true; }
        else if(tMax.y<=tMax.z){ c.y+=1.0; tMax.y+=tDelta.y; n=vec3(0.0,-1.0,0.0); }
        else { c.z+=stp.z; tMax.z+=tDelta.z; n=vec3(0.0,0.0,-stp.z); newCol=true; }
        if(newCol) layers=cloudLayersAt(c.xz,amount);
    }
    return vec4(col*fade,(1.0-trans)*fade);
#endif
}
