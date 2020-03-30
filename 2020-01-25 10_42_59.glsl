#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/randomize/shaders/blob/master/bully-legacy/Inverted%20Fresnel%20Glow.shader

uniform vec2 resolution;
uniform sampler2D Girls;

vec4 _RimColor = vec4(0.0,0.1188812,1.0,1.0);
float _RimPower = 1.707772;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec3 viewDir = vec3(1.0, 0.0, 1.0);
	float fresnel = (1.0 - dot( normalize(viewDir),
		normalize( vec3(0.2,0.2,0.3) ) ));
	vec4 Fresnel = vec4(fresnel);
	vec4 Pow = pow(Fresnel, vec4(_RimPower));
	float Invert = abs((Pow.x * .0007) - 1.0);
	Invert = abs(Invert - 1.0);

  float alpha = clamp(Invert * 2.0,0.0,1.0);

  vec4 tex = texture2D(Girls, uv);

	gl_FragColor = vec4(_RimColor * tex);
}
