#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_Monjori.shader
// https://codeanticode.wordpress.com/2012/08/03/shaders-in-processing-2-0-part-2/amp/
// https://www.shadertoy.com/view/lsfyRS

	// uniform vec2 Viewport;
	uniform vec3 rgbFactor1;
	uniform vec3 rgbFactor2;
	uniform vec3 rgbFactor3;
	// varying vec2 v_vTexcoord;

	vec2 Position = vec2(0.0);

uniform vec2 resolution;
uniform float time;

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  vec2 v_vTexcoord = gl_FragCoord.xy;
  vec2 Viewport = uv;

		vec2 p = -1.0 + 2.0 * uv; // (Position+(v_vTexcoord*Viewport)) / resolution;
		// was +gl_FragCoord.xy
		float a = time*40.0;
		float d,e,f,g=1.0/40.0,h,i,r,q;
		e=400.0*(p.x*0.5+0.5);
		f=400.0*(p.y*0.5+0.5);
		i=200.0+sin(e*g+a/150.0)*20.0;
		d=200.0+cos(f*g/2.0)*18.0+cos(e*g)*7.0;
		r=sqrt(pow(i-e,2.0)+pow(d-f,2.0));
		q=f/r;
		e=(r*cos(q))-a/2.0;
		f=(r*sin(q))-a/2.0;
		d=sin(e*g)*176.0+sin(e*g)*164.0+r;
		h=((f+d)+a/2.0)*g;
		i=cos(h+r*p.x/1.3)*(e+e+a)+cos(q*g*6.0)*(r+h/3.0);
		h=sin(f*g)*144.0-sin(e*g)*212.0*p.x;
		h=(h+(f-e)*q+sin(r-(a+h)/7.0)*10.0+i/4.0)*g;
		i+= cos(h*2.3*sin(a/350.0-q)) *184.0*sin(q-(r*4.3+a/12.0)*g) +tan(r*g+h)*184.0*cos(r*g+h);
		i=mod(i/5.6,256.0)/64.0;
		if(i<0.0) i+=4.0;
		if(i>=2.0) i=4.0-i;
		d=r/350.0;
		d+=sin(d*d*8.0)*0.52;
		f=(sin(a*g)+1.0)/2.0;
		gl_FragColor=vec4( vec3(f*i/rgbFactor1.x,
			i/rgbFactor1.y+d/rgbFactor3.y,
			i*rgbFactor1.z) *d*p.x +vec3(i/rgbFactor2.x+d/rgbFactor3.x,i/rgbFactor2.y+d/rgbFactor3.z,i*rgbFactor2.z) *d*(1.0-p.x), 1.0 );
			// gl_FragColor=vec4(vec3(f*i/1.6,i/2.0+d/13.0,i)*d*p.x+vec3(i/1.3+d/8.0,i/2.0+d/18.0,i)*d*(1.0-p.x),1.0);
		}

	// gl_FragColor = vec4(uv, 1.0, 1.0);

