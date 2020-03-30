#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define speed 0.01
uniform sampler2D Antoniofly;
uniform sampler2D Girls;

vec4 getToColor(vec2 pos)
{
	return texture2D(Antoniofly, pos);
}

vec4 getFromColor(vec2 pos)
{
	return texture2D(Girls, pos);
}

vec4 transition(vec2 uv, float progress)
{
  vec2 p = uv.xy / vec2(1.0).xy;
  float circPos = atan(p.y - 0.5, p.x - 0.5) + progress * speed;
  float modPos = mod(circPos, 3.1415 / 40.);
  float signed = sign(progress - modPos);
  return mix(getToColor(p), getFromColor(p), step(signed, 0.5));
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	gl_FragColor = vec4(transition(uv, sin(time * 0.3)));
}
