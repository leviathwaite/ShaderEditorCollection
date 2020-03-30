#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 r = vec2(1.0);

	float y = (gl_FragCoord.xy / resolution.x + 1.0).y;
	float t = time * 1.0; // 3.0
	float s;

	vec4 c = vec4(0.0);
	c.b += cos(y * 4.0 - 5.0); // 4.0 - 5.0

	// number of bars
	for(float k = 0.0; k < 18.0; k += 1.0)
	{
		// offset, range/magnitude of movement on y
		s = (sin(t + k / 7.0)) / 2.0 + 2.0; // 3.4)) / 0.6 + 1.25
		if(y > s && y < s + .05)
		{
			c = vec4(s, sin(y + t * .3), k / 18.0, 1.0) *
				(y - s) * sin((y - s) * 20.0 * 3.14) * 38.0;
	    // c = vec4(uv.x, 1.0 - uv.y, cos(uv.x), 1.0);
		}
	}

  gl_FragColor = c;
	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
