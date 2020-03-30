#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

uniform sampler2D Girls;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	// shadertoy default starting point
	// gl_FragColor = vec4(uv,0.5+0.5*sin(time),1.0);

	// chromatic abaration circle
	// vec2 p = (gl_FragCoord.xy * 2. - resolution) / min(resolution.x, resolution.y);
  // gl_FragColor = vec4( 0.3 / length(p + vec2(sin(time * 1.23) * 0.4, 0)), 0.3 / length(p + vec2(sin(time * 2.23) * 0.4, 0)), 0.3 / length(p + vec2(sin(time * 3.23) * 0.4, 0)), 1. );

  // looks kinda light police lights
  vec2 p = (gl_FragCoord.xy * 2. - resolution) / min(resolution.x, resolution.y);
  float freq = ( texture2D(Girls, vec2(abs(p.x * .3), .5)).r *.3 * texture2D(Girls, vec2(abs(p.y * 0.3), .5)).r * 2. );
  freq *= freq;
  gl_FragColor = vec4( freq / length(p + vec2(sin(time * 1.23 + 3.), 0)), freq / length(p + vec2(sin(time * 2.23 + 4.), 0)), freq / length(p + vec2(sin(time * 3.23 + 5.), 0)), 1. );
}

