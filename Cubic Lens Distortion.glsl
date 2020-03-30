#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;


// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_Cubic.shader
//Cubic Lens Distortion GLSL Shader//http://vvvv.org/contribution/ft-cubic-lens-distortion
	//r2 = image_aspect*image_aspect*u*u + v*v
	//f = 1 + r2*(k + kcube*sqrt(r2))
	//u' = f*u
	//v' = f*v

	// varying vec2 v_vTexcoord;
	// uniform vec2 Viewport;
	uniform sampler2D Girls;
	const float k = 0.2; // 0.2
	const float kcube = 1.0; // 0.3
	const float dispersion = 0.01; // 0.01
	vec2 center = vec2(0.5, 0.5); // default was 0.5,0.5
	vec2 canvas = vec2(1.0);
  // default was 1.0,1.0
	vec3 disperseComponents = vec3(0.9, 0.6, 0.3);
	// default was 0.9, 0.6, 0.3
	float Scale = 0.85;
	// 0.85

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	center =  vec2(sin(time));

		//index of refraction of each color channel,
		//causing chromatic dispersion

		vec3 eta = vec3(1.0+dispersion*disperseComponents.r,
			1.0+dispersion*disperseComponents.g,
			1.0+dispersion*disperseComponents.b);

		//canvas coordinates to get the center of rendered viewport
		vec2 cancoord = uv; // gl_FragCoord.xy; // v_vTexcoord;
		float cx=center.x+(cancoord.x-canvas.x);
		float cy=center.y+(cancoord.y-canvas.y);
		float r2 = cx*cx+cy*cy;
		float f = 1.0 + r2 * (k + kcube * sqrt(r2));
		// get the right pixel for the current position

		vec2 rCoords = (f*eta.r)*Scale*(uv.xy-0.5)+0.5;
		vec2 gCoords = (f*eta.g)*Scale*(uv.xy-0.5)+0.5;
	  vec2 bCoords = (f*eta.b)*Scale*(uv.xy-0.5)+0.5;
		vec2 aCoords = (f*eta.b)*Scale*(uv.xy-0.5)+0.5;
		vec4 inputDistort = vec4( texture2D(Girls,rCoords).r,
			texture2D(Girls,gCoords).g,
			texture2D(Girls,bCoords).b,
			texture2D(Girls,bCoords).a );

		vec4 Color = inputDistort;
		gl_FragColor = Color;
}
