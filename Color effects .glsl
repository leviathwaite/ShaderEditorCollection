#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 p = gl_FragCoord.xy/resolution.xy;
	// p *= 2.0;

	vec4 col = texture2D(Girls, p);


	//Desaturate
    if(p.x<.25)
	{
		col = vec4( (col.r+col.g+col.b)/3. );
	}
	//Invert
	else if (p.x<.5)
	{
		col = vec4(1.) - texture2D(Girls, p);
	}
	//Chromatic aberration
	else if (p.x<.75)
	{
		vec2 offset = vec2(.01,.0);
		col.r = texture2D(Girls, p+offset.xy).r;
		col.g = texture2D(Girls, p          ).g;
		col.b = texture2D(Girls, p+offset.yx).b;
	}
	//Color switching
	else
	{
		col.rgb = texture2D(Girls, p).brg;
	}


	//Line
	if( mod(abs(p.x+.5/resolution.y),.25)<1./resolution.y )
		col = vec4(1.);


    gl_FragColor = col;
}

