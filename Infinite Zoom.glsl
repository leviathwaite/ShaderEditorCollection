#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

//https://www.shadertoy.com/view/4tBBRd

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  float iDate = time;
  vec2 w = gl_FragCoord.xy;

  float t=fract(-iDate *.3);
  vec2 q = w /resolution.x,p=(q-.3)*pow(2.,t*2.)/32.;

  for(int i=0;i<17;++i)
    p.x=fract(p.x)-.5,
    gl_FragColor = texture2D(Girls,vec2(length(p=abs(p)*mat2(1.618, 1.1756, -1.1756, 1.618))*.0008*pow(.39,t)));



	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
