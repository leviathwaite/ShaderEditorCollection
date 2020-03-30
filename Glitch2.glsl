#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/khalladay/GlitchFX

uniform vec2 resolution;
uniform float time;

uniform sampler2D Girls;
uniform sampler2D Olive;
uniform sampler2D GlitchBW;
uniform sampler2D Glitch;

// const float _GlitchAmount = 0.1;
// const float _GlitchRandom = 0.5;

	float rand(vec2 co)
	{
		// frac to floor
		return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
	}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float _GlitchAmount = sin(time * 0.1) + 0.5;
	float _GlitchRandom = sin(time * 0.1);

	vec3 glitch = (texture2D(GlitchBW, uv)).rgb;
	float r = (rand(vec2(glitch.r, _GlitchRandom)));
	float gFlag = max(0.0, ceil(_GlitchAmount-r));
	vec2 uvShift = (glitch.gb * 2.0 - 1.0) * r * gFlag;

	uv *= 10.0;
	// fract to floor
	vec4 col = texture2D(Olive, floor(uv + uvShift));


	gl_FragColor = vec4(col);
}
