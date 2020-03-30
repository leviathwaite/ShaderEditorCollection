#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_TV.shader

uniform vec2 resolution;
uniform sampler2D Girls;


	uniform float time;
	vec2 Position = vec2(0.0);
	vec2 Viewport = vec2(1.0);
	// line thickness, higher = thinner
	float size = 1000.0;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

		vec2 q; // = (Position+uv*Viewport)/ resolution;
		// was +gl_FragCoord.xy
		q = gl_FragCoord.xy;

		// bouncing zoom
		// uv = 0.5 + (q-0.5)*(0.9 + 0.1*sin(0.2*time));

		// uv = 0.5 + (q-0.5) * 0.9995;

		// vec3 oricol = texture2D(Girls,vec2(q.x,q.y)).xyz;
		vec3 col;
		col.r = texture2D(Girls,vec2(uv.x+0.003,uv.y)).x;
		col.g = texture2D(Girls,vec2(uv.x+0.000,uv.y)).y;
		col.b = texture2D(Girls,vec2(uv.x-0.003,uv.y)).z;
		col = clamp(col*0.5+0.5*col*col*1.2,0.0,1.0);
		col *= 0.9 + 0.1*sin(10.0*time+uv.y*size);
		// col *= 1.8;
	gl_FragColor = vec4(col,1.0);

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
