#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec3 pointers[10];

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

void main(void) {
	// vec2 uv = gl_FragCoord.xy / resolution.xy;

  // Sawtooth calc of time
  float t = time * 10.0;
  float offset = (t - floor(t)) / t;
	float time = time * offset;

    // Wave design params
	vec3 waveParams = vec3(10.0, 0.8, 0.1 );

    // Find coordinate, flexible to different resolutions
    float maxSize = max(resolution.x, resolution.y);
    vec2 uv = gl_FragCoord.xy / maxSize;

    // Find center, flexible to different resolutions
    // vec2 center = resolution.xy / maxSize / 2.;
    vec2 center = pointers[0].xy / resolution.xy;
    // Distance to the center
    float dist = distance(uv, center);

    // Original color
	vec4 c = texture2D(Girls, uv);

    // Limit to waves
	if (time > 0. && dist <= time + waveParams.z && dist >= time - waveParams.z) {
        // The pixel offset distance based on the input parameters
		float diff = (dist - time);
		float diffPow = (1.0 - pow(abs(diff * waveParams.x), waveParams.y));
		float diffTime = (diff  * diffPow);

        // The direction of the distortion
		vec2 dir = normalize(uv - center);

        // Perform the distortion and reduce the effect over time
		uv += ((dir * diffTime) / (time * dist * 80.0));

        // Grab color for the new coord
		c = texture2D(Girls, uv);

        // Optionally: Blow out the color for brighter-energy origin
        //c += (c * diffPow) / (time * dist * 40.0);
	}
	gl_FragColor = vec4(uv, 1.0, 1.0);
}
