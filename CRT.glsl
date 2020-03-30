#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/bamless/libgdx-tests/blob/master/android/assets/shaders/crt.frag

uniform vec2 resolution;
uniform sampler2D Girls;

//declare uniforms
uniform sampler2D u_texture;
const float mask = 0.45; // 0.45
const int br = 50; // 0
const float contrast = 4.0; // 0.0

void main()
{
	vec2 texCoords = gl_FragCoord.xy / resolution;
	vec2 uv = texCoords;

	if(texCoords.x < 0.5)
	{

	vec4 color = texture2D(Girls, texCoords);
	vec4 outColor = vec4(0.0, 0.0, 0.0, 1.0);
	color = clamp(color + float(br)/255.0, 0.0, 1.0);
	color = color - contrast *
		(color - 1.0) * color *
		(color - 0.5);

		int pp = int(mod(float(gl_FragCoord.x), 3.0));
		if(pp == 1)
		{
			outColor.r = color.r;
			outColor.g = color.g * mask;
			outColor.b = color.b * mask;
		}
		else if(pp == 2)
		{
			outColor.r = color.r * mask;
			outColor.g = color.g;
			outColor.b = color.b * mask;
		}
		else
		{
			outColor.r = color.r * mask;
			outColor.g = color.g * mask;
			outColor.b = color.b;
		}
		if( int(mod(float(gl_FragCoord.y), 3.0)) == 0)
		{
			outColor *= 0.7;
		}
		gl_FragColor = outColor;
  }
  else
  {
	  gl_FragColor = texture2D(Girls, texCoords);
	 }
}
