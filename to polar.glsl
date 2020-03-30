#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/KeyMaster-/70c13961a6ed65b6677d#file-polarwarp-glsl
// https://www.mathsisfun.com/polar-cartesian-coordinates.html

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

vec2 polarToCartesian(float radius, float angle)
{
	// x = rcos()
  // y = rsin()
  // pi / 4 = 45 degrees
  // r = sqrt(x squared + y squared)
  // -tan(y/x)

	return vec2(radius * cos(angle), radius * sin(angle));
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 relativePos = gl_FragCoord.xy - (resolution.xy / 2.0);

vec2 polar;

polar.y = sqrt(relativePos.x * relativePos.x + relativePos.y * relativePos.y);

polar.y /= resolution.x / 2.0;

polar.y = 1.0 - polar.y;


polar.x = atan(relativePos.y, relativePos.x);

polar.x -= 1.57079632679;

if(polar.x < 0.0){

		polar.x += 6.28318530718;

}

polar.x /= 6.28318530718;

polar.x = 1.0 - polar.x;
polar.x *= sin(time);
// polar.y *= sin(time);

// vec4 c = texture2D(Girls, polarToCartesian(polar.y, polar.x));
vec4 c = texture2D(Girls, polar);

	// fragColor = vec4(c);



	gl_FragColor = vec4(c);
}
