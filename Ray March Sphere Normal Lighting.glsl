#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// http://www.michaelwalczyk.com/blog/2017/5/25/ray-marching

uniform vec2 resolution;
uniform float time;

float distance_from_sphere(vec3 p, vec3 c, float r)
{
	return length(p - c) - r;
}

// normal
float map_the_world1(vec3 p)
{
	float sphere_0 = distance_from_sphere(p, vec3(0.0), 1.0);
	return sphere_0;
}

// distort
float map_the_world(in vec3 p)
{
	float displacement = sin(5.0 * p.x) * sin(5.0 * p.y) * sin(5.0 * p.z) * 0.25 * sin(time * 2.0);
	float sphere_0 = distance_from_sphere(p, vec3(0.0), 1.0);
	return sphere_0 + displacement;
}

vec3 calculate_normal(in vec3 p)
{
	const vec3 small_step = vec3(0.001, 0.0, 0.0);
	float gradient_x = map_the_world(p +
		small_step.xyy) - map_the_world(p -
			small_step.xyy);
	float gradient_y = map_the_world(p +
		small_step.yxy) - map_the_world(p -
			small_step.yxy);
	float gradient_z = map_the_world(p +
		small_step.yyx) - map_the_world(p -
			small_step.yyx);

	vec3 normal = vec3(gradient_x, gradient_y, gradient_z);
	return normalize(normal);
}

vec3 ray_march(vec3 ro, vec3 rd)
{
	float total_distance_traveled = 0.0;
	const int NUMBER_OF_STEPS = 32;
	const float MINIMUM_HIT_DISTANCE = 0.001;
	const float MAXIMUM_TRACE_DISTANCE = 1000.0;

	for (int i = 0; i < NUMBER_OF_STEPS; ++i)
	{
		vec3 current_position = ro + total_distance_traveled * rd;
		float distance_to_closest = map_the_world(current_position);

		if (distance_to_closest < MINIMUM_HIT_DISTANCE)
		{
			vec3 normal = calculate_normal(current_position);
			vec3 light_position = vec3(2.0, -5.0, 3.0);
			vec3 direction_to_light = normalize(current_position - light_position);
			float diffuse_intensity = max(0.0, dot(normal, direction_to_light));
			return vec3(1.0, 0.0, 0.0) * diffuse_intensity;
		}

		if (total_distance_traveled > MAXIMUM_TRACE_DISTANCE)
		{
			break;
		}

		total_distance_traveled += distance_to_closest;
	}

	return vec3(0.0);
}



void main()
{
	// vec2 uv = vUV.st * 2.0 - 1.0;
  vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;


	vec3 camera_position = vec3(0.0, 0.0, -5.0);
	vec3 ro = camera_position;
	vec3 rd = vec3(uv, 1.0);
	vec3 shaded_color = ray_march(ro, rd);
	gl_FragColor = vec4(shaded_color, 1.0);
}

