#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main(void) {
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	uv.y *= resolution.y / resolution.x;
	uv *= 1.0;

  vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;


  float cossin1 = cos(p.x * 5.0 + time) + sin(p.y * 7.0 - time) + sin(time);
  float cossin2 = cos(p.y * 3.0 + time) + sin(p.x * 9.0 - time) - cos(time);
  float cossin3 = cos(p.x * 11.0 + time) + 0.5 * sin(p.y * 3.0 + time) + cos(time);

	gl_FragColor = vec4(cossin1 * sin(p.x), cossin2 * sin(p.y), cossin3 * sin(p.x), 1.0);
}
