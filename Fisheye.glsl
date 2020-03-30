#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform sampler2D Girls;
uniform float time;
uniform vec2 resolution;
const float PI = 3.1415926535;

void main(void) {
	float aperture = 178.0;
	float apertureHalf = 0.5 * aperture * (PI / 180.0);
	float maxFactor = sin(apertureHalf);
	vec2 uv;

	vec2 Vertex_UV = gl_FragCoord.xy/resolution.xy;

	vec2 xy = 2.0 * Vertex_UV.xy - 1.0;
	float d = length(xy);

	if (d < (2.0-maxFactor))
	{
		d = length(xy * maxFactor);
		float z = sqrt(1.0 - d * d);
		float r = atan(d, z) / PI;
		float phi = atan(xy.y, xy.x);
		uv.x = r * cos(phi) + 0.5;
		uv.y = r * sin(phi) + 0.5;
	}
	else
	{
		uv = Vertex_UV.xy;
	}
		vec4 c = texture2D(Girls, uv);
		gl_FragColor = c;
}