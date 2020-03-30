#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/h3rb/gml-pro/blob/master/GML-Pro-Pack2.gmx/shaders/gles_Nightvision.shader
// https://www.geeks3d.com/20091009/shader-library-night-vision-post-processing-filter-glsl/

uniform vec2 resolution;
// uniform sampler2D noiseTex;
// uniform sampler2D maskTex;
// uniform float elapsedTime; // seconds

uniform float time;

uniform sampler2D Girls;
uniform sampler2D noise;


	const float luminanceThreshold = 0.2; // 0.2;
	const float colorAmplification = 4.0; // 4.0;

	const vec3 visionColor = vec3(0.1, 0.95, 0.2); // "green"
	// varying vec2 v_vTexcoord;


float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

void main(void) {
	// screen coords are off...
	// vec2 uv = gl_FragCoord.xy / resolution.xy;
	float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	// uv.y -= 0.5;

	vec4 finalColor;
	vec2 nuv = uv;
	nuv.x = 0.4 * sin(time * 50.0); //0.4*sin(time *50.0);
	// enabling this alone looks like beam up effect
	nuv.y = 0.4 * cos(time * 50.0); // *50.0);
	// uv.y = 0.4*cos(time * 0.1);

	// texture2D(maskTex, v_vTexcoord).r;
	// float m = texture2D(maskTex, uv).r;

	// make our own mask
	float m = 1.0 - Circle(vec2(uv.x - 0.25, uv.y - 0.5), 0.2, 0.25);
  // m = 0.0;

	// texture2D(noiseTex, (v_vTexcoord*3.5) + uv).rgb;
	vec3 n = texture2D(noise, (nuv*3.5) + nuv).rgb;
	// n = vec3(0.0);
	// texture2D(Girls, v_vTexcoord + (n.xy*0.005)).rgb;
	vec3 c = texture2D(Girls, uv + (n.xy*0.005)).rgb;


	float lum = dot(vec3(0.30, 0.59, 0.11), c);

	if (lum < luminanceThreshold)
	{
	  c *= colorAmplification;
	}


	finalColor.rgb = (c + (n*0.2)) * visionColor * m;

	gl_FragColor.rgb = finalColor.rgb;
	gl_FragColor.a = 1.0;

	// gl_FragColor = vec4(c, 1.0);
}
