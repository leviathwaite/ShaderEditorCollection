#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

float wave(float x, float amount)
{
	// sin return -1 to 1, adding 1 shifts to 0 to 2, * 0.5 0 to 1
	return (sin(x * amount) + 1.0) * 0.5;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 color = texture2D(Girls, uv);
	// normal
	// color.r = wave(color.r, 10.0);
	// color.g = wave(color.g, 20.0);
	// color.b = wave(color.b, 40.0);
	// color.a = 1.0;
	// gl_FragColor = color;

	// tint red
	// color.g = 0.0;
	// color.b = 0.0;
	// color.a = 1.0;
		// gl_FragColor = color;

	// invert blue
	gl_FragColor = vec4(color.r, color.g, 1.0 - color.b, 1.0);


	// invert colors
	// gl_FragColor = vec4(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, 1.0);


	// easy grey scale
	float avg = color.r + color.g + color.b;
	// gl_FragColor = vec4(vec3(avg), 1.0);

	// grey scale with scaling
	avg = 0.21 * color.r + 0.71 * color.g + 0.07 * color.b;
	// gl_FragColor = vec4(vec3(avg), 1.0);



}
