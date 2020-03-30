#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.shibuya24.info/entry/2017/05/16/000000

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

// float _Seed = 1.0;

/*
float rnd ( vec2 value, int Seed)
{
	return Frac ( Sin ( Dot (value.xy, vec2
		( 12.9898 , 78.233 )) _Seed) * 43758.5453 );
}
*/


float Hash21(vec2 p) {
    p = fract(p*vec2(123.34, 456.21));
    p += dot(p, p+45.32);
    return fract(p.x*p.y);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	float _HorizonValue = 0.1; // sin(time);

	float rndValue = Hash21(uv);
	// -1 or 1 Randomize left or right
	float tmp = step (rndValue, 0.5 ) * 2.0 - 1.0 ;

	// pixel jump value
	float rndU = _HorizonValue * tmp * rndValue;
	vec2 Uv = vec2 ( fract (uv.x * rndU), uv.y);

	float t = (sin(time * 0.1) * 0.5 + 0.5) * 4.0;
	Uv = vec2(uv.x + (Uv.x * t), uv.y);


	vec4 col = texture2D(Girls, Uv);

	gl_FragColor = vec4(col);
}
