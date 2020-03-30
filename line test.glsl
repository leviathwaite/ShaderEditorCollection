#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

float line(vec2 pos, float thickness)
{
	return smoothstep(-thickness, thickness, pos.y);
}

float Band(float pos, float width)
{
	float halfWidth = width * 0.5;
	return step(-halfWidth, pos) - step(halfWidth, pos);
}

vec2 tile(vec2 _st, float _zoom){
    _st *= _zoom;
    return fract(_st);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = uv;

  vec3 col = vec3(0.0);
  vec3 tex = texture2D(Girls, uv).rgb;

  uv.y = fract(uv.y * 900.0);
  // uv.y += fract(time * 0.1);

  float line = Band(uv.y - 0.5, 0.01);



  col = mix(col, vec3(1.0), line);

  // col = mix(col, tex, floor(uv.y));

	gl_FragColor = vec4(col, 1.0);

	float size = 1000.0;
	vec3 color = texture2D(Girls, st).rgb;

	// color *= 0.9 + 0.1*sin(10.0*time+st.y*size);
	color *= 0.99 + 0.1 * sin(10.0 * time + st.y * 1000.0);
	gl_FragColor = vec4(color, 1.0);
}
