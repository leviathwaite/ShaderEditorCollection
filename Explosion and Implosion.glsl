#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


// http://coding-experiments.blogspot.com/2010/06/explosion-and-implosion.html?m=1

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

void main(void) {

	vec2 texCoord = gl_FragCoord.xy / resolution.xy;
	// vec2 cen = vec2(0.5,0.5) - gl_TexCoord[0].xy;
	vec2 cen = vec2(0.5,0.5) - texCoord.xy;
	// delete minus for implosion effect
	float modify = sin(time * 0.25) * 5.0;
  vec2 mcen = modify*log(length(cen))*normalize(cen); // + sin(time);
  // vec2 mcen = -0.07*log(length(cen))*normalize(cen);

  gl_FragColor = texture2D(Girls, texCoord.xy+mcen);
  // gl_FragColor = texture2D(tex, gl_TexCoord[0].xy+mcen);
}