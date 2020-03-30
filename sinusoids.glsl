#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable


// https://www.shadertoy.com/view/Xt2yW3

uniform vec2 resolution;
uniform float time;

/*
fwidth equivalent abs(dFdx(p)) + abs(dFdy(p))
need to add extension
#extension GL_OES_standard_derivatives : enable
*/

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
    uv -= 0.5;
    uv.x *= resolution.x / resolution.y;
	  uv *= 2.0;

    float t = time;
    float r = 15.*(1.0+0.2*sin(5.*t));

    float l1 = 1.0 - length(uv);
    float l2 = 1.0 - length(uv + vec2(cos(t*2.5),sin(t)));
    float l3 = 1.0 - length(uv + vec2(cos(t),-sin(1.25*t)));

    float x = sin(r*l1)/2.+l2/2.0+l3/2.0;

    float fw = 0.5*fwidth(x);
	  float l = smoothstep(0.25 - fw, 0.25 + fw, x);

    gl_FragColor = vec4(l,l,l, 1.0);

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
