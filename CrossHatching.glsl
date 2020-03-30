#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


// https://github.com/gen2brain/raylib-go/blob/master/examples/shaders/postprocessing/glsl330/cross_hatching.fs

uniform vec2 resolution;
uniform sampler2D Girls;

float hatchOffsetY = 5.0;
float lumThreshold01 = 0.9;
float lumThreshold02 = 0.7;
float lumThreshold03 = 0.5;
float lumThreshold04 = 0.3;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec3 tc = vec3(1.0, 1.0, 1.0);
	float lum = length(texture2D(Girls, uv).rgb);
	if (lum < lumThreshold01)
	{
		if (mod(gl_FragCoord.x + gl_FragCoord.y, 10.0) == 0.0)
		tc = vec3(0.0, 0.0, 0.0);
	}
	if (lum < lumThreshold02)
	{
		if (mod(gl_FragCoord.x - gl_FragCoord.y, 10.0) == 0.0)
		tc = vec3(0.0, 0.0, 0.0);
	}
	if (lum < lumThreshold03)
	{
		if (mod(gl_FragCoord.x + gl_FragCoord.y - hatchOffsetY, 10.0) == 0.0)
		tc = vec3(0.0, 0.0, 0.0);
	}
	if (lum < lumThreshold04)
	{
		if (mod(gl_FragCoord.x - gl_FragCoord.y - hatchOffsetY, 10.0) == 0.0)
		tc = vec3(0.0, 0.0, 0.0);
	}

	vec4 finalColor = vec4(tc, 1.0);


	gl_FragColor = vec4(finalColor);
}
