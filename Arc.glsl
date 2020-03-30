#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;


const float kInvPi = 1.0 / 3.14159265;

// Play with the following values to see their effect.

const float kBluriness = 1.0;

const float kRadius = 0.75;

const float kThickness = 0.2;

const float kArc = 0.4;

const float kOffset = 0.25;


float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}


void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

  uv *= 10.0;

	 // vec2 vertTexCoord0;\n" // Passed to us from the vertex shader and interpolated for this fragment (pixel).

	 // vec4 vertColor;\n" // Passed to us from the vertex shader and interpolated for this fragment (pixel).



	 // Convert texture coordinates from range [0,1] to [-1,1]

	 // vec2 uv = 2.0 * vertTexCoord0 - 1.0;


	 // Calculate distance to (0,0).

	 float d = length( uv );


	 // Calculate angle, so we can draw segments, too.

	 float angle = atan( uv.x, uv.y ) * kInvPi * 0.5;

	 angle = fract( angle - kOffset );


	 // Create an anti-aliased circle.

	 float w = kBluriness * 0.01;

	 float circle = smoothstep( kRadius + w, kRadius - w, d );


	 // Optionally, you could create a hole in it:

	 float inner = kRadius - kThickness;

	 circle -= smoothstep( inner + w, inner - w, d );


	 // Or only draw a portion (segment) of the circle.

	 float segment = step( angle, kArc );

	 segment *= step( 0.0, angle );

	 circle *= mix( segment, 1.0, step( 1.0, kArc ) );


	 // Output final color.

	 // fragColor.a = vertColor.a * circle;

	 // fragColor.rgb = vertColor.rgb * fragColor.a;

	 gl_FragColor.a = 1.0 * circle;
	 gl_FragColor.rgb = vec3(1.0) * gl_FragColor.a;
}
