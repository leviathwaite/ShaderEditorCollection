#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/gen2brain/raylib-go/blob/master/examples/shaders/postprocessing/glsl330/cross_stitching.fs

uniform vec2 resolution;
uniform sampler2D Girls;


// NOTE: Render size values must be passed from code
const float renderWidth = 450.0;
const float renderHeight = 800.0;


// const float renderWidth = 2960.0;
// const float renderHeight = 1440.0;



float stitchingSize = 6.0;
int invert = 0;

vec4 PostFX(vec2 uv)
{
	vec4 c = vec4(0.0);
	float size = stitchingSize;
	vec2 cPos = uv * vec2(renderWidth, renderHeight);
	vec2 tlPos = floor(cPos / vec2(size, size));
	tlPos *= size;
	int remX = int(mod(cPos.x, size));
	int remY = int(mod(cPos.y, size));
	if (remX == 0 && remY == 0) tlPos = cPos;
	vec2 blPos = tlPos;
	blPos.y += (size - 1.0);
	if ((remX == remY) || (((int(cPos.x) - int(blPos.x)) == (int(blPos.y) - int(cPos.y)))))
	{
		if (invert == 1) c = vec4(0.2, 0.15, 0.05, 1.0);
		else c = texture2D(Girls, tlPos * vec2(1.0/renderWidth, 1.0/renderHeight)) * 1.4;
	}
	else
	{
		if (invert == 1) c = texture2D(Girls, tlPos * vec2(1.0/renderWidth, 1.0/renderHeight)) * 1.4;
		else c = vec4(0.0, 0.0, 0.0, 1.0);
}
return c;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  vec3 tc = PostFX(uv).rgb;
  vec4 finalColor = vec4(tc, 1.0);

	gl_FragColor = vec4(finalColor);
}
