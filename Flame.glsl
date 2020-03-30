#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform sampler2D noise;
uniform sampler2D VoroniDistortion;

float Remap01(float a, float b, float t)
{
  return (t - a) / (b - a);
}

float Remap(float a, float b, float c, float d, float t)
{
// normalize value t
  return Remap01(a, b, t) * (d - c) + c;
}

float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float motion = time * 0.1;
	float motion2 = motion * 0.5;

	vec2 noiseMotion = vec2(sin(uv.x) , uv.y - motion ); // - (time * 1.0));
	vec4 dist = texture2D(VoroniDistortion, noiseMotion);
	dist *= 0.1;

	vec4 col = texture2D(noise, vec2(uv.x - dist.g, uv.y - dist.r - motion2));
  col *= vec4(1.0, 1.0, 0.0, 1.0) * (1.0 - uv.y);

  float gradient = 1.0 - (sin((uv.y * 5.0) - 3.0));
  vec4 grad = vec4(vec3(gradient), 1.0);
  vec4 topFlameCol = vec4(1.0, 1.0, 0.0, 1.0);
  vec4 flameCol = vec4(1.0, 0.0, 0.0, 1.0);
  flameCol *= grad;
  grad *= flameCol;
  grad *= topFlameCol * (uv.y * 4.5);
  grad *= 0.25;

  float blur = 0.01;
  // gradual(linear) blur
  blur = Remap(-0.5, 0.5, 0.01, 0.25, uv.y);
  blur = pow(blur * 2.0, 3.0); // 4.0, 3.0

  vec2 circlePos = vec2(uv.x -0.5, uv.y - 0.5);
  float c = 1.0 - Circle(circlePos, 0.2, blur);

  // vec4 color = grad * col;
  vec4 color = mix(grad, col, uv.y);

  vec4 circle = vec4(c);

  gl_FragColor = grad;

	gl_FragColor = vec4(color * circle);
}
