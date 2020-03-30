#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// http://glslsandbox.com/e#59709.0

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float vv = uv.y * uv.y;
	vv += sin(time + vv * 3.14);
	float v = sin(sin(uv.x * 2.0) * 4.0 + (vv) * 20.0 + time * 2.0);
	v = 0.1 / 1.0 - v;

	gl_FragColor = vec4(v * 1.25, 0.02 + 0.5 * v, v, 1.0);
}
