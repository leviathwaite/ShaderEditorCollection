#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_Crosshatch.shader

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;


uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraFront;

  const float hatch_y_offset = 5.0;
	const vec4 lumT = vec4(1.0, 0.7, 0.5, 0.3);
	uniform vec2 Resolution;
	varying vec2 v_vTexcoord;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = cameraAddent + uv * cameraOrientation;
	st.y = -st.y;

		// vec2 uv = v_vTexcoord.xy;
		vec2 FragCoord = gl_FragCoord.xy; // * resolution;
			// v_vTexcoord*Resolution;
		vec3 tc = vec3(1.0, 0.0, 0.0);
		float lum = length(texture2D(cameraFront, st).rgb);
			// texture2D(Girls, uv).rgb);
		tc = vec3(1.0, 1.0, 1.0);
		if (lum < lumT.x)
		{
			if (mod(FragCoord.x + FragCoord.y, 10.0) == 0.0) // was gl_FragCoord
			{
				tc = vec3(0.0, 0.0, 0.0);
			}
		}
			if (lum < lumT.y)
			{
				if (mod(FragCoord.x - FragCoord.y, 10.0) == 0.0) // was gl_FragCoord
				{
					tc = vec3(0.0, 0.0, 0.0);
				}
			}
				if (lum < lumT.z)
				{
					if (mod(FragCoord.x + FragCoord.y - hatch_y_offset, 10.0) == 0.0) // was gl_FragCoord
					{
						tc = vec3(0.0, 0.0, 0.0);
					}
				}
					if (lum < lumT.w)
					{
						if (mod(FragCoord.x - FragCoord.y - hatch_y_offset, 10.0) == 0.0) // was gl_FragCoord
						{
							tc = vec3(0.0, 0.0, 0.0);
						}
					}
						gl_FragColor = vec4(tc, 1.0);
					}


