#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// on "Improved texture interpolation" by Iñigo Quílez	Original description: http://www.iquilezles.org/www/articles/texture/texture.html

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

vec2 sourceSize = vec2(256.0);

void main(void) {
	vec2 p = gl_FragCoord.xy / resolution.xy;
    vec2 uv = vec2(p.x *0.5, p.y * 0.5 + 0.4); // 0.1

    //---------------------------------------------
	// regular texture map filtering
    //---------------------------------------------
	vec3 colA = texture2D(Girls, uv).xyz;

    //---------------------------------------------
	// my own filtering
    //---------------------------------------------
	float textureResolution = 64.0;
	uv = uv*textureResolution + 0.5;
	vec2 iuv = floor( uv );
	vec2 fuv = fract( uv );
	uv = iuv + fuv*fuv*(3.0-2.0*fuv); // fuv*fuv*fuv*(fuv*(fuv*6.0-15.0)+10.0);;
	uv = (uv - 0.5)/textureResolution;
	vec3 colB = texture2D(Girls, uv ).xyz;

    //---------------------------------------------
    // mix between the two colors
    //---------------------------------------------
	float f = sin(3.14*p.x + 0.7*time);
	vec3 col = mix( colA, colB, smoothstep( -0.1, 0.1, f ) );
	col *= smoothstep( 0.0, 0.01, abs(f-0.0) );

    gl_FragColor = vec4( col, 1.0 );
}
