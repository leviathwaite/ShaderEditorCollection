#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

  // declare uniforms
	uniform sampler2D Girls;
	uniform vec2 resolution;

	const vec2 dir = vec2(1.0, 1.0);

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution;

	//this will be the RGBA sum
	vec4 sum = vec4(0.0);
	//our original texcoord for this fragment
	vec2 tc = uv;
	//the amount to blur, i.e. how far off center to sample from
	//1.0 -> blur by one pixel
	//2.0 -> blur by two pixels, etc.
	float blur = 1.0; //radius/resolution.x;
	//the direction of our blur
	//(1.0, 0.0) -> x-axis blur //(0.0, 1.0) -> y-axis blur
	float hstep = dir.x;
	float vstep = dir.y;
	//apply blurring, using a 11-tap filter with predefined gaussian weights
	sum += texture2D(Girls, vec2(tc.x -
		5.0*blur*hstep, tc.y - 5.0*blur*vstep)) * 0.0093;
	sum += texture2D(Girls, vec2(tc.x -
		4.0*blur*hstep, tc.y - 4.0*blur*vstep)) * 0.028002;
	sum += texture2D(Girls, vec2(tc.x -
		3.0*blur*hstep, tc.y - 3.0*blur*vstep)) * 0.065984;
	sum += texture2D(Girls, vec2(tc.x -
		2.0*blur*hstep, tc.y - 2.0*blur*vstep)) * 0.121703;
	sum += texture2D(Girls, vec2(tc.x -
		1.0*blur*hstep, tc.y - 1.0*blur*vstep)) * 0.175713;
	sum += texture2D(Girls, vec2(tc.x, tc.y)) * 0.198596;
	sum += texture2D(Girls, vec2(tc.x +
		1.0*blur*hstep, tc.y + 1.0*blur*vstep)) * 0.175713;
	sum += texture2D(Girls, vec2(tc.x +
		2.0*blur*hstep, tc.y + 2.0*blur*vstep)) * 0.121703;
	sum += texture2D(Girls, vec2(tc.x +
		3.0*blur*hstep, tc.y + 3.0*blur*vstep)) * 0.065984;
	sum += texture2D(Girls, vec2(tc.x +
		4.0*blur*hstep, tc.y + 4.0*blur*vstep)) * 0.028002;
	sum += texture2D(Girls, vec2(tc.x +
		5.0*blur*hstep, tc.y + 5.0*blur*vstep)) * 0.0093;
	//discard alpha for our simple demo, multiply by vertex color and return
	gl_FragColor = vec4(1.0) * sum;

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
