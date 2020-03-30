#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

//https://www.shadertoy.com/view/XsBXWt

#define t time*0.5

vec4 rainbow(vec2 p)
{
// float q = max(p.x,-0.1); // ? not used
float s = sin(p.x*7.0+t*70.0)*0.08;
p.y+=s; // add ripple to rainbow
p.y*=0.75; // scale rainbow height

vec4 c;
if (p.x>0.0) c=vec4(0,0,0,0); else
if (0.0/6.0<p.y&&p.y<1.0/6.0) c= vec4(255,43,14,255)/255.0; else
if (1.0/6.0<p.y&&p.y<2.0/6.0) c= vec4(255,168,6,255)/255.0; else
if (2.0/6.0<p.y&&p.y<3.0/6.0) c= vec4(255,244,0,255)/255.0; else
if (3.0/6.0<p.y&&p.y<4.0/6.0) c= vec4(51,234,5,255)/255.0; else
if (4.0/6.0<p.y&&p.y<5.0/6.0) c= vec4(8,163,255,255)/255.0; else
if (5.0/6.0<p.y&&p.y<6.0/6.0) c= vec4(122,85,255,255)/255.0; else

if (abs(p.y)-.05<0.0001)
 c=vec4(0.,0.,0.,1.);

else if (abs(p.y-1.)-.05<0.0001) c=vec4(0.,0.,0.,1.); else
 c=vec4(0,0,0,0);

c.a*=.8-min(.8,abs(p.x*.08)); // alpha? not sure what this does
c.xyz=mix(c.xyz,vec3(length(c.xyz)),0.15); // fades colors
return c;
}


void main()
{

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;


  vec3 col = vec3(0.0);

  vec2 pos = vec2(10.0, sin((t + uv.x) * 2.0) * 2.0);
  vec4 rb = rainbow(uv*10.0 - pos); // +vec2(.8,.5));

  col = rb.rgb;

  // Output to screen
  gl_FragColor = vec4(col,1.0);
}


