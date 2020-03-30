#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;


float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

void main(void)
{
	vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;
	vec2 st = vec2(atan(uv.x, uv.y), length(uv));

	uv = vec2(st.x / 6.2831 + 0.5 * 1.0, st.y);

	float x = uv.x * 12.0;
	float m = min(fract(x), fract(1.0 - x));
	float c = smoothstep(0.0, 0.1, m * 0.5 + 0.2 - uv.y);


	gl_FragColor = vec4(c);
}
