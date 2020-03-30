#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/libretro/common-shaders/blob/master/crt/shaders/crt-nes-mini.cg

uniform vec2 resolution;
uniform sampler2D Girls;

// https://stackoverflow.com/questions/7610631/glsl-mod-vs-hlsl-fmod
float fmod(float x, float y)
{
	return x - y * floor(x/y);
	// x- y * trunc(x/y)
}

vec4 crt_nes_mini(vec2 texture_size, vec2 co)
{
	vec3 texel = texture2D(Girls, co).rgb;
	vec3 pixelHigh = (1.2 - (0.2 * texel)) * texel;
	vec3 pixelLow = (0.85 + (0.1 * texel)) * texel;
	float selectY = fmod(co.y * 2.0 * texture_size.y, 2.0);
	float selectHigh = step(1.0, selectY);
	float selectLow = 1.0 - selectHigh;
	vec3 pixelColor = (selectLow * pixelLow) + (selectHigh * pixelHigh);
	return vec4(pixelColor, 1.0);
	}



void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	gl_FragColor = vec4(crt_nes_mini(vec2(256.0), uv));

	// return crt_nes_mini(COMPAT_texture_size, VOUT.texCoord, decal);}
}
