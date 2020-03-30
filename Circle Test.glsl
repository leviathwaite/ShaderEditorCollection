#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

// drawing a smooth circle with smooting
// https://github.com/ayamflow/glsl-2d-primitives/blob/master/circle.glsl

// enable fwidth, dFdx and dFdy
// https://github.com/elm-community/webgl/pull/48

// shader derivatives
// http://www.aclockworkberry.com/shader-derivative-functions/#footnote_1_1104


uniform vec2 resolution;

float aastep(float threshold, float value)
{
	#ifdef GL_OES_standard_derivatives
	float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
	// float afwidth = length(vec2(dFdx(value), dFdy(value))) * 0.70710678118654757;
  // float fwidth = fwidth(value);
	return smoothstep(threshold-afwidth, threshold+afwidth, value);

	#else
	return step(threshold, value);
	#endif
}

float circle(vec2 st, float radius)
{
	return aastep(radius, length(st - vec2(0.5)));
}

void main(void) {
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	uv.x += 0.25;

	vec3 col = vec3(0.0);

  float circle = circle(uv, 0.2);
  col = mix(vec3(1.0, 0.0, 0.0), col, circle);
  circle = circle(uv, 0.199);
  col = mix(vec3(0.0, 1.0, 0.0), col, circle);

	gl_FragColor = vec4(col, 1.0);
}
