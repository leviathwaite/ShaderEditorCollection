#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_Plasma.shader

uniform vec2 resolution;

uniform float time;
  vec2 Position = vec2(0.0);
  vec2 Viewport = vec2(5.0);
  vec2 Scale = vec2(1.0, 1.0);
  vec4 factor = vec4(10.0, 1.0, 0.3, 1.0);
  vec2 factor2 = vec2(1.0);

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  float x = Position.x+uv.x*Viewport.x;
  // was +gl_FragCoord.x
  float y = Position.y+uv.y*Viewport.y;
  float mov0 = x + y + cos(sin(time)*factor.w)
    * factor2.y + sin(x/factor.y)
    * factor.x;

  float mov1 = y / resolution.y / Scale.y + time;
  float mov2 = x / resolution.x / Scale.x;
  float C1 = abs(sin(mov1+time)/factor.w+mov2/factor.w-mov1-mov2+time);
  float C2 = abs(sin(C1+sin(mov0/factor.x+time)
  	+sin(y/factor.z+time)
  	+sin((x+y)/factor.y)*factor2.x));
  	float C3 = abs(sin(C2+cos(mov1+mov2+C2)
  		+cos(mov2)+sin(x/factor.x)));

  gl_FragColor = vec4( C1,C2,C3,1.0);

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
