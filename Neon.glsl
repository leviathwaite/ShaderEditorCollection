#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/genekogan/Processing-Shader-Examples/blob/master/TextureShaders/data/neon.glsl

uniform vec2 resolution;
uniform sampler2D Girls;

vec2 texOffset;
float brt = 0.1;
int rad = 3;


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	int i = 0;
	int j = 0;
	vec4 sum = vec4(0.0);
	for( i=-rad;i<rad;i++)
	{
		for( j=-rad;j<rad;j++)
		{
			sum += texture2D(Girls, uv + vec2(j,i)*texOffset.st)*brt;
		}
	}

	gl_FragColor = sum*sum+ vec4(texture2D(Girls, uv).rgb, 1.0);

}
