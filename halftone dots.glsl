#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;



vec4 Pixelate(vec2 pos, float pixelDensity, vec2 aspectRatio)
{
	vec2 pixelScaling = pixelDensity * aspectRatio;

	pos = floor(pos * pixelScaling)/ pixelScaling;

	return texture2D(Girls, pos);

}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv.y *= resolution.y / resolution.x;

	// screen height > width
	vec2 aspectRatio = vec2(1.0, resolution.x / resolution.y);


// Distance to nearest point in a grid of

// (frequency x frequency) points over the unit square

vec4 tex = Pixelate(uv,
		256.0, aspectRatio);

float frequency = 50.0;

vec2 nearest = 2.0*fract(frequency * uv) - 1.0;

float dist = length(nearest);

float radius = (tex.r + tex.g + tex.b) / 3.0;

// float radius = 0.5;

vec3 white = vec3(1.0, 1.0, 1.0);

vec3 black = vec3(0.0, 0.0, 0.0);

// vec3 fragcolor = mix(black, white, step(radius, dist));

vec3 fragcolor = mix(black, white, step(radius, dist));
// vec3 col = vec3(0.0);

	// gl_FragColor = vec4(tex.rgb,1.0);



gl_FragColor = vec4(fragcolor, 1.0);

}

