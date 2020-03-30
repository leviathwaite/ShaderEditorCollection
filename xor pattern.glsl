#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

float xorTexture( in vec2 pos )
{
    float xor = 0.0;
    for( int i=0; i<8; i++ )
    {
        xor += mod( floor(pos.x)+floor(pos.y), 2.0 );

        pos *= 0.5;
        xor *= 0.5;
    }
    return xor;
}

float slowXor(vec2 pos)
{
    float col = 0.0;
    float m = 128.0;
    for (int i=0; i<8; i++) {
        if ((pos.x - m) * (pos.y - m) < 0.0) {
            col += m;
        }
        pos = mod (pos, m);
        m *= .5;
    }
    return col;
 }

void main() {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

	// pattern is power of 2 (256.0)
	uv = mod (gl_FragCoord.xy, 256.0);

  vec3 color = vec3(0.0);

  // float xor = uv.x ^ uv.y;

  // float xor = slowXor(uv * 1.0);
  float xor = xorTexture(uv);
  float brightness = 1.0;

  color = vec3(xor) * brightness;

	// c = I+I-r;                                            \
  // O = .5+.5*cos(iTime+vec4(c/=dot(c,c)/r.x,c+2.))/*


	gl_FragColor = vec4(color, 1.0);
}
