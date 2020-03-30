#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float triangle(vec2 p)
{
	p.x *= 1.0; // Controls the width
	p.x = abs(p.x); // makes it simetrical
	p.y += 0.5; // moves y location/height
	return max(3.0 * p.x + p.y, 1.0 - 1.5 * p.y);
}

void main(void) {
	vec2 p = (2.0 * gl_FragCoord.xy - resolution) / resolution.y;
  float d = triangle(p);
  vec3 col = vec3(smoothstep(1.01, 1.0, d));

  gl_FragColor = vec4(col, 1.0);

}
