#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float w = 0.5; // gradient band width
  float mr = 0.0; // gradient middle, 0% red
  float mg = 0.5; // 50% green
  float mb = 1.0; // 100% blue

  float z = sin(time * 0.1) * 0.5 + 0.5;

  float rr = (z - mr) / w; // intermediate step
  float r = clamp(1.0 - (rr * rr), 0.0, 1.0);
  float gg = (z - mg) / w; // intermediate step
  float g = clamp(1.0 - (gg * gg), 0.0, 1.0);
  float bb = (z - mb) / w; // intermediate step
  float b = clamp(1.0 - (bb * bb), 0.0, 1.0);
  gl_FragColor = vec4(r, g, b, 1.0);


	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
