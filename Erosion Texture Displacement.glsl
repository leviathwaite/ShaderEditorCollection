#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.shadertoy.com/view/Wl23Dw
// https://amesyta.wordpress.com/2018/06/14/alpha-erosion-function/amp/

uniform vec2 resolution;
uniform float time;

uniform sampler2D Girls;

uniform sampler2D CloudNoise;

float alpha_erosion (vec4 erosion_texture, float erosion_value)
	{
		//If user erosion input is 1, make alpha fully opaque by setting
		//subtracted value to -1.
		float fully_opaque = smoothstep(0.0, 0.01, erosion_value);
		// lerp(glsl not supported) changed to mix
		float opaque_erosion_value = mix(-1.0, erosion_value, fully_opaque);
		// Subtract alpha
		// saturate(glsl not supported) changed to clamp function
		// return clamp(ceil(erosion_texture.r - opaque_erosion_value));

	  // return clamp(ceil(erosion_texture.r - opaque_erosion_value), -1.0, 1.0);
	  return 1.0;
	}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 col = texture2D(Girls, uv);


	//uv *= sin(time);
	// float alpha = alpha_erosion(texture2D(CloudNoise, uv), 0.0);
	float alpha = texture2D(CloudNoise, uv).x;
	alpha = sin(alpha + time) + 1.0 * 0.5;
	gl_FragColor = vec4(col * (1.0 - alpha));
}
