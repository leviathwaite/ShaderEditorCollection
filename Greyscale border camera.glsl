#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraBack;

vec3 getcamerapixel(float i, float y)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = cameraAddent + uv * cameraOrientation;
  return texture2D(cameraBack, uv + vec2(i, y)/resolution.xy).rgb;
}

	void main(void)
	{
		vec3 color0 = getcamerapixel(0.0, 0.0);
		vec3 color1 = getcamerapixel(-1.0, -1.0);
		vec3 color2 = getcamerapixel(-1.0, 0.0);
		vec3 color3 = getcamerapixel(-1.0, 1.0);
		vec3 color4 = getcamerapixel( 0.0, -1.0);
		vec3 color5 = getcamerapixel( 0.0, 1.0);
		vec3 color6 = getcamerapixel( 1.0, -1.0);
		vec3 color7 = getcamerapixel( 1.0, 0.0);
		vec3 color8 = getcamerapixel( 1.0, 1.0);
		float distance = length(color1 - color0)
		  + length(color2 - color0)
		  + length(color3 - color0)
		  + length(color4 - color0)
		  + length(color5 - color0)
		  + length(color6 - color0)
		  + length(color7 - color0)
		  + length(color8 - color0);

		if (distance > 0.1)
		{
			gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
		}
		else
		{
			gl_FragColor = vec4(0.1, 0.1, 0.1, 1.0);
		}
  }