#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// _MaxIter ("MaxIter", Range (1,1000)) = 20
// _Scale ("Scale", Range (0,1)) = 1
// _xShift ("_xShift", Range (0,10)) = 0

const highp float _MaxIter = 480.0;
highp float _Scale = 1.0;
highp float _xShift = 0.0;
highp float _yShift = 0.0;
// varying mediump vec2 xlv_TEXCOORD0;

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
  uv.y *= resolution.y / resolution.x;

  uv *= 2.5;
  uv.x -= 1.9;
	uv.y -= 2.25;

  // _Scale = sin(time * 0.1);
  _Scale = 0.5; // abs(number) zoomed out, negative flips x
  _xShift = sin(time * 0.3) * 0.5;
  _yShift = cos(time * 0.3) * 0.5;


	vec4 color_1 = vec4(0.0);
	highp float iteration;
	highp vec2 coord_3 = vec2(0.0);
	highp vec2 mcoord_4;

	// mcoord_4.x = (uv.x); // * 3.5)
				//	- 2.5) * _Scale - _xShift;
	// mcoord_4.y = (uv.y); // * 2.0 - 1.0) * _Scale -_yShift;

	for (float i = 0.0; i < _MaxIter; i++)
	{
	  iteration = i;

		if (coord_3.x * coord_3.x + coord_3.y * coord_3.y > 4.0)
		{
		 break;
		};

		highp float tmpvar_5;
		tmpvar_5 = (coord_3.x * coord_3.x - coord_3.y * coord_3.y) + uv.x;
		coord_3.y = 2.0 * coord_3.x * coord_3.y + uv.y;
		coord_3.x = tmpvar_5;
	}




		color_1.x = (0.5 + (0.5 * sin(
		  (iteration * 0.11))));
		color_1.y = (0.5 + (0.5 * cos(
		  (iteration * 0.077))));
		color_1.z = (0.5 + (0.5 * sin(
			(iteration * 0.027))));
		color_1.w = 1.0;


	gl_FragColor = vec4(color_1);
}
