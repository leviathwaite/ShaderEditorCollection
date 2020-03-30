#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define R 1.1

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

const vec4 blue = vec4(0.0, 0.0, 1.0, 1.0);

vec3 rgb2hsv(vec3 rgb)
{
  float Cmax = max(rgb.r, max(rgb.g, rgb.b));
  float Cmin = min(rgb.r, min(rgb.g, rgb.b));
 float delta = Cmax - Cmin;

  vec3 hsv = vec3(0., 0., Cmax);

  if (Cmax > Cmin)
  {
    hsv.y = delta / Cmax;

    if (rgb.r == Cmax)
      hsv.x = (rgb.g - rgb.b) / delta;
    else
    {
    if (rgb.g == Cmax)
      hsv.x = 2. + (rgb.b - rgb.r) / delta;
else
hsv.x = 4. + (rgb.r - rgb.g) / delta;
}
hsv.x = fract(hsv.x / 6.);
}
return hsv;
}

float chromaKey(vec3 color)
{
  vec3 backgroundColor = vec3(0.157, 0.576, 0.129);
  vec3 weights = vec3(4., 1., 2.);

  vec3 hsv = rgb2hsv(color);
  vec3 target = rgb2hsv(backgroundColor);
  float dist = length(weights * (target - hsv));
  return 1.0;
}

vec3 Scanline(vec3 color, vec2 uv)
{
	float scanline = clamp(0.95 + 0.05 * cos(3.14 * (uv.y + 0.008 * time) * 240.0 * 1.0), 0.0, 1.0);
	float grille = 0.85 + 0.15 * clamp( 1.5 * cos(3.14 * uv.x * 640.0 * 1.0), 0.0, 1.0);
	return color * scanline * grille * 1.2;
}

vec3 GreyScaleWeighted(vec3 sample)
{
	float grey = 0.21 * sample.r + 0.71 * sample.g + 0.07 * sample.b;
  return vec3(grey);
}

vec2 displacement(float h, vec2 delta)
{

  vec2 beta = asin(sin(delta) / R);

  vec2 x = tan(delta - beta);

return x*h;

}




void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	// vec4 col = texture2D(Girls, uv);
	vec4 col = texture2D(Girls, displacement(1.0, uv));
	col = vec4(Scanline(col.rgb, uv), 1.0);
	col = vec4(GreyScaleWeighted(col.rgb), 1.0);

	float alpha = sin(time * sin(time)) * 0.0001;
	alpha = 0.0;

	gl_FragColor = vec4(col.rgb + blue.rgb / 2.0, .0);

	// gl_FragColor = vec4(displacement(sin(time * sin(time)) * 22.0, uv), 0.0, 1.0);
}
