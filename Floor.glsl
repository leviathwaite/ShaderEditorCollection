#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

vec3 red = vec3(1.0, 0.0, 0.0);


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	// uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

	// uv *= fract(2.0);

	vec3 col = vec3(0.0);

	vec2 gv = uv;
	float mag = 10.0;

  gv.x = abs(floor(uv.y * mag)); // / mag;
	gv.y = floor(uv.x * mag); // / mag;

	col.rg += gv.xy;

	gl_FragColor = vec4(col, 1.0);
}
