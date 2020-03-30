#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.shadertoy.com/view/3lBSzW 


 


const float PI = 3.14159;
const float PI2 = PI*2.;

vec3 dtoa(float d, vec3 amount){
    return vec3(1. / clamp(d*amount, vec3(1), amount));
}
mat2 rot2D(float r){
    return mat2(cos(r), sin(r), -sin(r), cos(r));
}
vec3 hash32(vec2 p) {
vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
    p3 += dot(p3, p3.yxz+19.19);
    return fract((p3.xxy+p3.yzz)*p3.zyx);
}
float opUnion( float d1, float d2 ) { return min(d1,d2); }

float sdSquare(vec2 p, vec2 center, float s) {
vec2 d = abs(p-center) - s;
return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

const float th = 1./3.;
float hello(float sd, vec2 uv, float off, float a, vec2 sgn) {
    sd = opUnion(sd, sdSquare((uv + sgn*vec2(.5,.5)+vec2(-off,0)) * rot2D(a), vec2(-th*.5), th*.5));
    sd = opUnion(sd, sdSquare((uv + sgn*vec2(-.5,.5)+vec2(0,-off)) * rot2D(a+PI*.5), vec2(-th*.5), th*.5));
    sd = opUnion(sd, sdSquare((uv + sgn*vec2(.5,-.5)+vec2(0,off)) * rot2D(a-PI*.5), vec2(-th*.5), th*.5));
    sd = opUnion(sd, sdSquare((uv + sgn*vec2(-.5,-.5)+vec2(off,0)) * rot2D(a-PI), vec2(-th*.5), th*.5));
    return sd;
}

float scurve(float x, float p) {
    x = x / p * PI2;
    return (x + sin(x+PI)) / PI2;
}


uniform vec2 resolution;
uniform float time;

void main(void) {
	// vec2 uv = gl_FragCoord.xy / resolution.xy;


    vec2 uv = gl_FragCoord.xy / resolution.xy-.5;
    uv.x *= resolution.x / resolution.y;
   
    uv *= 4.0;
    float tsteady = time*.3;
    float t = -scurve(tsteady, th);
   
    float seg = mod(t, 3.);
    float aout = fract(seg)*PI*.5;
    float ain = -(aout+PI*.5);
    float offout = 0.;
    float offin = th*2.;
    if (seg >= 2.) {
aout = (fract(seg)-.5)*PI;
        ain = PI;
    } else if (seg >= 1.) {
        offout = th*2.;
    } else {
        offout = th;
        offin = th;
    }

    float sd = 1e6;
    float sdout = 1e6;
    sd = sdSquare(uv, vec2(0),.5); // base sq
   
    sdout = hello(sdout, uv, offout, aout, vec2(1)); // inner sq
    sdout = hello(sdout, uv, offin, ain, vec2(1));

    vec4 o = vec4(0.0);
    o.rgb = .8-dtoa(sd, 50.*vec3(50.,100.,200.)) * vec3(.3,.6,.3);
    vec3 alout = dtoa(sdout, 2.*vec3(40.,200.,40.));
    o.rgb = mix(o.rgb, vec3(.2,.7,.5), alout);
   
    o = clamp(o,o-o,o-o+1.);
   
    vec2 N = gl_FragCoord.xy / resolution.xy-.5;
    o = pow(o,o-o+.7);
    o *= 1.-dot(N,N);
    o.a = 1.;

    gl_FragColor = o;
}