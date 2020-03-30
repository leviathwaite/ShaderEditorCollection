#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// Attribute: a_size, the size of the node.
// Uniform: u_width, the vertical width of the
// scanlines in pixels.
// float (e.g. 4).
// Uniform: u_brightness,
// brightness of scanlines effect.
// Specify 0 (black) up to 1 (bright & saturated).
// float (e.g. 0.75)

uniform vec2 resolution;
uniform sampler2D Girls;
// 2592 x 1944
uniform float time;

#define a_size vec2(1.0, 1.0)
#define u_width resolution.x
#define tex_size vec2(256.0, 256.0) // vec2(2592, 1944)
#define u_brightness 0.5
#define u_color vec4(1.0)
#define v_color_mix vec4(1.0)

/*
vec4 Pixelate(vec2 pos, float pixelDensity, vec2 aspectRatio)
{
	vec2 pixelScaling = pixelDensity * aspectRatio;

				pos = floor(pos * pixelScaling)/ pixelScaling;

				return texture2D(cameraBack, pos);

}
*/

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution;

	float mx = max(resolution.x, resolution.y);
	float mn = min(resolution.x, resolution.y);

	vec2 aspectRatio = vec2(1.0, mn/mx);

	// 1. Pixelate vertically
	// figure out how big individual pixels are in texture space
	vec2 one_over_size = 256.0 / uv; // gl_FragCoord.xy; // 1.0 / a_size;
	// and do the same for the pixel height
	// float pixel_y = u_width * one_over_size.y;
	float pixel_y = one_over_size.y * aspectRatio.y;
	// calculate the Y pixel coordinate to read by dividing our original coordinate by the size
	// of one scanline, then multiplying by the size of a pixel.
	float coord_y = pixel_y * floor(tex_size.y / pixel_y);
	// float coord_y = gl_FragCoord.y;
	// read the new coordinate from our texture and send it back,
	// taking into
	// account node transparency
	vec4 pixel_color = texture2D(Girls, vec2(tex_size.x, coord_y)) * v_color_mix.a;
	// 2. Now add scanlines
	// if the current color is not transparent
	if (pixel_color.a > 0.0)
	{
	  // find this pixel's position in the texture
	  float this_pixel = a_size[1] * tex_size.y;
	  // calculate the force of the scanline at this point
	  // modulo of the pixel position against the scanline size dictates strength of line
	  float scanlineForce = (mod(this_pixel, u_width) / u_width);
	  float scanlineBrightness = (u_brightness * 2.0) - 1.0;
	  // factor in brightness level and a little saturation (clamp output level between 0.3 and 1.0)
	  scanlineForce = min(max(scanlineForce + scanlineBrightness, 0.3), 1.0);
	  // interpolate the pixel color from black to input color using brightness factor
	  vec4 scanlineColor = pixel_color * u_color;
	  gl_FragColor = vec4(mix(vec4(0, 0, 0, v_color_mix.a), scanlineColor, scanlineForce));
	}
	else
	{
	  // use the current (transparent) color
	  gl_FragColor = vec4(0, 0, 0, 0);
	}
}
