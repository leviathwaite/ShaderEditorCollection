#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define PI 3.14159265359
#define TAU 6.2831


float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}


void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;



  // Find the pixel distance and angle from the center
  float pixel_angle = atan(uv.x,uv.y);
  float pixel_distance =  length(uv)* 2.0 ;

  //alternate way to get pixel distance
  //float pixel_distance = sqrt(dot(uv,uv) ) * 2.0;
  // polar coords
  vec2 st = vec2(pixel_angle , pixel_distance);//pixel_angle
  // cos range -1.0 to 1.0, st_anim range -TAU to TAU
  float st_anim = cos(time) * TAU;
  // st_anim = 0.0;


  //The above will only give you results from 0 to 0.5 (180 degrees) so we add another half 0.5
  // Watch this tutorial to understand the range of the atan function
  // coding math episode 5: https://youtu.be/LHzgW9aQUV8?t=482
  gl_FragColor = vec4((st.x + st_anim) / TAU + 0.5);// PI_2 is defined to be 6.2831
}
