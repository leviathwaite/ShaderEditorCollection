#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraFront;


void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	// uv -= 0.5;
	// uv.y *= resolution.y / resolution.x;

	vec2 st = cameraAddent + uv * cameraOrientation;

  vec4 color = vec4(0.0);

  if(uv.x > 0.5)
  {
	  color = texture2D(cameraFront, st);
	}
	else
	{
		color = texture2D(cameraFront, vec2(st.x, -st.y));
	}

	// color = texture2D(cameraFront, vec2(st.x, -st.y));

	gl_FragColor = vec4(color);
}
