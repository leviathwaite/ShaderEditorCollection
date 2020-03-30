#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/gen2brain/raylib-go/blob/master/examples/shaders/postprocessing/glsl330/bloom.fs

uniform vec2 resolution;
uniform sampler2D Girls;

vec4 colDiffuse = vec4(1.0);

const vec2 size = vec2(800, 450);
// render size
const float samples = 4.0;
// pixels per axis; higher = bigger glow, worse performance
const float quality = 2.5;
// lower = smaller glow, better quality


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 sum = vec4(0);
	vec2 sizeFactor = vec2(1)/size*quality;
	// Texel color fetching from texture sampler
	vec4 source = texture2D(Girls, uv);
	const int range = 2;
	// should be = (samples - 1)/2;
	for (int x = -range; x <= range; x++)
	{
		for (int y = -range; y <= range; y++)
		{
			sum += texture2D(Girls, uv + vec2(x, y)*sizeFactor);
		}
	}
	// Calculate final fragment color
	vec4 finalColor = ((sum/(samples*samples)) + source)*colDiffuse;


	gl_FragColor = vec4(finalColor);
}
