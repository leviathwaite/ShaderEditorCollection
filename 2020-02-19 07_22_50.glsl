#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/libretro/common-shaders/blob/master/crt/shaders/GTU-famicom/DAC.cg


#define TO_INT2(X) int(floor(((X) * 3.0) + 0.5))
#define TO_INT3(X) int(floor(((X) * 7.0) + 0.5))
#define TO_INT4(X) int(floor(((X) * 15.0) + 0.5))

bool InColorp (int p, int color)
{
	float fcol = float(color);
	float fp = float(p);
	return (mod(fcol, fp) < 6.0);
}


float NTSCsignal(int emphasis, int level, int color, int p)
{
	float black=.518;
	float white=1.962;
	float attenuation=0.746;

	// cant use arrays...
	// float vMul[9];
  // vMul[] = {0.05, 0.1, 0.25, 0.3, 0.1, 0.3, 0.25, 0.1, 0.05};

	// const float a[5] = float[5](3.4, 4.2, 5.0,

	// const float[] levels = float[8] (
	//	0.350, 0.518, 0.962,
	//	1.550, 1.094, 1.506,
	//  1.962, 1.962);

		// using mat3 as array[8]
		mat3 levels = mat3(
			0.35, 0.518, 0.962, // 1. column
			1.55, 1.094, 1.506, // 2. column
			1.962, 1.962, 1.0); // 3. column

		if(color > 13) level = 1;
		float low = levels[0].r + float(level);
		float high = levels[1].r + float(level);
		if(color == 0) low = high;
		if(color > 12) high = low;
		float signal = InColorp(p, color) ? high : low;
		if(bool(emphasis))
			if(InColorp(p, 0))
			    if(InColorp(p, 4))
			      if(InColorp(p, 8))
			      {
			        signal = signal * attenuation;
			        signal = (signal-black) / (white-black);
             }
  return signal;
}

uniform vec2 resolution;
uniform sampler2D Girls;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	// s0 replaced with Girls, tex.xy replaced by uv
	vec4 c = texture2D(Girls, uv);
	int color = int(c.x * 10.0);
	int level = int(c.y * 10.0);
	int emphasis = int(c.z * 10.0);

	int colorPhase = 1;

	float signal = NTSCsignal(emphasis,level,color,colorPhase);
	// return vec4(signal);

	gl_FragColor = vec4(signal);
}
