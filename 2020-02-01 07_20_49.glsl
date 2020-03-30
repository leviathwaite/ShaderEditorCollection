#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;
uniform sampler2D noise;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec4 col = texture2D(Girls, uv);
	col.r = texture2D(Girls, uv * sin(time)).r;

	float motion = time * 0.1;
	float motion2 = motion * 0.5;

	vec2 noiseMotion = vec2(sin(uv.x) , uv.y - motion ); // - (time * 1.0));
	vec4 dist = texture2D(noise, noiseMotion);
	dist *= 1.0 - (sin(time) +1.0 * 0.5);

	// col = texture2D(Girls, vec2(uv.x - dist.g, uv.y - dist.r - motion2));
  col = texture2D(Girls, uv * dist.gr);

	gl_FragColor = vec4(col);
}
