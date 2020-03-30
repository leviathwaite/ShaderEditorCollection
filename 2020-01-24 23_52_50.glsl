#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/Unity-Technologies/PostProcessing/blob/v2/PostProcessing/Shaders/Editor/CurveGrid.shader

uniform vec2 resolution;
uniform sampler2D Girls;

float _DisabledState = 1.0;

vec4 Saturate(vec3 uv)
{
  vec4 color = vec4(vec3(0.0), 1.0);
	float sat = uv.x / 2.0;
	color.rgb += mix(color.rgb, vec3(sat),
		smoothstep(0.5, 1.2, 1.0 - uv.y)) + mix(color.rgb, vec3(sat),
		smoothstep(0.5, 1.2, uv.y)); color.rgb += vec3(0.15);
	return vec4(color.rgb, color.a * _DisabledState);
  }

vec3 HsvToRgb(vec3 c)
{
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	vec3 a = vec3(K.x);
	vec3 b = Saturate(p - vec3(K.x)).rgb;
	return c.z * mix(a, b, c.y);
}

vec4 FragHue(vec2 uv)
{
	vec3 hsv = HsvToRgb(vec3(uv.x, 1.0, 0.2));
	vec4 color = vec4(vec3(0.0), 1.0);
	color.rgb = mix(color.rgb, hsv,
		smoothstep(0.5, 1.1, 1.0 - uv.y)) + mix(color.rgb, hsv,
		smoothstep(0.5, 1.1, uv.y));

	color.rgb += vec3(0.15);
	return vec4(color.rgb, color.a * _DisabledState);
}



void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 tex = texture2D(Girls, uv);
	vec3 col = HsvToRgb(tex.rgb);

	gl_FragColor = vec4(col, 1.0);
}
