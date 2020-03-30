#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/libretro/common-shaders/blob/master/misc/color-mangler.cg

uniform vec2 resolution;
uniform sampler2D Girls;

#define target_gamma 2.2
#define display_gamma 2.2

#define cntrst 1.0
#define sat 1.0
#define lum 1.0

#define blr 0.0
#define blg 0.0
#define blb 0.0
#define r 1.0
#define g 1.0
#define b 1.0
#define rg 0.0
#define rb 0.0
#define gr 0.0
#define gb 0.0
#define br 0.0
#define bg 0.0

vec4 color_mangler(vec2 texCoord, sampler2D decal)
{
	vec4 screen = pow(texture2D(decal, texCoord),
		vec4(target_gamma, target_gamma, target_gamma, target_gamma)).rgba;
		//sample image in linear colorspace
		vec4 avglum = vec4(0.5, 0.5, 0.5, 0.5);
		screen = mix(screen, avglum, (1.0 - cntrst));
		// r g b black
		mat4 color =
		mat4(	r,	gr,	br,	blr, //red channel
		   rg,	g,	bg,	blg, //green channel
		   rb,	gb,	b,	blb, //blue channel
		   0.,	0.,	0.,	1.0); //alpha channel;
		   //these numbers do nothing for our purposes.
		mat4 adjust =
	  mat4(
	  	(1.0 - sat) * 0.3086 + sat,
	  	(1.0 - sat) * 0.6094,
	  	(1.0 - sat) * 0.0820,		0.0,
	  	(1.0 - sat) * 0.3086,
	  	(1.0 - sat) * 0.6094 + sat,
	  	(1.0 - sat) * 0.0820,		0.0,
	  	(1.0 - sat) * 0.3086,
	  	(1.0 - sat) * 0.6094,
	  	(1.0 - sat) * 0.0820 + sat,
	  	0.0, 1.0, 1.0, 1.0, 1.0);
	  	// color = mul(color, adjust);
	  	color = color * adjust;
	  	// screen = saturate(screen * lum);
	  	screen = clamp(screen * lum, 0.0, sat);
	  	// screen = mul(color, screen);
	  	screen = screen * lum;
		return pow(screen, vec4(1.0 / display_gamma, 1.0 / display_gamma, 1.0 / display_gamma, 1.0 / display_gamma));
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	gl_FragColor = color_mangler(uv, Girls);

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
