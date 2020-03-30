#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define NUM_STEPS 50
// #define ZOOM_FACTOR 0.2
#define X_OFFSET 0.9
#define Y_OFFSET 0.5

void main(void)
{
	//vec2 uv = gl_FragCoord.xy / resolution.xy;

	float zoomFactor = time * 0.1; // sin(time * 0.1);

	vec2 z;
	float x,y;
	int steps;
	float normalizedX = (gl_FragCoord.x - 320.0) / 640.0 * zoomFactor * (640.0 / 480.0) - X_OFFSET;
  float normalizedY = (gl_FragCoord.y - 240.0) / 480.0 * zoomFactor * (480.0 / 320.0) - Y_OFFSET;
  z.x = normalizedX; z.y = normalizedY;
  for (int i=0;i<NUM_STEPS;i++)
  {
  	steps = i;
  	x = (z.x * z.x - z.y * z.y) + normalizedX;
  	y = (z.y * z.x + z.x * z.y) + normalizedY;
  	if((x * x + y * y) > 4.0)
  	{
  		break;
  	}

  	z.x = x;
  	z.y = y;
  }
  if (steps == NUM_STEPS-1)
  {
  	gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
  }
  else
  {
  	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
  }
}
