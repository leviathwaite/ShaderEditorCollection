#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://pastebin.com/MksimEv7

 uniform vec2 resolution;
 uniform float time;

 float _Factor1 = 1.0;
 float _Factor2 = 1.0;
 float _Factor3 = 1.0;

 float _GridSize = 10.0;

vec2 truchetPattern(vec2 uv, float index)
{
	index = fract((index - 0.5) * 2.0);

	if(index > 0.75)
	{
	  return vec2(1.0, 1.0) - uv;
	}

	if(index > 0.5)
	{
	  return vec2(1.0 - uv.x, uv.y);
	}

	if(index > 0.25)
	{
	  return 1.0 - vec2(1.0 - uv.x, uv.y);
	}

	return uv;
}

float noise(vec2 uv)
{
  return fract(sin(dot(uv, vec2(_Factor1, _Factor2))) * _Factor3);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	_Factor1 = sin(time * 0.03) * 0.5 + 0.5;

	uv *= _GridSize;
	vec2 intVal = floor(uv);
	vec2 fracVal = fract(uv);

	vec2 tile = truchetPattern(fracVal, noise(intVal));

	float val = step(length(tile), 0.4) - step(length(tile), 0.3)
	  + step(length(tile - vec2(1.0, 0.0)), 0.4) - step(length(tile - vec2(1.0, 0.0)), 0.3)
		+ step(length(tile - vec2(0.5, 1.0)), 0.2) - step(length(tile - vec2(0.5, 1.0)), 0.1)
		+ step(tile.y, 0.7) - step(tile.y, 0.6);

	gl_FragColor = vec4(vec3(val), 1.0);
}
