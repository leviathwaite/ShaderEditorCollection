#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/rasteron/24f972cffd95fdeca1c1

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;


const float cGamma = 0.3;

float cNumColors = 32.0;

// vScreenPos = uv

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	cNumColors = 48.0 * ((sin(time * 0.25) + 1.0) * 0.5);

	vec3 c = texture2D(Girls, uv.xy).rgb;

  c = pow(c, vec3(cGamma, cGamma, cGamma));

  c = c * cNumColors;

  c = floor(c);

  c = c / cNumColors;

  c = pow(c, vec3(1.0/cGamma));

  gl_FragColor = vec4(c, 1.0);



	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
