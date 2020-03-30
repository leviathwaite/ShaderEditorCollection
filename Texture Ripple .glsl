#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;



#define RADIUS 0.05

float Frequency = 10.0;
float Phase = 0.0;
float Amplitude = 0.1;

 vec4 PS(vec2 texCoord)
	{
		Phase = time;
		vec2 cord = texCoord;
		cord.x += sin(cord.y * Frequency + Phase) * Amplitude;
		// vec4 col = texure2D(Girls, cord, 1.0);
		vec4 col = vec4(texture2D(Girls, cord , 1.0));

		return col;
	}

void main(void) {

  float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;

	vec4 color = PS(uv);

	gl_FragColor = vec4(color);

}
