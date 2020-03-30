#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/radif/MorphFragmentShaders/blob/master/morph/shaders/bend.fsh

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

const float speed = 1.0; // frequency
const float bendFactor = 1.0; // magnitude

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float height = 1.0 - uv.y;
	float offset = pow(height, 2.5);
	offset *= (sin(time * speed) * bendFactor);
	gl_FragColor = texture2D(Girls, fract(vec2(uv.x + offset, uv.y))).rgba;
}

