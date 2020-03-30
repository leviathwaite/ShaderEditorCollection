#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/yoshimax/8f3edadd359491b2ef342b9aea04a8cc

uniform vec2 resolution;
uniform float time;


float circle(vec2 coord, vec2 seed)

{

    float reso = 16.0;

    float cw = resolution.x / reso;


    vec2 p = mod(coord, cw);

    float d = distance(p, vec2(cw / 2.0));


    float rnd = dot(floor(coord / cw), seed);

    float t = time * 2.0 + fract(sin(rnd)) * 6.2;


    float l = cw * (sin(t) * 0.25 + 0.25);

    return clamp(l - d, 0.0, 1.0);

}


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 p = gl_FragCoord.xy;

    vec2 dp = vec2(7.9438, 0.3335) * time;

    float c1 = circle(p - dp, vec2(323.443, 412.312));

    float c2 = circle(p + dp, vec2(878.465, 499.173));

    float c = max(0.0, c1 - c2);

    gl_FragColor = vec4(c, c, c, 1);



	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
