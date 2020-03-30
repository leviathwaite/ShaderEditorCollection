#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.geeks3d.com/20110408/cross-stitching-post-processing-shader-glsl-filter-geexlab-pixel-bender/

uniform vec2 resolution;
uniform sampler2D  Girls;

// UI_Uniform_Float(stitching_size, 1.0, 50.0, 12.0);
const float stitching_size = 6.0;

// UI_Uniform_Checkbox(invert, 0);
const bool invert = false;

const vec2 _BufferSize = vec2(512.0);

const float _Frame = 0.0;
const float _NumFrames = 0.0;

vec4 PostFX(sampler2D tex, vec2 uv, float time)
{
	float rt_w = float(_BufferSize.x);
	float rt_h = float(_BufferSize.y);
	vec4 c = vec4(0.0);
	float size = stitching_size;
	vec2 cPos = uv * vec2(rt_w, rt_h);
	vec2 tlPos = floor(cPos / vec2(size, size));
	tlPos *= size;
	int remX = int(mod(cPos.x, size));
	int remY = int(mod(cPos.y, size));
	if (remX == 0 && remY == 0) tlPos = cPos;
	vec2 blPos = tlPos; blPos.y += (size - 1.0);
	if ((remX == remY) ||
		(((int(cPos.x) - int(blPos.x)) == (int(blPos.y) - int(cPos.y)))))
	{
		if (invert) c = vec4(0.2, 0.15, 0.05, 1.0);
		else c = texture2D(tex, tlPos * vec2(1.0/rt_w, 1.0/rt_h)) * 1.4;
	}
	else
	{
		if (invert)
		c = texture2D(tex, tlPos * vec2(1.0/rt_w, 1.0/rt_h)) * 1.4;
		else c = vec4(0.0, 0.0, 0.0, 1.0);
	}
		return c;
}

	void main (void)
	{
		float time = _Frame / max(float(_NumFrames-1.0), 1.0);

		vec2 texCoord = gl_FragCoord.xy / resolution.xy;
    vec2 uv = texCoord.st;

		// vec2 uv = gl_TexCoord[0].st;
		if (uv.y > 0.5)
		{
			gl_FragColor = PostFX(Girls, uv, time);
			}
			else
			{
				uv.y += 0.5;
				vec4 c1 = texture2D(Girls, uv);
				gl_FragColor = c1;
			}
		}