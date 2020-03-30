#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

uniform int pointerCount;
uniform vec3 pointers[10];
// TODO figure out to track drag distance

// https://www.shadertoy.com/view/lssGDj

float character(int n, vec2 p)
{
	p = floor(p*vec2(4.0, -4.0) + 2.5);

  if (clamp(p.x, 0.0, 4.0) == p.x)
	{
    if (clamp(p.y, 0.0, 4.0) == p.y)
		{
      int a = int(floor(p.x) + 5.0 * floor(p.y));
			// if (((n >> a) & 1) == 1) return 1.0;
			// a & b = a * b (mod 2)

			int na = int(mod(float(n) / exp2(p.x + 5.0*p.y), 2.0));
      if(na == 1)
        return 1.0;
		}
  }
	return 0.0;
}

void main(void) {

	vec2 pix = gl_FragCoord.xy;
	vec3 col = texture2D(Girls, floor(pix/8.0)*8.0/resolution.xy).rgb;

	float gray = 0.3 * col.r + 0.59 * col.g + 0.11 * col.b;

	int n =  4096;                // .
	if (gray > 0.2) n = 65600;    // :
	if (gray > 0.3) n = 332772;   // *
	if (gray > 0.4) n = 15255086; // o
	if (gray > 0.5) n = 23385164; // &
	if (gray > 0.6) n = 15252014; // 8
	if (gray > 0.7) n = 13199452; // @
	if (gray > 0.8) n = 11512810; // #

	vec2 p = mod(pix/4.0, 2.0) - vec2(1.0);

	// if (iMouse.z > 0.5)	col = gray*vec3(character(n, p));
	if (pointers[0].z > 0.5)	col = gray*vec3(character(n, p));
	else col = col*character(n, p);

	gl_FragColor = vec4(col, 1.0);
}