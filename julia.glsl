#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gitlab.com/wraithan/shader-playground/blob/master/src/shaders/julia_001.glslf

uniform vec2 resolution;
uniform float time;

const float GOLDEN_RATIO = 1.61803398875;

void main(void) {
	// vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 uv = vec2(gl_FragCoord.xy/resolution) - 0.5;
	float lowerRes = min(resolution.x, resolution.y);

	if (resolution.x == lowerRes)
	{
		uv.y *= resolution.y / resolution.x;
	}
	else
	{
		uv.x *= resolution.x / resolution.y;
	}

	uv *= pow(2.0, -(time / 5.0)) * 4.;
	vec2 c = vec2(-GOLDEN_RATIO / 2.0, 0.3);
	uv.x += 0.6025;
	uv.y += -0.0803;
	vec2 z = vec2(uv);
	float lastStep = 0.0;
	float limit = 2000.0;
	vec2 biggest = vec2(0.0, 0.0);

	for (float i = 0.0; i < limit; i++)
	{
		vec2 nz = vec2( (z.x * z.x) - (z.y * z.y) + c.x, (z.x * z.y) * 2.0 + c.y );
		if (z.x * z.y < 4.0)
		{
			lastStep = i;
		}
		else
		{
			break;
		}

		z = nz;
	}

	vec3 col = vec3(0.0);
	if (lastStep == limit - 1.0)
	{
		col.rgb = vec3(0.3, 0.5, 0.9);
	}
	else
	{
		col.b = 1.0 - abs(float(mod(lastStep, 32.0)) / 16.0);
	}

	gl_FragColor = vec4(col, 1.0);


	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
