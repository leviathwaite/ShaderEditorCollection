#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/genekogan/Processing-Shader-Examples/blob/master/TextureShaders/data/threshold.glsl

uniform vec2 resolution;
uniform sampler2D Girls;

float threshold = 0.5;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec3 col = texture2D(Girls, uv).rgb;
	float bright = 0.33333 * (col.r + col.g + col.b);
	float b = mix(0.0, 1.0, step(threshold, bright));
	gl_FragColor = vec4(vec3(b), 1.0);
}
