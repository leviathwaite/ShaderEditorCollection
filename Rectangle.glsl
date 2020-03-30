#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

vec3 red = vec3(1.0, 0.0, 0.0);

float Band(float pos, float width)
{
	float halfWidth = width * 0.5;
	return step(-halfWidth, pos) - step(halfWidth, pos);
}

// uses 2 bands
float Rectangle(vec2 pos, float width, float height)
{
	return Band(pos.x, width) * Band(pos.y, height);
}

float RoundedFrame (vec2 uv, vec2 pos, vec2 size, float radius, float thickness)
{
 	float d = length(max(abs(uv - pos),size) - size) - radius;
 	return smoothstep(0.55, 0.45, abs(d / thickness) * 5.0);
}

vec3 Rectangle2(vec2 uv, float width, float height)
{
	vec2 bl = step(vec2(width),uv);

	// bottom-left vec2
	vec2 tr = step(vec2(height),1.0-uv);

	// top-right
	return vec3(bl.x * bl.y * tr.x * tr.y);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

	vec3 col = vec3(0.0);

	// float band = Band(uv.x, 0.2);
	// band *= Band(uv.y, 0.1);

	uv.y -= 0.1;
	float band = Rectangle(uv, 0.2, 0.2);

	col += vec3(band * red);
	vec2 pos = vec2(0.0);
	float rRect = RoundedFrame(uv, pos, vec2(0.2), 0.25, 0.01);
  col += vec3(rRect * red);

  // draws off center...when using polar coords
	col += Rectangle2(uv + 0.5, 0.45, 0.45);

	gl_FragColor = vec4(col, 1.0);
}
