#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float EPSILON = 0.0001;
const vec4 missedColor = vec4(0.0, 0.0, 0.0, 1.0);
const vec4 hitColor = vec4(1.0);
const float fieldOfView = 45.0;

float SphereSDF(vec3 samplePoint)
{
	return length(samplePoint) - 1.0;
}

float SceneSDF(vec3 samplePoint)
{
	return SphereSDF(samplePoint);
}

float ShortestDistanceToSurface(vec3 eye, vec3 marchingDirection, float start, float end)
{
	float depth = start;
	for(int i = 0; i < MAX_MARCHING_STEPS; i++)
	{
		float dist = SceneSDF(eye + depth * marchingDirection);
		if(dist < EPSILON)
		{
		  return depth;
		}
		depth += dist;
		if(depth > end)
		{
			return end;
		}
	}
	return end;
}

vec3 RayDirection(float fieldOfView, vec2 size, vec2 fragCoord)
{
	vec2 xy = fragCoord - size / 2.0;
	// modify for zoom
	float z = size.y / tan(radians(fieldOfView) / 1.0);
	return normalize(vec3(xy, -z));
}

void main()
{
    vec3 dir = RayDirection(fieldOfView, resolution.xy, gl_FragCoord.xy);
    // modify z for zoom/field of view
    vec3 eye = vec3(0.0, 0.0, 5.0);
    float dist = ShortestDistanceToSurface(eye, dir, MIN_DIST, MAX_DIST);

    if (dist > MAX_DIST - EPSILON) {
        // Didn't hit anything
        gl_FragColor = missedColor;
		return;
    }

    gl_FragColor = hitColor;
}

