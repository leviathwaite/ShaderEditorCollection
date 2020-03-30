#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 iMouse;

#define NUM_LAYERS 6.

mat2 Rot(float a) {
    float s=sin(a), c=cos(a);
    return mat2(c, -s, s, c);
}

float Star(vec2 uv, float flare) {
	float d = length(uv);
    float m = .05/d;

    float rays = max(0., 1.-abs(uv.x*uv.y*1000.));
    m += rays*flare;
    uv *= Rot(3.1415/4.);
    rays = max(0., 1.-abs(uv.x*uv.y*1000.));
    m += rays*.3*flare;

    m *= smoothstep(1., .2, d);
    return m;
}

float Hash21(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

vec3 StarLayer(vec2 uv) {
	vec3 col = vec3(0);

    vec2 gv = fract(uv)-.5;
    vec2 id = floor(uv);

    for(int y=-1;y<=1;y++) {
    	for(int x=-1;x<=1;x++) {
            vec2 offs = vec2(x, y);

    		float n = Hash21(id+offs); // random between 0 and 1
            float size = fract(n*345.32);

    		float star = Star(gv-offs-vec2(n, fract(n*34.))+.5, smoothstep(.9, 1., size)*.6);

            vec3 color = sin(vec3(.2, .3, .9)*fract(n*2345.2)*123.2)*.5+.5;
            color = color*vec3(1,.25,1.+size)+vec3(.2, .2, .1)*2.;

            star *= sin(time*3.+n*6.2831)*.5+1.;
            col += star*size*color;
        }
    }
    return col;
  }

void main(void) {
	float mx = max(resolution.x, resolution.y);
	  vec2 uv = gl_FragCoord.xy / mx;
	  // st.x += 0.25;



	// vec2 uv = (gl_FragCoord-.5*resolution.xy)/resolution.y;
	vec2 M = (iMouse.xy-resolution.xy*.5)/resolution.y;

    float t = time*.02;

    uv += M*4.;

    uv *= Rot(t);
    vec3 col = vec3(0);

    for(float i=0.; i<1.; i+=1./NUM_LAYERS) {
    	float depth = fract(i+t);

        float scale = mix(20., .5, depth);
        float fade = depth*smoothstep(1., .9, depth);
        col += StarLayer(uv*scale+i*453.2-M)*fade;
    }

    gl_FragColor = vec4(col,1.0);
}
