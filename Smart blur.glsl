#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/libretro/common-shaders/blob/master/blurs/smart-blur.cg

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;


uniform float SB_RED_THRESHOLD;
uniform float SB_GREEN_THRESHOLD;
uniform float SB_BLUE_THRESHOLD;
#define SB_RED_THRESHOLD 0.2
#define SB_GREEN_THRESHOLD 0.2
#define SB_BLUE_THRESHOLD 0.2
float textureSize = 256.0;

float lineWidth = 0.005;


const float mosaic = 10.0;

 bool eq(vec3 c1, vec3 c2)
 {
 	vec3 df = abs(c1 - c2);
 	return (df.r < SB_RED_THRESHOLD)
 	  && (df.g < SB_GREEN_THRESHOLD)
 	  && (df.b < SB_BLUE_THRESHOLD);
 }

vec4 smart_blur(vec2 pos, float offset)
{

  /*
  A B C
  D E F
  G H I
  */

  vec3 A = texture2D(Girls, pos - vec2(-offset, -offset)).xyz;
  vec3 B = texture2D(Girls, pos - vec2(-offset, 0.0)).xyz;
  vec3 C = texture2D(Girls, pos - vec2(-offset, offset)).xyz;
  vec3 D = texture2D(Girls, pos - vec2(0.0, -offset)).xyz;
  vec3 E = texture2D(Girls, pos - vec2(0.0, 0.0)).xyz;
  vec3 F = texture2D(Girls, pos - vec2(0.0, offset)).xyz;
  vec3 G = texture2D(Girls, pos - vec2(offset, -offset)).xyz;
  vec3 H = texture2D(Girls, pos - vec2(offset, 0.0)).xyz;
  vec3 I = texture2D(Girls, pos - vec2(offset, offset)).xyz;
  vec3 sum = vec3(0.0);

	if (eq(E,F) && eq(E,H) && eq(E,I) && eq(E,B) && eq(E,C) && eq(E,A) && eq(E,D) && eq(E,G))
	{
		sum = (E+A+C+D+F+G+I+B+H)/9.0;
		E = sum;
	}
	return vec4(E, 1.0);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 col = texture2D(Girls, uv);


	float t = sin(time * 0.2) * 0.5 + 0.5;

	if(uv.x < t)
	{

  // real pixel size
  vec2 pixelSize = (floor(uv * resolution) / gl_FragCoord.x) ;// mx;
  // PixelSize *= 0.5;

	  col = smart_blur(uv, pixelSize.x);
	}

	if(uv.x > t && uv.x < t + lineWidth)
	{
	  col = vec4(vec3(0.0), 1.0);
	}

	gl_FragColor = vec4(col);
}
