#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main(void) {

	vec2 u = gl_FragCoord.xy / resolution.y-.5;
	gl_FragColor = abs(.1 / (u.y/.1 + sin(u.x/.1+vec4(0,.1,.2,0) + time)));
}
