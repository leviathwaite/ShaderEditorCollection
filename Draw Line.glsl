#extension GL_OES_standard_derivatives : enable

#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

float sdLine(in vec2 p, in vec2 a, in vec2 b)
{
	vec2 pa = p - a, ba = b - a;
	float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
	return length(pa - ba * h);
}

vec3 Line(in vec3 buf, in vec2 a, in vec2 b, in vec2 p, in vec2 w, in vec4 col)
{
	float f = sdLine(p, a, b);
	float g = fwidth(f) * w.y;
	return mix(buf, col.xyz, col.w * (1.0 - smoothstep(w.x - g, w.x + g, f)));
}

float plot(vec2 st, float pct){
  return  smoothstep( pct-0.02, pct, st.y) -
          smoothstep( pct, pct+0.02, st.y);
}

float RoundedLine(vec2 uv, float length)
{
	float halfLength = length * 0.5;
	return  length(uv -vec2(clamp(uv.x, -halfLength, halfLength), 0.0));
}

float distanceToLine(vec2 p1, vec2 p2, vec2 point)
{
	float a = p1.y-p2.y;
	float b = p2.x-p1.x;
	return abs(a*point.x+b*point.y+p1.x*p2.y-p2.x*p1.y) / sqrt(a*a+b*b);
}

vec3 hash3(float n)
{
	return fract(sin(vec3(n, n + 1.0, n + 2.0)) * 43758.5453123);
}


float drawLine(vec2 uv, vec2 p1, vec2 p2, float thickness)
{
	float a = abs(distance(p1, uv));
	float b = abs(distance(p2, uv));
	float c = abs(distance(p1, p2));
	if ( a >= c || b >= c )
	return 0.0;

	float p = (a + b + c) * 0.5;
	// median to (p1, p2) vector
	float h = 2.0 / c * sqrt( p * ( p - a) * ( p - b) * ( p - c));
	return mix(1.0, 0.0, smoothstep(0.5 * thickness, 1.5 * thickness, h));

	}

uniform vec2 resolution;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;

	vec3 col = vec3(0.0, 1.0, 1.0);
	vec3 lineColor = vec3(1.0);

	float line = sdLine(uv, vec2(0.2), vec2(-0.2));
  float thickness = 0.2;
  line = smoothstep(-0.01 * thickness, 0.01 * thickness, line);

  //float p = plot(uv, 0.0);
  //vec3 red = vec3(1.0, 0.0, 0.0);
  //col = mix(col, red, p);

  // float line = distanceToLine(vec2(0.001), vec2(-0.001), uv);
  // line = smoothstep(-0.01, 0.01, line);
  float roundedLine = RoundedLine(uv * 20.0, 10.0);
  roundedLine = smoothstep(0.09, 0.2, roundedLine);
  col = vec3(line);
  vec3 col2 = vec3(roundedLine) * vec3(1.0, 0.0, 0.0);
  col = mix(col, col2, line);
	gl_FragColor = vec4(col, 1.0);
}
