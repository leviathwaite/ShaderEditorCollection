#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_Thermal.shader

uniform vec2 resolution;
uniform sampler2D Girls;

uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraFront;


// uniform vec3 c1;
// uniform vec3 c2;
// uniform vec3 c3;
varying vec2 v_vTexcoord;

vec3 m( vec3 A, vec3 B, float alpha )
{
	return A + alpha * (B-A);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 st = cameraAddent + uv * cameraOrientation;

	// vec2 uv = gl_FragCoord.xy; // v_vTexcoord.xy;
	vec3 tc = vec3(1.0, 0.0, 0.0);
	// vec4 pixcol = texture2D(Girls, uv);
	vec4 pixcol = texture2D(cameraFront, st);
	vec3 c1,c2,c3;
	c1 = vec3(0.,0.,1.0);
	c2 = vec3(1.,1.,0.0);
	c3 = vec3(1.,0.,0.0);
	float lum = (pixcol.r+pixcol.g+pixcol.b)/3.0;
	if ( lum < 0.5 )
	{
		tc=m(c1,c2,lum/0.5);
	}
	else
	{
		tc=m(c2,c3,(lum-0.5)/0.5);
	}
	gl_FragColor = vec4(tc,pixcol.a);
	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
