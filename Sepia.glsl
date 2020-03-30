#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

void main(void) {
	 vec2 uv = gl_FragCoord.xy / resolution.xy;

	 float amount = 1.0; // 0 no effect, 1 full effect

/*
	 vec4 color = texture2D(Girls, uv);
	 float r = color.r;
	 float g = color.g;
	 float b = color.b;
	 color.r = min(1.0, (r * (1.0 - (0.607 * amount))) + (g * (0.769 * amount)) + (b * (0.189 * amount)));
	 color.g = min(1.0, (r * 0.349 * amount) + (g * (1.0 - (0.314 * amount))) + (b * 0.168 * amount));
	 color.b = min(1.0, (r * 0.272 * amount) + (g * 0.534 * amount) + (b * (1.0 - (0.869 * amount))));
*/

   vec3 rgb = texture2D(Girls, uv).rgb;

   gl_FragColor.r = dot(rgb, vec3(.393, .769, .189));

   gl_FragColor.g = dot(rgb, vec3(.349, .686, .168));

   gl_FragColor.b = dot(rgb, vec3(.272, .534, .131));


	 // gl_FragColor = color;
}
