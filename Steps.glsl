#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

float smooth_floor(float x, float c) {
  float a = fract(x);
  float b = floor(x);
  return ((pow(a,c)-pow(1.-a,c))/2.)+b;
}

void main(void)
{
  // uv -0.5 to 0.5 and adjust aspect ratio
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;
  // set background to black
	vec3 col = vec3(0.0);
  // center origin
  uv -= 0.5;



  float size = 10.0;
  float sharpness = 75.0;
  float stepX = smooth_floor(uv.x * size, sharpness) / size;

  float stepY = -smooth_floor(uv.y * size, sharpness) / size;

  float s = stepX + stepY;
  // vec3 col = vec3(stepX + stepY) * 10.0;

  // s = m(0.0, s);

  col = vec3(s) * 10.0;

  // Output to screen
  gl_FragColor = vec4(col,1.0);
}


