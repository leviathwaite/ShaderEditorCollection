#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// another example
// https://github.com/BradLarson/GPUImage/blob/167b0389bc6e9dc4bb0121550f91d8d5d6412c53/framework/Source/GPUImageThresholdEdgeDetectionFilter.m

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;



#define RADIUS 0.05



float Threshold = 0.2;

 float ConvertToGray(vec4 color)
 {
 	float avg = color.r + color.g + color.b;
 	avg /= 3.0;
   return avg;
 }

 vec4 PS(vec2 pos, vec2 pixelSize)
 {
   	//the texture coordinate offset with vertical coordinate set to 0
   	vec2 off = vec2(pixelSize.x, 0.0);
   	//sample the left and the right neighbouring pixels
   	vec4 left = texture2D(Girls, pos - off);
   	vec4 right = texture2D(Girls, pos + off);
   	off = vec2(0.0, pixelSize.x);
   	vec4 above = texture2D(Girls, pos - off);
   	vec4 below = texture2D(Girls, pos + off);
   	if (abs(ConvertToGray(left) - ConvertToGray(right)) > Threshold
   		|| abs(ConvertToGray(above) - ConvertToGray(below)) > Threshold)
   	{
   		return vec4(1.0);
   	}
   	else
   	{
   		return vec4(0.0, 0.0, 0.0, 1.0);
   	}
 }

void main(void)
{
	// 0.0 = black, 0.7 white
  Threshold = 1.0 - (sin(time) * 0.5 + 0.5);
  vec2 PixelSize;

  float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy/ mx;

  uv = gl_FragCoord.xy / resolution.xy;



	vec3 col = vec3(0.0);

  // real pixel size
  PixelSize = (floor(uv * resolution) / gl_FragCoord.x) ;// mx;
  // PixelSize *= 0.5;



  // pixel = totalWidth / section * pixels per section

	// PixelSize.x = resolution.x * uv.x;

	vec4 color = PS(uv, PixelSize);
	color.a = 1.0;

	 color = mix(color, texture2D(Girls, uv), 0.5);

	gl_FragColor = vec4(color);

}
