#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.shibuya24.info/entry/2016/12/15/090000

uniform vec2 resolution;
uniform float time;

uniform vec3 pointers[10];
uniform int pointerCount;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 mouse = pointers[0].xy;
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 80.0 ) +
		cos( position.y * cos( time / 15.0 ) * 10.0 );
	color += sin( position.y * sin( time / 10.0 ) * 40.0 ) +
		cos( position.x * sin( time / 25.0 ) * 40.0 );
	color += sin( position.x * sin( time / 5.0 ) * 10.0 ) +
		sin( position.y * sin( time / 35.0 ) * 80.0 );

	color *= sin( time / 10.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color, color * 0.5,
		sin( color + time / 3.0 ) * 0.75 ), 1.0 );

}
