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
	return texture2D(cameraBack, st + vec2(i,y)/resolution.xy).rgb;
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

		// Filter using mean kernel
		color0 = (1.0/9.0) * (color1 + color2
			+ color3 + color4
			+ color5 + color6
			+ color7 + color8);

		float distance = length(color1 - color0)
		  + length(color2 - color0)
		  + length(color3 - color0)
		  + length(color4 - color0)
		  + length(color5 - color0)
		  + length(color6 - color0)
		  + length(color7 - color0)
		  + length(color8 - color0);

		  float max_distance = 0.1;
		  float max_magnification = 0.65;
		  vec3 magnification_factor = vec3(0.0, 0.0, 0.0);
		  vec3 target_color = vec3(1.0, 1.0, 1.0);

		  if (distance > max_distance)
		  {
		  	magnification_factor = normalize(target_color - color0) * max_magnification;
		  }
		  else
		  {
		  	magnification_factor = normalize(target_color - color0) * max_magnification * distance / max_distance;
		  }

		  	gl_FragColor = vec4(color0 + magnification_factor, 0.0);
		}