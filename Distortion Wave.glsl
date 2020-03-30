#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/radif/MorphFragmentShaders/blob/master/morph/shaders/worry.fsh

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

const float timeAcceleration = 3.0;
const float waveRadius = 0.01;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float stepVal = (time * timeAcceleration) + uv.x*61.8;
	float offset=cos(stepVal)*waveRadius;
	gl_FragColor = texture2D(Girls, fract(vec2(uv.x, uv.y+offset))).rgba;

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
