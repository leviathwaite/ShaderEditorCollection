#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

vec3 checkerV3(in float u, in float v, in float checkSize)
{
	float fmodResult = mod(floor(checkSize * u) + floor(checkSize * v), 2.0);
	float fin = max(sign(fmodResult), 0.0);
	return vec3(fin, fin, fin);
}

float checkerF(vec2 pos)
{
	bool toggle1 = mod(pos.x,0.1)>0.05;
  bool toggle2 = mod(pos.y,0.1)>0.05;

  // bool toggle1 = mod(radius1,0.1)>0.05;
  // bool toggle2 = mod(radius2,0.1)>0.05;

  // xor via if statements
  float col = 0.0;
  if (toggle1) col = 1.0;
  if (toggle2) col = 1.0;
  if ((toggle1) && (toggle2)) col = 0.0;

  return col;
}

void main() {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

  vec3 color = vec3(0.0);

  color = checkerV3(uv.x, uv.y, 2.0);

  // float c = checkerF(uv);
  // color = vec3(c);

	gl_FragColor = vec4(color, 1.0);
}
