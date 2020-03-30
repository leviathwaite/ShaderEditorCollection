#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define THICKNESS 1.0
#define DARKNESS 0.5
#define BRIGHTBOOST 1.3 // 1.1

// https://forums.libretro.com/t/simple-scanline-effect-via-glsl-shader/10999/2

// https://forum.unity.com/threads/need-some-help-writing-a-simple-scanlines-shader.375868/

uniform vec2 resolution;
uniform sampler2D Girls;

vec3 RGBtoYIQ(vec3 RGB)
	{
		const mat3 yiqmat = mat3(0.2989, 0.5870, 0.1140,
			                       0.5959, -0.2744, -0.3216,
			                       0.2115, -0.5229, 0.3114);
		return RGB * yiqmat;
	}

	vec3 YIQtoRGB(vec3 YIQ)
	{
		const mat3 rgbmat = mat3(1.0, 0.956, 0.6210,
			                       1.0, -0.2720, -0.6474,
			                       1.0, -1.1060, 1.7046);
			    return YIQ * rgbmat;
	}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	// float lines = fract(vTexCoord.y * SourceSize.y);
  float lines = fract(uv.y * 256.0); // sampler2D size
  float scale_factor = resolution.y / 512.0; // 2 times sampler2D size
	vec4 screen = texture2D(Girls, uv);
	screen.rgb = RGBtoYIQ(screen.rgb);
	screen.r *= BRIGHTBOOST;
	screen.rgb = YIQtoRGB(screen.rgb);
	gl_FragColor = (lines > (1.0 / scale_factor * THICKNESS)) ? screen : screen * vec4(1.0 - DARKNESS);


/*
  float lines = fract(vTexCoord.y * SourceSize.y);
  float scale_factor = OutputSize.y / InputSize.y;
  vec4 screen = texture(Source, vTexCoord);
  screen.rgb = RGBtoYIQ(screen.rgb);
  screen.r *= BRIGHTBOOST;
  screen.rgb = YIQtoRGB(screen.rgb);
  FragColor = (lines > (1.0 / scale_factor * THICKNESS)) ? screen : screen * vec4(1.0 - DARKNESS);
*/

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
