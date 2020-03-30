#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/rasteron/e69f642970b78d413811

uniform vec2 resolution;
uniform sampler2D Girls;


void main(void)
{

	vec2 vScreenPos = gl_FragCoord.xy / resolution.xy;

float ResS = resolution.x;

float ResT = resolution.y;

float MagTol = .5; // 0.5

float Quantize = 10.; // 10.0


vec3 irgb = texture2D(Girls, vScreenPos).rgb;

vec2 stp0 = vec2(1./ResS, 0.);

vec2 st0p = vec2(0., 1./ResT);

vec2 stpp = vec2(1./ResS, 1./ResT);

vec2 stpm = vec2(1./ResS, -1./ResT);


const vec3 W = vec3(0.2125, 0.7154, 0.0721);

float i00 = dot(texture2D(Girls, vScreenPos).rgb, W);

float im1m1 =	dot(texture2D(Girls, vScreenPos-stpp).rgb, W);

float ip1p1 = dot(texture2D(Girls, vScreenPos+stpp).rgb, W);

float im1p1 = dot(texture2D(Girls, vScreenPos-stpm).rgb, W);

float ip1m1 = dot(texture2D(Girls, vScreenPos+stpm).rgb, W);

float im10 = 	dot(texture2D(Girls, vScreenPos-stp0).rgb, W);

float ip10 = 	dot(texture2D(Girls, vScreenPos+stp0).rgb, W);

float i0m1 = 	dot(texture2D(Girls, vScreenPos-st0p).rgb, W);

float i0p1 = 	dot(texture2D(Girls, vScreenPos+st0p).rgb, W);


//H and V sobel filters

float h = -1.*im1p1 - 2.*i0p1 - 1.*ip1p1 + 1.*im1m1 + 2.*i0m1 + 1.*ip1m1;

float v = -1.*im1m1 - 2.*im10 - 1.*im1p1 + 1.*ip1m1 + 2.*ip10 + 1.*ip1p1;

float mag = length(vec2(h, v));


if(mag > MagTol){

gl_FragColor = vec4(0., 0., 0., 1.);

}else{

irgb.rgb *= Quantize;

irgb.rgb += vec3(.5,.5,.5);

ivec3 intrgb = ivec3(irgb.rgb);

irgb.rgb = vec3(intrgb)/Quantize;

gl_FragColor = vec4(irgb, 1.);

}

}

