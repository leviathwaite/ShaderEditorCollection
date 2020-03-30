#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.shadertoy.com/view/tlj3W1

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

vec2 uvToPx(vec2 uv) {
    return uv * min(resolution.x, resolution.y) / 3.0 + resolution.xy / 2.0;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	gl_FragColor = texture2D(Girls, vec2(gl_FragCoord.x, resolution.y - gl_FragCoord.y), 0.0);

    gl_FragColor = vec4(1.0) * (1.0 - gl_FragColor.x) + vec4(1.0,0.1,0.3,2.0) * gl_FragColor.x;

    uv = (gl_FragCoord.xy - resolution.xy / 2.0) / (min(resolution.x, resolution.y) / 3.0);

    float fragsPerUnit = resolution.y / 3.0;

    float c = -sin(time);
    float a = -cos(2.0 * time) + cos(time);
    float b = -c - sin(2.0 * time);
    float d = 2.0 * sin(time / 2.0);
    if (time == 0.0) {
        a = 0.0;
        b = 1.0;
        c = 1.0;
        d = 1.0;
    }
    /*

    if (iMouse.z > -0.0) {
    float alpha = min(
        max(
        	clamp((uv.x*uv.x + uv.y*uv.y - 1.0 - 30.0 / iResolution.x) * iResolution.x / 15.0, 0.0, 1.0),
        	1.0 - clamp((uv.x*uv.x + uv.y*uv.y - 1.0 + 30.0 / iResolution.x) * iResolution.x / 15.0, 0.0, 1.0)
        ),
        1.0 - clamp(15.0 / iResolution.x - (abs((a * uv.x + b * uv.y + c) / d)), 0.0, (6.0 / iResolution.x)) / (6.0 / iResolution.x)
    );
    fragColor.xyz *= alpha;
    */

    float alpha = min(
        clamp(distance(gl_FragCoord.xy, uvToPx(vec2(sin(time), -cos(time)))) - 10.0, 0.0, 1.0),
        clamp(distance(gl_FragCoord.xy, uvToPx(vec2(sin(2.0 * time), -cos(2.0 * time)))) - 10.0, 0.0, 1.0)
    );


    gl_FragColor.xyz = gl_FragColor.xyz * alpha + vec3(0.0, 0.8, 1.0) * (1.0 - alpha);

    // gl_FragColor = vec4(uv, 1.0, 1.0);
}
