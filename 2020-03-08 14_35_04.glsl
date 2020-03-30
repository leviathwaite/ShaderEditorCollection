#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.x *= resolution.x / resolution.y;



	float red = 1.0;
	float green = 1.0;
	float blue = 0.0;

	vec3 col = vec3(red, green, blue);

	vec3 cirCol = vec3(0.0);
	float d = length(uv) - 0.1;
	d = smoothstep(0.01, 0.015, d);

	col = mix(cirCol, col, d);

	gl_FragColor = vec4(col, 1.0);
}
