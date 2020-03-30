#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D CloudNoise;
uniform float time;
uniform sampler2D Displacement;

const vec4 v_color = vec4(0.1, 0.55, 0.9, 1.0);


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 displacement = texture2D(CloudNoise, uv * 0.08).xy;
	float t = uv.y + displacement.y * 0.1 - 0.07 + (sin(uv.x * 10.0 + time*6.0) * 0.005);
	gl_FragColor = v_color * texture2D(Displacement, vec2(uv.x, t));

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
