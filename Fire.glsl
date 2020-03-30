#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/rasteron/097ff90e009542c58950

uniform vec2 resolution;
uniform float time;

float shift = 1.0;

vec2 cSpeed = vec2(0.5);


float rand(vec2 n) {

    return fract(cos(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);

}


float noise(vec2 n) {

    const vec2 d = vec2(0.0, 1.0);

    vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));

    return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);

}


float fbm(vec2 n) {

    float total = 0.0, amplitude = 1.0;

    for (int i = 0; i < 4; i++) {

        total += noise(n) * amplitude;

        n += n;

        amplitude *= 0.5;

    }

    return total;

}



void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;


	float cElapsedTime = time;

	const vec3 c1 = vec3(12.0/255.0, 10.0/212.0, 71.0/255.0);

    const vec3 c2 = vec3(218.0/255.0, 220.0/255.0, 11.4/755.0);

    const vec3 c3 = vec3(0.2, 0.0, 0.0);

    const vec3 c4 = vec3(162.0/255.0, 1.0/255.0, 4.4/955.0);

    const vec3 c5 = vec3(3.1);

    const vec3 c6 = vec3(1.151);


    vec2 p = gl_FragCoord.xy * 8.0 / resolution.xx;

    float q = fbm(p - cElapsedTime * 0.1);

    vec2 r = vec2(fbm(p + q + cElapsedTime * cSpeed.x - p.x - p.y), fbm(p + q - cElapsedTime * cSpeed.y));

    vec3 c = mix(c1, c2, fbm(p + r)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);

    float grad = gl_FragCoord.y / resolution.y;

    gl_FragColor = vec4(c * cos(shift * gl_FragCoord.y / resolution.y), 1.0);

    gl_FragColor.xyz *= 1.0-grad;



	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
