#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

const float numberOfIterations = 480.0;
float zoom = 2.0;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
  uv.y *= resolution.y / resolution.x;

  uv *= 2.5;
  uv.x -= 1.9;
	uv.y -= 2.25;

	// the more it zooms in the slower it goes
	zoom += time;
	// uv /= zoom;
	zoom *= 0.5;

	vec4 col; // = vec4(0.0);
	float x = 0.0;

	for(float i = 0.0; i < numberOfIterations; i++)
	{
		x = i;

    float sqrX = col.r * col.r;
    float sqrY = col.g * col.g;

		if(sqrX + sqrY > 4.0)
		{
      break;
		}

		float tmp = (sqrX - sqrY) + uv.x;
    col.g = 2.0 * col.r * col.g + uv.y;
    col.r = tmp;
	}

	col.x = (0.5 + (0.5 * sin(
		  (x * 0.11))));
		col.y = (0.5 + (0.5 * cos(
		  (x * 0.077))));
		col.z = (0.5 + (0.5 * sin(
			(x * 0.027))));


	// col.x = x;

	gl_FragColor = vec4(col.rgb, 1.0);
}
