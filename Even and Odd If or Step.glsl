#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

vec3 evenCol = vec3(1.0, 1.0, 0.0);
vec3 oddCol = vec3(0.0, 1.0, 1.0);

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv *= 100.0;

	vec3 col = oddCol;

	// how to do this without if

	float s = step(1.0, mod(uv.y, 2.0));
	col = mix(evenCol, oddCol, s);

	/*
	if(mod(uv.y, 2.0) < 1.0)
	{
		col = evenCol;
	}
	*/

	gl_FragColor = vec4(col, 1.0);
}
