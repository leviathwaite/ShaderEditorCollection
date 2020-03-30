#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

vec3 red = vec3(1.0, 0.0, 0.0);
vec3 beige = vec3(255.0, 254.0, 235.0) / 255.0;
vec3 yellow = vec3(1.0, 1.0, 0.0);
vec3 blue = vec3(0.0, 0.0, 1.0);

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

void main(void) {
	// setup uv -0.5 to 0.5 and adjust aspect ratio
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;
  // set background to black
	vec3 col = vec3(0.0);

	float redRect = 0.0;
  float beigeRect = 0.0;
  float yellowRect = 0.0;
  float blueRect = 0.0;

  // flip x coords, not sure why their wrong...
	uv.x = -uv.x;

  // top row
  // red
  vec2 pos = vec2(uv.x - 0.5, uv.y -0.95);
	redRect = Rectangle(pos, 0.15, 0.3);

	pos = vec2(uv.x - 0.3, uv.y - 0.95);
	redRect += Rectangle(pos, 0.15, 0.3);

  // beige
	pos = vec2(uv.x + 0.025, uv.y - 0.95);
	beigeRect += Rectangle(pos, 0.4, 0.3);

  pos = vec2(uv.x + 0.35, uv.y - 0.95);
	beigeRect += Rectangle(pos, 0.15, 0.3);

	// yellow
	pos = vec2(uv.x + 0.55, uv.y - 0.95);
	yellowRect += Rectangle(pos, 0.15, 0.3);

	// 2nd row
	// red
  pos = vec2(uv.x - 0.5, uv.y -0.6);
	redRect += Rectangle(pos, 0.15, 0.3);

	pos = vec2(uv.x - 0.3, uv.y - 0.6);
	redRect += Rectangle(pos, 0.15, 0.3);

  // beige
	pos = vec2(uv.x + 0.025, uv.y - 0.6);
	beigeRect += Rectangle(pos, 0.4, 0.3);

  pos = vec2(uv.x + 0.35, uv.y - 0.6);
	beigeRect += Rectangle(pos, 0.15, 0.3);

	// yellow
	pos = vec2(uv.x + 0.55, uv.y - 0.6);
	yellowRect += Rectangle(pos, 0.15, 0.3);

  // 3rd row
  // beige

  // this rect runs into row 4
  pos = vec2(uv.x -0.425, uv.y + 0.35);
	beigeRect += Rectangle(pos, 0.4, 1.5);

  pos = vec2(uv.x + 0.025, uv.y + 0.2);
	beigeRect += Rectangle(pos, 0.4, 1.2);

  pos = vec2(uv.x + 0.35, uv.y + 0.2);
	beigeRect += Rectangle(pos, 0.15, 1.2);

	pos = vec2(uv.x + 0.55, uv.y + 0.2);
	beigeRect += Rectangle(pos, 0.15, 1.2);

	// 4th row

  // beige
	pos = vec2(uv.x + 0.025, uv.y + 1.0);
	beigeRect += Rectangle(pos, 0.4, 0.3);

  // blue
  pos = vec2(uv.x + 0.35, uv.y + 1.0);
	blueRect += Rectangle(pos, 0.15, 0.3);

	pos = vec2(uv.x + 0.55, uv.y + 1.0);
	blueRect += Rectangle(pos, 0.15, 0.3);

	col += vec3(redRect * red);
	col += vec3(beigeRect * beige);
	col += vec3(yellowRect * yellow);
  col += vec3(blueRect * blue);

	gl_FragColor = vec4(col, 1.0);
}
