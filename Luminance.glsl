#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

void main(void) {
  vec2 st = gl_FragCoord.xy/resolution.xy;
  // The weight vector for luminance in sRGB is
  const vec3 W = vec3( 0.2125, 0.7154, 0.0721 );
  vec3 rgb = texture2D(Girls, st).rgb;
  float luminance = dot(rgb, W);
  gl_FragColor = vec4(luminance, luminance, luminance, 1.0);

}
