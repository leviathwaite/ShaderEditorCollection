#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	uv.y *= resolution.y / resolution.x;

	float d = smoothstep(0.1, 1.0,
		length(uv - vec2(0.5, 1.0))) * 4.0 + log(uv.y / 20.0 + 0.5);

  float a = exp(uv.x * 0.005) + fract(32.0 * uv.y) / d;

  float t1 = time * 1.0;
  float t2 = time * 2.0;
  float t3 = time * 3.0;

	gl_FragColor = vec4(
		(uv.y * a) * abs(sin(4.0 * uv.y + t1)),
		(uv.y * a) * abs(sin(4.0 * uv.y + t2)),
		(uv.y * a) * abs(sin(4.0 * uv.y + t3)),
		1.0);
}
