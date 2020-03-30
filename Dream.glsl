#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://github.com/gen2brain/raylib-go/blob/master/examples/shaders/postprocessing/glsl330/dream_vision.fs

uniform vec2 resolution;
uniform sampler2D Girls;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	vec2 fragTexCoord = uv;

	vec4 color = texture2D(Girls, fragTexCoord);
	color += texture2D(Girls, fragTexCoord + 0.001);
	color += texture2D(Girls, fragTexCoord + 0.003);
	color += texture2D(Girls, fragTexCoord + 0.005);
	color += texture2D(Girls, fragTexCoord + 0.007);
	color += texture2D(Girls, fragTexCoord + 0.009);
	color += texture2D(Girls, fragTexCoord + 0.011);
	color += texture2D(Girls, fragTexCoord - 0.001);
	color += texture2D(Girls, fragTexCoord - 0.003);
	color += texture2D(Girls, fragTexCoord - 0.005);
	color += texture2D(Girls, fragTexCoord - 0.007);
	color += texture2D(Girls, fragTexCoord - 0.009);
	color += texture2D(Girls, fragTexCoord - 0.011);
	color.rgb = vec3((color.r + color.g + color.b)/3.0);
	color = color/9.5;


	gl_FragColor = vec4(color);
}
