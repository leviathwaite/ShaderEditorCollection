#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/patriciogonzalezvivo/glslViewer/blob/master/examples/2D/02_pixelspiritdeck/lib/rotate.glsl
// https://github.com/mattdesl/shadertoy-export

uniform vec2 resolution;

float flowerSDF(vec2 st, int N)
{
	st = st*2.-1.;
	float r = length(st)*2.;
	float a = atan(st.y,st.x);
	float v = float(N)*.5;
	return 1.-(abs(cos(a*v))*.5+.5)/r;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec3 col = vec3(flowerSDF(uv, 10));

	gl_FragColor = vec4(col, 1.0);
}
