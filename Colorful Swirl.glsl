#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
// uniform vec2 mouse;

uniform int pointerCount;
uniform vec3 pointers[10];

void main()
{
	float speed = .1;
	float scale = 0.002;
	vec2 p = gl_FragCoord.xy * scale;

	vec2 mouse = pointers[0].xy;

	for(int i=1; i<10; i++)
	{
		p.x+=0.3/float(i)*sin(float(i)*3.*p.y+time*speed)+mouse.x/1000.;
	  p.y+=0.3/float(i)*cos(float(i)*3.*p.x+time*speed)+mouse.y/1000.;
	}

	float r=cos(p.x+p.y+1.)*.5+.5;
	float g=sin(p.x+p.y+1.)*.5+.5;
	float b=(sin(p.x+p.y)+cos(p.x+p.y))*.5+.5;
	vec3 color = vec3(r,g,b);
	gl_FragColor = vec4(color,1); }