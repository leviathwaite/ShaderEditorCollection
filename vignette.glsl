#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;



#define RADIUS 0.05

void main(void) {

  float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;

	uv.x += 0.2;
	vec2 pos = uv;
	pos.x -= 0.5;
	pos.y -= 0.5;

	float len = length(pos);

  float smoothing = 0.75;
	//use smoothstep to create a smooth vignette
	float vignette = 1.0 - smoothstep(RADIUS, smoothing, len);
	//apply the vignette with 50% opacity

	vec3 texColor = vec3(texture2D(Girls, uv , 1.0));

  // apply the vignette with 50% opacity
  vec3 col = mix(texColor, texColor * vignette, 1.5);

	gl_FragColor = vec4(col, vignette);

}
