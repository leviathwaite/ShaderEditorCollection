#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D pointMap;

vec3 cirCol = vec3(1.0, 1.0, 0.0);
const float redThreshold = .25;
const vec3 white = vec3(0.8);

float Circle(vec2 pos, float radius)
{
	return length(pos) - radius;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = uv;

	uv.x *= resolution.x / resolution.y;

  uv.x -= 0.25;
  uv.y -= 0.5;

	vec3 col = vec3(0.0);

	col = texture2D(pointMap, st).rgb;

	// real pixel size
  // vec2 offset = (floor(uv * resolution) / gl_FragCoord.x);// mx;

  int range = 1;
  float balance = 0.0;

  for (int x = -range; x <= range; x++)
	{
		for (int y = -range; y <= range; y++)
		{
			// sum += texture2D(Girls, uv + vec2(x, y)*sizeFactor);

		  // if colors are close
		  if(col.r > redThreshold)
		  balance = 1.0;
		}
	}


	float colAvg =  (col.r + col.g + col.b) / 3.0;

	float circle = Circle(uv, 0.001);
	float cirSmooth = 0.01;
	circle = smoothstep(cirSmooth, cirSmooth, circle);
	col = mix(cirCol, col, circle);

	col = mix(col, cirCol, balance);

	// col = cirCol;

	gl_FragColor = vec4(col, 1.0);
}
