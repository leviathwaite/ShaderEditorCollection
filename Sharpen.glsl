#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/rasteron/2e94bc1801ed5053bf50

uniform vec2 resolution;
uniform sampler2D Girls;

float cSharpenfactor = 100.0;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 vScreenPos = uv;

	vec4 Color = texture2D( Girls, vScreenPos.xy );


   Color -= texture2D( Girls, vScreenPos+0.0001)*cSharpenfactor;

   Color += texture2D( Girls, vScreenPos-0.0001)*cSharpenfactor;


   Color.a = 1.0;

   

   gl_FragColor = Color;
}
