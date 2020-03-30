#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraBack;

vec4 Pixelate(vec2 pos, float pixelDensity, vec2 aspectRatio)
{
	vec2 pixelScaling = pixelDensity * aspectRatio;

				pos = floor(pos * pixelScaling)/ pixelScaling;

				return texture2D(cameraBack, pos);

}

void main(void)
{

	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 st = cameraAddent + uv * cameraOrientation;


  // float mx = max(resolution.x, resolution.y);
	// vec2 uv = gl_FragCoord.xy / mx;
	float mx = max(resolution.x, resolution.y);
	float mn = min(resolution.x, resolution.y);

	// screen height > width
	// vec2 aspectRatio = vec2(1.0, resolution.x / resolution.y);
  vec2 aspectRatio = vec2(1.0, mn/mx);
  // aspectRatioData = new Vector2(1, (float)Screen.height / Screen.width); material.SetVector

	// gl_FragColor = vec4(texture2D(cameraBack, st).rgb,1.0);


	// vec2 uv = gl_FragCoord.xy / resolution.xy;
	// uv -= 0.5;
	// uv.y *= resolution.y / resolution.x;

	// vec3 col = vec3(0.0);
	vec4 tex = Pixelate(st,
		64.0, aspectRatio);

	gl_FragColor = vec4(
		tex.rgb,
		1.0);
}