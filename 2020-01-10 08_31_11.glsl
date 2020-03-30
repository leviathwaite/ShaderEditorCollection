#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

float sdfLine(vec2 p, float L, float R)
{
	p.y -= min(L, max(0.0, p.y));

	// return length(p) - R;

	return smoothstep(-0.01, 0.01, length(p) - R);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv *= 10.0;

  vec3 col = vec3(sdfLine(vec2(uv.x - 5.0, uv.y - 5.0), 0.0, 2.5));

	gl_FragColor = vec4(col, 1.0);
}
