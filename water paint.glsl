#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gitlab.com/higan/xml-shaders/tree/master/shaders/OpenGL/v1.0

// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_Waterpaint.shader

uniform vec2 resolution;


  uniform sampler2D Girls;
	vec2 textureSize = vec2(128.0);

	vec4 compress(vec4 in_color, float threshold, float ratio)
	{
		vec4 d = in_color - vec4(threshold);
		d = clamp(d, 0.0, 100.0);
		return in_color - (d * (1.0 - 1.0/ratio));
	}

	vec4 effect(vec2 uv) {
		float tx = 0.5 * (1.0 / textureSize.x);
		float ty = 0.5 * (1.0 / textureSize.y);
		vec2 dg1 = vec2( tx, ty);
		vec2 dg2 = vec2(-tx, ty);
		vec2 dx = vec2(tx, 0.0);
		vec2 dy = vec2(0.0, ty);
		vec3 _c00 = texture2D(Girls, uv - dg1).xyz;
		vec3 _c01 = texture2D(Girls, uv - dx).xyz;
		vec3 _c02 = texture2D(Girls, uv + dg2).xyz;
		vec3 _c10 = texture2D(Girls, uv - dy).xyz;
		vec3 _c11 = texture2D(Girls, uv).xyz;
		vec3 _c12 = texture2D(Girls, uv + dy).xyz;
		vec3 _c20 = texture2D(Girls, uv - dg2).xyz;
		vec3 _c21 = texture2D(Girls, uv + dx).xyz;
		vec3 _c22 = texture2D(Girls, uv + dg1).xyz;
		vec3 first = mix(_c00, _c20, fract(uv.x * textureSize.x + 0.5));
		vec3 second = mix(_c02, _c22, fract(uv.x * textureSize.x + 0.5));
		vec3 mid_horiz = mix(_c01, _c21, fract(uv.x * textureSize.x + 0.5));
		vec3 mid_vert = mix(_c10, _c12, fract(uv.y * textureSize.y + 0.5));
		vec3 res = mix(first, second, fract(uv.y * textureSize.y + 0.5));
		vec4 final = vec4(0.26 * (res + mid_horiz + mid_vert) + 3.5 * abs(res - mix(mid_horiz, mid_vert, 0.5)), 1.0);
		final = compress(final, 0.8, 5.0);
		final.a = 1.0;
		return final;
		}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;





		gl_FragColor = effect(uv);

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
