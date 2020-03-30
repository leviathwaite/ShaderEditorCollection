#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


#define X_OFFSET 0.9
#define Y_OFFSET 0.5

uniform vec2 Center;
uniform float time;

float Zoom = 0.0;
float NumSteps = 10.0;

// float zoomFactor = sin(time * 0.1);

vec2 coordPosition = vec2(0.0, 0.0);
vec4 fragmentColor = vec4(1.0);

void main(void)
{
	// moves x, should zoom in...
	Zoom = sin(time * 0.1);


	coordPosition.x = (gl_FragCoord.x - 320.0) / 640.0 * Zoom * (640.0 / 480.0) - X_OFFSET;
  coordPosition.y = (gl_FragCoord.y - 240.0) / 480.0 * Zoom * (480.0 / 320.0) - Y_OFFSET;
  // z.x = normalizedX; z.y = normalizedY;

	vec2 z, c;
	c.x = 1.3333 * (-0.5 - coordPosition.x / Zoom) - Center.x;
	c.y = (coordPosition.y / Zoom) + Center.y;
	float i;
	z = c;

	for (i = 0.0; i<NumSteps; i++)
	{
		float x = (z.x * z.x - z.y * z.y) + c.x;
		float y = (z.y * z.x + z.x * z.y) + c.y;

		if((x * x + y * y) > 4.0) break;
		z.x = x; z.y = y;

	}

	if (i <= NumSteps)
	{
		float color = i / NumSteps;
		gl_FragColor = vec4(color, color, 1.0, 1.0);
	}
	else
	{
		gl_FragColor = vec4(NumSteps, 1.0, 1.0, 1.0);
	}
}