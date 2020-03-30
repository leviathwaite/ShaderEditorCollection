#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

float Circle(vec2 p, float radius)
{
  return length(p) - radius;
}

float wave(float x, float amount)
{
	// sin return -1 to 1, adding 1 shifts to 0 to 2, * 0.5 0 to 1
	return (sin(x * amount) + 1.0) * 0.5;
}

vec3 rgb2hsv(vec3 c)
{
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}



void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy-.5;
  uv.x *= resolution.x / resolution.y;

  float t = sin(time) * 0.5 + 0.5;

  vec3 col = vec3(0.0);
  vec4 color = texture2D(Girls, uv);
  vec3 cirCol = vec3(1.0);
  vec3 cirCol1 = vec3(1.0, 1.0, 0.0);
  vec3 cirCol2 = vec3(0.0, 1.0, 1.0);

  float numOfCir = 20.0;
  float rad = 0.2;
  float waveFactor = 0.5;

  for(float i = 0.0; i < numOfCir; i++)
  {
    float r = length(uv) * 2.5 - 0.5;
	  float a = atan(uv.y, uv.x);

    float cir = Circle(vec2(r, uv.y * t), rad);
    cir = smoothstep(0.01, 0.012, cir);

    // cirCol = mix(cirCol1, cirCol2, mod(i, 2.0));


    cirCol.r = wave(cirCol.r, waveFactor);
	  cirCol.g = wave(cirCol.g, waveFactor * 2.0);
	  cirCol.b = wave(cirCol.b, waveFactor * 4.0);

	  waveFactor += 0.5;

    col = mix(cirCol, col, cir);



    rad -= 0.01;



	}


	gl_FragColor = vec4(col, 1.0);
}
