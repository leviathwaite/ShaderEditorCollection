#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/EgorBo/27b3b039d2c67fd41d9711ab665537a7

uniform vec2 resolution;

uniform sampler2D Girls256;
uniform sampler2D Girls256NM;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	//temp workaround - flip vertically:

	vec2 vScreenPos = vec2(uv.x, -uv.y);

vec2 vTexCoord = vec2(vScreenPos.x, 1.0 - vScreenPos.y);


mat4 ycbcrToRGBTransform = mat4(

vec4(+1.0000, +1.0000, +1.0000, +0.0000),

vec4(+0.0000, -0.3441, +1.7720, +0.0000),

vec4(+1.4020, -0.7141, +0.0000, +0.0000),

vec4(-0.7010, +0.5291, -0.8860, +1.0000));


vec4 ycbcr = vec4(texture2D(Girls256, vTexCoord).r,
         // normal map
texture2D(Girls256NM, vTexCoord).ra, 1.0);

gl_FragColor = ycbcrToRGBTransform * ycbcr;



	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
