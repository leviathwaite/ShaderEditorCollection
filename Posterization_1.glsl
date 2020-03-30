#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// Posterization.glsl

// https://gist.github.com/rasteron/24f972cffd95fdeca1c1

uniform vec2 resolution;
uniform sampler2D Girls;

float cGamma = 0.5;
float cNumColors = 8.0;


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;


vec3 c = texture2D(Girls, uv).rgb;

  c = pow(c, vec3(cGamma, cGamma, cGamma));

  c = c * cNumColors;

  c = floor(c);

  c = c / cNumColors;

  c = pow(c, vec3(1.0/cGamma));

  gl_FragColor = vec4(c, 1.0);

}
