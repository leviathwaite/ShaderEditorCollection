#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D Girls;

void main(void) {

  vec2 uv = gl_FragCoord.xy / resolution.xy;
  float PI = 3.14;
  gl_FragColor = vec4(vec3(0.0), 1.0);
  const int count = 1; // 3;
  float alpha = 0.85;
  float maxLuma = 0.15;

  vec3 modColor = vec3(0.299, 0.587, 0.114);
  modColor = vec3(0.0, 1.0, 1.0);

  vec3 color2 = vec3(1.0, 0.5, 2.0);
  color2 = vec3(1.0, 0.0, 1.0);

  for (int i = 0; i < count; i++)
  {
  	float angleStep = PI / min(7.0, float(i) + 4.0);
	  vec2 cUv = uv - 0.5;
 	 cUv.x *= resolution.x / resolution.y;
 	 float angle = atan(cUv.y, cUv.x);
 	 angle = abs(mod(angle, angleStep * 2.0) - angleStep);
 	 angle -= time * 0.2;
	  float radius = length(cUv);
	  uv.x = (radius * cos(angle)) + 0.5;
	  uv.y = (radius * sin(angle)) + 0.5;

	  vec3 rgb = texture2D(Girls, uv).rgb;

	  // vec3 rgb = texture2D(Girls, uv).rgb / float(count);
	  // float L = dot(rgb, modColor);

	  // test
	  // L = dot(rgb, vec3(1.0));

	  // gl_FragColor.rgb += smoothstep(maxLuma / float(count), 0.0, L) * alpha;

    // gl_FragColor.rgb += smoothstep(maxLuma /float(count), 0.0, L);

    gl_FragColor.rgb += rgb;
  }
	  float L2 = 0.2; //dot(gl_FragColor.rgb, modColor);
	  gl_FragColor.rgb = mix(gl_FragColor.rgb, color2, L2);


}