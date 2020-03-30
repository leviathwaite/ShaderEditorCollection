#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/rasteron/b1eb4a939710d1dbd219

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

uniform float noise_seed;

vec2 scale = vec2(0.9, 0.9);

const float mScale = 0.5;

const float alpha = mScale * 2.0 + 0.75;

const float pi = 3.1415926;


//random function
float rand2(vec2 co)
{
	return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}


float rand(vec2 loc)

{

// vec2 scale = vec2(1.0, 1.0);

float theta1 = dot(loc, vec2(0.9898, 0.233));

float theta2 = dot(loc, vec2(12.0, 78.0));

float value = cos(theta1) * sin(theta2) + sin(theta1) * cos(theta2);

float temp = mod(197.0 * value, 1.0) + value;

float part1 = mod(220.0 * temp, 1.0) + temp;

float part2 = value * 0.5453;

float part3 = cos(theta1 + theta2) * 0.43758;

return fract(part1 + part2 + part3);

}





void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

float bound2 = 0.25 * (scale[0] * scale[0] + scale[1] * scale[1]);

float bound = sqrt(bound2);
float radius = 1.15 * bound;

float radius2 = radius * radius;

  float max_radian = 0.5 * pi - atan(alpha / bound * sqrt(radius2 - bound2));

  float factor = bound / max_radian;

  const float m_pi_2 = 1.570963;

// Fish Eye Effect

scale = vec2(0.9, 0.9);

  // move fish eye
vec2 coord = uv - vec2(0.5, 0.5); // vScreenPos - vec2(0.0, 0.0);

float dist = length(coord * scale);

float radian = m_pi_2 - atan(alpha * sqrt(radius2 - dist * dist), dist);

float scalar = radian * factor / dist;

  // move texture
vec2 new_coord = coord * scalar + vec2(0.5, 0.5);

gl_FragColor = texture2D(Girls, new_coord); //new_coord);

// Make some noise!!! ;-)

vec2 vec_offset = vec2(noise_seed, 1.0);

float brightness = rand(vec_offset) + .5;

gl_FragColor = brightness * gl_FragColor;

// B&W

float y = dot(gl_FragColor, vec4(0.299, 0.587, 0.114, 0));

gl_FragColor = vec4(y, y, y, gl_FragColor.a);


  // my static attempt
  float t = sin(time);
  // if (t > 1.0) t = 2.0 - t;
	vec3 col = vec3(0.0);
	col.r = rand2(uv - t * t);
	col.g = rand2(uv + t * t * t);
	col = vec3(min(col.r, col.g)) + 0.5;

	gl_FragColor = vec4(vec3(col) * vec3(y), 1.0);


	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
