#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

void main(void) {
  vec2 st = gl_FragCoord.xy/resolution.xy;
  // 0.0 = black, 1.0 = normal, 1.0+ brightens
  float brightness = 1.5;
  vec3 rgb = texture2D(Girls, st).rgb;
  rgb *= brightness;
  gl_FragColor = vec4(vec3(rgb), 1.0);

}
