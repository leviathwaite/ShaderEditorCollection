#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

#define TO_INT2(X) int(floor(((X) * 3.0) + 0.5))
#define TO_INT3(X) int(floor(((X) * 7.0) + 0.5))
#define TO_INT4(X) int(floor(((X) * 15.0) + 0.5))

bool InColorp (int p, int color)
{
	return ((color + p) % 12 < 6);
}

float NTSCsignal(int emphasis, int level, int color, int p)
{
	float black=.518;
	float white=1.962;
	float attenuation=0.746;
	const float levels[8] = float[] (0.350 , 0.518, 0.962, 1.550,
		1.094f, 1.506, 1.962, 1.962);

	if(color > 13) level = 1;
	float low = levels[0 + level];
	float high = levels[4 + level];
	if(color == 0) low = high;
	if(color > 12) high = low;
	float signal = InColorp(p, color) ? high : low;

	if( (bool(emphasis & 1) && InColorp(p, 0)) ||
		(bool(emphasis & 2) && InColorp(p, 4)) ||
		(bool(emphasis & 4) && InColorp(p, 8)) ) signal = signal * attenuation;
		signal = (signal-black) / (white-black);
		return signal;
}

float4 main_fragment (uniform sampler2D s0 : TEXUNIT0, float2 tex : TEXCOORD, in float colorPhase) : COLOR
{
	float4 c=tex2D(s0, tex.xy);
	int color = TO_INT4(c.x);
	int level = TO_INT2(c.y);
	int emphasis = TO_INT3(c.z);
	float signal =NTSCsignal(emphasis,level,color,int(colorPhase));
return float4(signal);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	gl_FragColor = vec4(uv, 1.0, 1.0);
}
