#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159265359

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 rotate2d(float _angle)
{
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float triangle(vec2 p)
{
	p.x *= 1.0; // Controls the width
	p.x = abs(p.x); // makes it simetrical
	p.y += 0.5; // moves y location/height
	return max(3.0 * p.x + p.y, 1.0 - 1.5 * p.y);
}

void main(void) {
	vec2 p = (2.0 * gl_FragCoord.xy - resolution) / resolution.y;

  float angle = mod(atan(p.y, p.x), 0.01);
  angle += 0.0;
  float radius = 0.25;
  p += vec2(radius * cos(angle), radius * sin(angle));

  // move space from the center to the vec2(0.0)
  // p -= vec2(0.5);
  // rotate the space
  // st = rotate2d( sin(u_time)*PI ) * st;
  // p = rotate2d(45.0) * p;
  p = rotate2d(angle) * p;
  // move it back to the original place
  // p += vec2(0.5);

  float d = triangle(vec2(p.x * 2.5, p.y * 3.0));
  vec3 col = vec3(smoothstep(1.01, 1.0, d));

  gl_FragColor = vec4(col, 1.0);

}
