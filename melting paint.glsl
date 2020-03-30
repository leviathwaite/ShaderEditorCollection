#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// doom melt effect

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float t = (sin(time * 0.2) * 0.5 + 0.5) * 10.0;

	uv.y += 0.1 * t * fract(sin(dot(vec2(uv.x), vec2(12.9, 78.2))) * 437.5);

	gl_FragColor = vec4(texture2D(Girls, uv));
}
