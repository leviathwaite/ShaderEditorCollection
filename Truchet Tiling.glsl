#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;


float Hash21(vec2 p)
{
	p = fract(p * vec2(234.34, 435.345));
	p += dot(p, p + 34.23);
	return fract(p.x * p.y);
}

void main(void) {
	// coords -0.5 to 0.5 and adjust for aspect ratio
	vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.y;


  vec3 col = vec3(1.0);

  uv *= 5.0;


  vec2 gv = fract(uv) - 0.5;
  vec2 id = floor(uv);

  float width = 0.1;

  gv *= -1.0;

  float mask = smoothstep(0.1, -0.1, abs(gv.x + gv.y) -width);


  col += mask;
  // col += gv.x + gv.y;

  // draw red grid
  if(gv.x > .48 || gv.y > .48) col = vec3(1.0, 0.0, 0.0);

	gl_FragColor = vec4(col, 1.0);
}
