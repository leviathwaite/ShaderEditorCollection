#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/radif/MorphFragmentShaders/blob/master/morph/shaders/static_tv_outline.fsh

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

//random function
float rand(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 m_color = texture2D(Girls, uv);
	if(m_color.a < 0.1)
	{
		gl_FragColor = m_color; return;
	}
	float r, g;
	float t = time;
	lowp int tint = int(t);
	if (t > 1.0) t -= float(tint);

	t *= 2.0;

	if (t > 1.0) t = 2.0 - t;

	t += 1.0;
	r = rand(uv - t * t);
	g = rand(uv + t * t * t);
	float color = max(r, g);
	gl_FragColor = vec4(color, color, color,1);

	// my static attempt
	vec3 col = vec3(0.0);
	col.r = rand(uv - t * t);
	col.g = rand(uv + t * t * t);
	col = vec3(min(r, g)) + 0.5;

	gl_FragColor = vec4(vec3(col), 1.0);
}
