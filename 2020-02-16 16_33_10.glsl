#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.shibuya24.info/entry/2016/12/20/093000

uniform vec2 resolution;
uniform vec2 time;

float s = 0.0 ;

float circle(vec2 p, float radius)
{
  return length(p) - radius;
}


// "line" function name cannot be used after reservation
void CreateLine ( vec2 currentTempPos, vec2 currentStraightPos, float size, vec2 fragCoord)
{
	// 0 ~ 1
	vec2 uv = fragCoord.xy;
	// vector from the original lightning position to the corrected position
	vec2 lab = currentTempPos-currentStraightPos;
	// vector from the corrected position to the uv coordinate being processed
	vec2 la = uv-currentTempPos;
	// vector from the original position to the uv coordinate being processed
	vec2 lb = uv-currentStraightPos;
	// +1 for points
	float d = ( length (la) + length (lb)
		-length (lab)) * min ( length (la), length (lb));
	// pow (x, y) returns x to the power of y
	s = max (size- pow (d * 4e8, 0.07 ), s);
}

	// return a random decimal value
	float rand ( vec2 co)
	{
		return fract ( sin ( dot (co.xy, vec2 ( 12.9898 , 78.233 ))) * 43758.5453 );

	}

	void split ( vec2 startPos, vec2 endPos, vec2 fragCoord)
	{
		int num = 5;
		float intense = 1.0;
		// Number of lightning to display at the same time
		int lightningNum = 2;

		for ( int j = 1 ; j <lightningNum; j ++)
		{
			// Lightning tip position
			vec2 temp = startPos;
			// Distance for one of the divided lightning
			vec2 d = (endPos - startPos) / float(num);

			for ( int i = 1 ; i < num; i ++)
			{
				vec2 currentPos = startPos + d * float(i);
				if (i == j * 2 )
				{
					// a random element that makes the lightning move
					intense += d + ( rand ( vec2 (float(j), float(j)) + currentPos) - 0.5 )
					* rand (currentPos) * 0.025 ;
				}
				// Tasu
				// temp = currentPos * ( rand (currentPos) - 0.5 ) * d.y;
				CreateLine (temp, currentPos, float(j) * 0.25 + 2.0 , gl_FragCoord.xy);
				temp = currentPos;
      }
     }
   }

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
  vec2 startPos = vec2(uv.x, uv.y); // vec2(0.2, 1.0);
  vec2 endPos = vec2(uv.x - 0.75, uv.y - 0.75);
	split(startPos, endPos, uv);

	vec3 col = vec3(s, s - 1.0, s - 1.0);

	float start = circle(startPos, 0.05);
	float end = circle(endPos, 0.05);

	col = mix(vec3(1.0), col, start);
	col = mix(vec3(1.0), col, end);
		// set thunder color
		// The red of the new Star Wars series has been released
		gl_FragColor = vec4(col, 1.0 );

}
