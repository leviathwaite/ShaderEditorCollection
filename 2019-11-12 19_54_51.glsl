#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;


float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;


  vec3 col = vec3(0.0);

  float c = Circle(vec2(sin(uv.x + time * 0.05), uv.y), 0.2, 0.01);
  // uv += 0.25;
  float ic = 1.0 - Circle(vec2(sin(uv.x + time * 0.05), uv.y), 0.1, 0.01);

  col = vec3(c);
  col += vec3(ic);



  // col = mix(col, vec3(1.0, 0.0, 0.0), ic);


	gl_FragColor = vec4(col, 1.0);
}
