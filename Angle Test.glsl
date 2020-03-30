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

  vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
  float a = atan(p.y, p.x);
  float result = a / 3.1416;

  float r = sqrt(dot(p, p));



  // col = mix(col, vec3(1.0, 0.0, 0.0), ic);


	gl_FragColor = vec4(vec3(r, 0.0, 0.0), 1.0);
}
