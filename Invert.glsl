#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

// negative created invert effect
vec3 Contrast(vec3 color, float contrast)
{
	// increase values above 0.5 and decrease below 0.5
  color -= 0.5;
  color *= contrast;
  color += 0.5;
  return color;
}

vec3 Invert(vec3 color)
{
	return 1.0 - color;
}

vec3 Intensity(vec3 color, float factor)
{
	return color *= factor;
}

vec3 GreyScaleAverage(vec3 color)
{
	return vec3(color.r + color.g + color.b / 3.0);
}

vec3 GreyScaleBasic(vec3 color)
{
	color.r *= 0.3;
	color.g *= 0.59;
	color.b *= 0.11;
  return color;
}

// TODO fixme
vec3 GreyScaleFancy(vec3 color)
{
	vec3 lumCoeff = vec3(0.3, 0.59, 0.11);
	// color = dot(color, lumCoeff);
	return color;
}

// could use any of the 3 channels
vec3 SingleColorChannelGrayScale(vec3 color)
{
	return vec3(color.r);
}

vec3 HSLGrayScale(vec3 color)
{
	return color;
	// return ( max(color.r, color.g, color.b) + min(color.r, color.g, color.b) ) / 2.0;
}

vec3 GrayScaleRange(vec3 color, float NumberOfShades)
{
	float ConversionFactor = 255.0 / (NumberOfShades - 1.0);
	float AverageValue = (color.r + color.g + color.b) / 3.0;
	float Gray = ((AverageValue / ConversionFactor) + 0.5) * ConversionFactor;
  return vec3(Gray);
}

vec3 BlackLight(vec3 color, float fxWeight)
{
	float lum = color.r + color.g + color.b / 3.0;
	// L = (222 * R + 707 * G + 71 * B) \ 1000
	// R = Abs(R - L) * fxWeight
	color.r = abs(color.r - lum) * fxWeight;
	color.r = clamp(color.r, 0.0, 1.0);
	color.g = abs(color.g - lum) * fxWeight;
	color.g = clamp(color.g, 0.0, 1.0);
	color.b = abs(color.b - lum) * fxWeight;
	color.b = clamp(color.b, 0.0, 1.0);

	return color;
}

// TODO swizzle and wave

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  vec3 col = texture2D(Girls, uv).rgb;

  // col = Contrast(col, 2.0);

  // col = Invert(col);

  //col = Intensity(col, 2.0);

  // needs tuning, around 250.0 works
  // col = GrayScaleRange(col, 250.0);

  col = BlackLight(col, 2.0);

	gl_FragColor = vec4(col, 1.0);
}
