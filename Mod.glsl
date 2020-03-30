#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

float plot(vec2 st, float pct, float thickness)
{
	thickness = thickness * 0.5;
  return  smoothstep( pct-thickness, pct, st.y) -
          smoothstep( pct, pct+thickness, st.y);
}


void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	uv = mod(uv * 10.0, 2.0);

	vec2 id = floor(uv);
	if(mod(id.x, 2.0) == 0.0)
  {
	  uv = vec2(uv.y, uv.x);
	}

	if(mod(id.y, 2.0) == 0.0)
  {
	  uv = vec2(uv.y, uv.x);
	}

	float s = plot(uv, 0.5, 3.5);

	uv = vec2(s);

	gl_FragColor = vec4(uv, 1.0, 1.0);
}
