#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// simple version
// shadertoy.com/view/XdlfWj

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  uv.x *= sin(time) * 0.5 + 0.5;
  uv.y *= cos(time) * 0.5 + 0.5;

	gl_FragColor = 1. - texture2D(Girls, uv).wyyw;
}
