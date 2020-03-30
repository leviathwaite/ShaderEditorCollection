#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://spaghettidevops.com/2017/03/22/rendering-a-godrays-effect-as-postprocess-in-libgdx-using-shaders/


uniform sampler2D Girls;
uniform vec2 resolution;

//The width of the blur (the smaller it is the further each pixel is going to sample)
const float blurWidth = 0.00001; // -0.85
//the number of samples
#define NUM_SAMPLES 5

void main()
{
	//The center (in screen coordinates) of the light source

	vec2 center = vec2(resolution.x / 2.0, resolution.y / 2.0);
	vec2 texCoords = gl_FragCoord.xy / resolution;
	//compute ray from pixel to light center
	vec2 ray = texCoords - center;
	//output color
	vec3 color = vec3(0.0);
	//sample the texture NUM_SAMPLES times

	for(int i = 0; i < NUM_SAMPLES; i++)
	{
		//sample the texture on the pixel-to-center ray getting closer to the center every iteration
		float scale = 1.0 + blurWidth * (float(i) / float(NUM_SAMPLES - 1));
		//summing all the samples togheter
		color += (texture2D(Girls, (ray * scale) + center).xyz) / float(NUM_SAMPLES);

	}

	//return final color
	gl_FragColor = vec4(color, 1.0);
}
