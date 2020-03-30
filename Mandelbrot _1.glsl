#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif


const vec2 position = vec2(1.0);
const int maxIterations = 50;
const vec2 center = vec2(0.0); // -2.5 to 2.5
const vec3 outerColor1 = vec3(1.0, 0.0, 0.0);
const vec3 outerColor2 = vec3(0.0, 1.0, 0.0);
// const float zoom = 1.0;

uniform vec2 resolution;
uniform float time;

void main(void) {
 vec2 uv = gl_FragCoord.xy / resolution.xy;

 float zoom = sin(time);

 float real = position.x * (1.0/zoom) + center.x;
 float imag = position.y * (1.0/zoom) + center.y;
 float cReal = real;
 float cImag = imag;
 float r2 = 0.0;
 int iter;
 for (iter = 0; iter < maxIterations && r2 < 4.0; ++iter)
 {
 float tempreal = real;
 real = (tempreal * tempreal) - (imag * imag) + cReal;
 imag = 2.0 * tempreal * imag + cImag;
 }
 // Base the color on the number of iterations.
 vec3 color;
 if (r2 < 4.0)
 color = vec3(0.0);
 else
 color = mix(outerColor1, outerColor2, fract(float(iter)*0.05));

 gl_FragColor = vec4 (clamp(color, 0.0, 1.0), 1.0);

}
