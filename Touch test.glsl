#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform int pointerCount;
uniform vec3 pointers[10];
uniform vec2 resolution;
uniform float time;

vec3 red = vec3(1.0, 0.0, 0.0);
vec3 green = vec3(0.0, 1.0, 0.0);
vec3 blue = vec3(0.0, 0.0, 1.0);
vec3 cyan = vec3(0.0, 1.0, 1.0);
vec3 magenta = vec3(1.0, 0.0, 1.0);
vec3 yellow = vec3(1.0, 1.0, 0.0);


vec3 Ripples(vec2 uv, vec2 pos)
{
	return vec3(sin(time - distance(uv, pos) * 90.0)); // 255.0
}

void main(void) {
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	vec3 color = vec3(0.0);

	float t = time * 10.0;

	for (int n = 0; n < pointerCount; ++n) {
		color = max(color, smoothstep(
			0.085,
			0.08,
			Ripples(uv, pointers[n].xy / mx)));
			// distance(uv, pointers[n].xy / mx)));
			// float nFloat = float(n);
			// id of n
			color += 0.5 + 0.5 * cos(pointers[n].x * uv.xyx + vec3(0.0, 2.0, 4.0));



	}

	color /= float(pointerCount);

	gl_FragColor = vec4(color, 1.0);
}
