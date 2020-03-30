#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 time;

vec2 rotate(vec2 samplePosition, float rotation)
{
	const float PI = 3.14159;
	float angle = rotation * PI * 2.0 * -1.0;
	float sine, cosine;
	// sincos(angle, sine, cosine);
	return vec2(cosine * samplePosition.x + sine * samplePosition.y, cosine * samplePosition.y - sine * samplePosition.x);
	}

	vec2 translate(vec2 samplePosition, vec2 offset)
	{
		//move samplepoint in the opposite direction that we want to move shapes in
		return samplePosition - offset;
  }

	vec2 scale(vec2 samplePosition, float scale)
	{
		return samplePosition / scale;
	}

	float circle(vec2 samplePosition, float radius)
	{
		//get distance from center and grow it according to radius
		return length(samplePosition) - radius;
	}

	float rectangle(vec2 samplePosition, vec2 halfSize)
	{
		vec2 componentWiseEdgeDistance = abs(samplePosition) - halfSize;
		float outsideDistance = length(max(componentWiseEdgeDistance, 0.0));
		float insideDistance = min(max(componentWiseEdgeDistance.x, componentWiseEdgeDistance.y), 0.0);
		return outsideDistance + insideDistance;
	}

float scene(vec2 position)
{
	 vec2 circlePosition = position;
	 circlePosition = rotate(circlePosition, time.y * 0.5);
	 circlePosition = translate(circlePosition, vec2(2, 0));
	 float sceneDistance = rectangle(circlePosition, vec2(1, 2));
	 return sceneDistance;
	 }

void main(void) {

	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;

	float dist = scene(uv * 10.0);
	vec4 col = vec4(dist, dist, dist, 1.0);

	// vec2 uv = gl_FragCoord.xy / resolution.xy;
	// uv *= -0.5;



	gl_FragColor = vec4(col);
}
