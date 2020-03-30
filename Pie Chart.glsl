#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;
vec4 _Color = vec4(1.0, 0.0, 0.0, 1.0);

/*
vec4 transition(vec2 uv, float progress)
{
  vec2 p = uv.xy / vec2(1.0).xy;
  float circPos = atan(p.y - 0.5, p.x - 0.5) + progress * speed;
  float modPos = mod(circPos, 3.1415 / 40.);
  float signed = sign(progress - modPos);
  return mix(getToColor(p), getFromColor(p), step(signed, 0.5));
}
*/

float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

void main(void) {

  float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	vec2 center = resolution / mx * 0.5;
	uv.x -= 0.25;
	uv.y -= 0.5;

	float c = Circle(uv, 0.2, 0.01);

	uv.x -= 0.35;
	uv.y += 0.7;


	vec4 col = texture2D(Girls, uv);

  float progress = 0.5;
  float circPos = atan(uv.y - 0.5, uv.x - 0.5) + progress;

  vec3 mask = vec3(c * circPos);
  col.r = max(col.r, mask.r);
  col.g = max(col.g, mask.g);
  col.b = max(col.b, mask.b);



	gl_FragColor = vec4(col);
}
