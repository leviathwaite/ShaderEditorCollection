#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159265359

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D Rick;


void main(void) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv *= 0.5;


	vec2 pos = uv;
	pos *= 10.0;
	float a = atan(pos.y, pos.x);
	float r = length(pos);

	float h = (1.0 - sin(mod(a * 3.0, 3.14)) * 0.5);


	h = 1.0 - smoothstep(h, h + 0.02, r);


  gl_FragColor = vec4(vec3(h), 1.0);

  // gl_FragColor = vec4(col, 1.0);

}
