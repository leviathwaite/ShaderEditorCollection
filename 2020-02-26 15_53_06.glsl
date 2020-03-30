#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

float collatz(float n)
{
	if(mod(n, 2.0) == 0.0)
	{
		n /= 2.0;
	}
	else
	{
		n = (n * 3.0) + 1.0;
	}
	return n;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;



	gl_FragColor = vec4(uv, 1.0, 1.0);
}
