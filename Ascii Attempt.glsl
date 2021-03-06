#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


uniform float textureSizeWidth;
//width of the texture

uniform float textureSizeHeight;
//height of the texture

uniform float texelSizeX;
// width of one texel

uniform float texelSizeY;
//height of one texel

uniform mediump float seconds;
uniform mediump float pixelWidth;
uniform mediump float pixelHeight;

varying mediump vec2 vTex;
uniform sampler2D Girls;
uniform vec2 resolution; // = vec2( 1.0/pixelWidth, 1.0/pixelHeight);
uniform float zoom;

#define P(id,a,b,c,d,e,f,g,h)

struct P
{
	float id;
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  float g;
  float h;
};

void main()
{
	vec2 uv = -vec2(floor(gl_FragCoord.x/8./zoom)*8.*zoom,floor(gl_FragCoord.y/12./zoom)*12.*zoom)/resolution;
  ivec2 pos = ivec2(mod(gl_FragCoord.x/zoom,8.),mod(gl_FragCoord.y/zoom,12.));
  vec4 tex = texture2D(Girls,vTex);
  float cha = 0.;
  float g = tex.r+tex.g+tex.b;

  if( g < .125 )
  {
	  P(11.0,0,0,0,0,0,0,0,0);
	  P(10,0,0,0,0,0,0,0,0);
	  P(9,0,0,0,0,0,0,0,0);
	  P(8,0,0,0,0,0,0,0,0);
	  P(7,0,0,0,0,0,0,0,0);
	  P(6,0,0,0,0,0,0,0,0);
	  P(5,0,0,0,0,0,0,0,0);
	  P(4,0,0,0,0,0,0,0,0);
	  P(3,0,0,0,0,0,0,0,0);
	  P(2,0,0,0,0,0,0,0,0);
	  P(1,0,0,0,0,0,0,0,0);
	  P(0,0,0,0,0,0,0,0,0);
	}
	else if( g < .25 ) // .
	{
		P(11,0,0,0,0,0,0,0,0);
		P(10,0,0,0,0,0,0,0,0);
		P(9,0,0,0,0,0,0,0,0);
		P(8,0,0,0,0,0,0,0,0);
		P(7,0,0,0,0,0,0,0,0);
		P(6,0,0,0,0,0,0,0,0);
		P(5,0,0,0,0,0,0,0,0);
		P(4,0,0,0,1,1,0,0,0);
		P(3,0,0,0,1,1,0,0,0);
		P(2,0,0,0,0,0,0,0,0);
		P(1,0,0,0,0,0,0,0,0);
		P(0,0,0,0,0,0,0,0,0);
  }
  else if( g < .375 ) // ,
	{
		P(11,0,0,0,0,0,0,0,0);
		P(10,0,0,0,0,0,0,0,0);
		P(9,0,0,0,0,0,0,0,0);
		P(8,0,0,0,0,0,0,0,0);
		P(7,0,0,0,0,0,0,0,0);
		P(6,0,0,0,0,0,0,0,0);
		P(5,0,0,0,0,0,0,0,0);
		P(4,0,0,0,1,1,0,0,0);
		P(3,0,0,0,1,1,0,0,0);
		P(2,0,0,0,0,1,0,0,0);
		P(1,0,0,0,1,0,0,0,0);
		P(0,0,0,0,0,0,0,0,0);
	}
	else if( g < .5 ) // -
	{
		P(11,0,0,0,0,0,0,0,0);
		P(10,0,0,0,0,0,0,0,0);
		P(9,0,0,0,0,0,0,0,0);
		P(8,0,0,0,0,0,0,0,0);
		P(7,0,0,0,0,0,0,0,0);
		P(6,1,1,1,1,1,1,1,0);
		P(5,0,0,0,0,0,0,0,0);
		P(4,0,0,0,0,0,0,0,0);
		P(3,0,0,0,0,0,0,0,0);
		P(2,0,0,0,0,0,0,0,0);
		P(1,0,0,0,0,0,0,0,0);
		P(0,0,0,0,0,0,0,0,0);
	}
	else if(g < .625 ) // +
	{
		P(11,0,0,0,0,0,0,0,0);
		P(10,0,0,0,0,0,0,0,0);
		P(9, 0,0,0,1,0,0,0,0);
		P(8, 0,0,0,1,0,0,0,0);
		P(7, 0,0,0,1,0,0,0,0);
		P(6, 1,1,1,1,1,1,1,0);
		P(5, 0,0,0,1,0,0,0,0);
		P(4, 0,0,0,1,0,0,0,0);
		P(3, 0,0,0,1,0,0,0,0);
		P(2, 0,0,0,0,0,0,0,0);
		P(1, 0,0,0,0,0,0,0,0);
		P(0, 0,0,0,0,0,0,0,0);
	}
	else if(g < .75 ) // *
	{
	  P(11,0,0,0,0,0,0,0,0);
		P(10,0,0,0,1,0,0,0,0);
		P(9,1,0,0,1,0,0,1,0);
		P(8,0,1,0,1,0,1,0,0);
		P(7,0,0,1,1,1,0,0,0);
		P(6,0,0,0,1,0,0,0,0);
		P(5,0,0,1,1,1,0,0,0);
		P(4,0,1,0,1,0,1,0,0);
		P(3,1,0,0,1,0,0,1,0);
		P(2,0,0,0,1,0,0,0,0);
		P(1,0,0,0,0,0,0,0,0);
		P(0,0,0,0,0,0,0,0,0);
	}
	else if(g < .875 ) // #
	{
		P(11,0,0,0,0,0,0,0,0);
		P(10,0,0,1,0,0,1,0,0);
		P(9,0,0,1,0,0,1,0,0);
		P(8,1,1,1,1,1,1,1,0);
		P(7,0,0,1,0,0,1,0,0);
		P(6,0,0,1,0,0,1,0,0);
		P(5,0,1,0,0,1,0,0,0);
		P(4,0,1,0,0,1,0,0,0);
		P(3,1,1,1,1,1,1,1,0);
		P(2,0,1,0,0,1,0,0,0);
		P(1,0,1,0,0,1,0,0,0);
		P(0,0,0,0,0,0,0,0,0);
	}
	else //
	{
		P(11,0,0,0,0,0,0,0,0);
    P(10,0,0,1,1,1,1,0,0);
		P(9,0,1,0,0,0,0,1,0);
		P(8,1,0,0,0,1,1,1,0);
		P(7,1,0,0,1,0,0,1,0);
		P(6,1,0,0,1,0,0,1,0);
		P(5,1,0,0,1,0,0,1,0);
		P(4,1,0,0,1,0,0,1,0);
		P(3,1,0,0,1,1,1,1,0);
		P(2,0,1,0,0,0,0,0,0);
		P(1,0,0,1,1,1,1,1,0);
		P(0,0,0,0,0,0,0,0,0);
	}

  if( true) // id == int(pos.y)
  {
	  int pa = a+2*(b+2*(c+2*(d+2*(e+2*(f+2*(g+2*(h)))))));
    cha = floor(mod(float(pa)/pow(2.,float(pos.x)-1.),2.));
  }

	vec3 col = vec3(tex.xyz);
	gl_FragColor = vec4(cha*col,1.);
}
