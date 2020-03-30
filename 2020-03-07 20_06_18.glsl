#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

float sdSquare(vec2 p, vec2 center, float s) {
vec2 d = abs(p-center) - s;
return min(max(d.x, d.y), 0.0) + length(max(d, 0.0));
}

// changes the size
float roundedSdSquare(vec2 p, vec2 center, float s)
{
	return sdSquare(p, center, s) - s * 0.25;
}

void main(void) {
  vec2 uv = gl_FragCoord.xy / resolution.xy-.5;
  uv.x *= resolution.x / resolution.y;

  uv *= 20.0;

	vec3 col = vec3(0.0);

	vec2 pos = vec2(-4.0, 0.0);

	float scaledTime = time * 0.1;


  float numSq = 9.0;
  for (float i = 0.0; i < numSq; i++)
	{
	  float sd = roundedSdSquare(uv, pos, 0.25);
	  sd = smoothstep(0.01, 0.02, abs(sd));
	  vec3 sqCol = vec3(1.0, 1.0, 0.0);
	  col = mix(sqCol, col, sd);

	  pos.x += 1.0;
	  pos.y = sin(scaledTime) * pos.x;
	}

	gl_FragColor = vec4(col, 1.0);
}
