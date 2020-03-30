#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/yoshimax/0fcf41ee63688d53ca7ac48121604536

uniform vec2 resolution;
uniform float time;

float circle(vec2 coord, vec2 offs)

{

    float reso = 16.0;

    float cw = resolution.x / reso;


    vec2 p = mod(coord, cw) - cw * 0.5 + offs * cw;


    vec2 p2 = floor(coord / cw) - offs;

    vec2 gr = vec2(0.193, 0.272);

    float tr = time * 2.0;

    float ts = tr + dot(p2, gr);


    float sn = sin(tr), cs = cos(tr);

    p = mat2(cs, -sn, sn, cs) * p;


    float s = cw * (0.3 + 0.3 * sin(ts));

    float d = max(abs(p.x), abs(p.y));


    return max(0.0, 1.0 - abs(s - d));

}



void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float c = 0.0;


    for (int i = 0; i < 9; i++)

    {

        float dx = mod(float(i), 3.0) - 1.0;

        float dy = float(i / 3) - 1.0;

        c += circle(gl_FragCoord.xy, vec2(dx, dy));

    }

    

    gl_FragColor = vec4(vec3(min(1.0, c)), 1);



	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
