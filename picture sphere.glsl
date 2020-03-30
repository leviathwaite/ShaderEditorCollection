#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

const vec4 bkg_color = vec4(1.0);

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  uv.y *= resolution.y / resolution.x;
  uv.y -= 0.5;

	gl_FragColor = vec4(uv, 1.0, 1.0);

	vec2 p = -1.0 + 2.0 * uv;
	float r = sqrt(dot(p,p));

	if (r < 1.0)
	{
		// vec2 uv;
		float f = (1.0-sqrt(1.0-r))/(r);
		uv.x = p.x*f + time * 0.1;
		uv.y = p.y*f + time * 0.1;


		gl_FragColor = texture2D(Girls,uv);
	}
	else
	{
		gl_FragColor = bkg_color;
	}

}
