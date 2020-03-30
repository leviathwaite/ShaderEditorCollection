#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform sampler2D Girls;
// uniform vec2 texOffset;
// varying vec4 vertColor;
// varying vec4 vertTexCoord;

// multi pixel based, grey scale and add one diagonal while subtracting another

uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

  // texture 256x256
  vec2 texOffset = uv / 256.0;
  texOffset *= 6.0 * cos(time);

  uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

     // upper and lower maybe swapped

     // center
     vec2 center = uv + vec2( 0.0, 0.0);

     // upper left
     vec2 upperL = uv + vec2(-texOffset.s, -texOffset.t);
		 // upper
		 vec2 upper = uv + vec2( 0.0, -texOffset.t);
		 // upper right
		 vec2 upperR = uv + vec2(-texOffset.s, texOffset.t);
		 // left
		 vec2 left = uv + vec2(-texOffset.s, 0.0);
		 // right
		 vec2 right = uv + vec2(texOffset.s, 0.0);
		 // lower left
		 vec2 lowerL = uv + vec2(texOffset.s, -texOffset.t);
		 vec2 lower = uv + vec2( 0.0, texOffset.t);
		 // lower right
		 vec2 lowerR = uv + vec2(texOffset.s, texOffset.t);

     vec4 sumColor = vec4(0.0);
     sumColor += texture2D(Girls, upperL);
     sumColor += texture2D(Girls, upper);
     sumColor += texture2D(Girls, upperR);

     sumColor += texture2D(Girls, left);
     sumColor += texture2D(Girls, center);
     sumColor += texture2D(Girls, right);

     sumColor += texture2D(Girls, lowerL);
     sumColor += texture2D(Girls, lower);
     sumColor += texture2D(Girls, lowerR);

     sumColor /= 9.0;

		 gl_FragColor = vec4(vec3(sumColor.rgb), 1.0);
/*
		 vec2 tc0 = vertTexCoord.st + vec2(-texOffset.s, -texOffset.t);
		 vec2 tc1 = vertTexCoord.st + vec2( 0.0, -texOffset.t);
		 vec2 tc2 = vertTexCoord.st + vec2(-texOffset.s, 0.0);
		 vec2 tc3 = vertTexCoord.st + vec2(+texOffset.s, 0.0);
		 vec2 tc4 = vertTexCoord.st + vec2( 0.0, +texOffset.t);
		 vec2 tc5 = vertTexCoord.st + vec2(+texOffset.s, +texOffset.t);
		 vec4 col0 = texture2D(texture, tc0); vec4 col1 = texture2D(texture, tc1);
		 vec4 col2 = texture2D(texture, tc2); vec4 col3 = texture2D(texture, tc3);
		 vec4 col4 = texture2D(texture, tc4); vec4 col5 = texture2D(texture, tc5);
		 vec4 sum = vec4(0.5) + (col0 + col1 + col2) - (col3 + col4 + col5);
		 float lum = dot(sum, lumcoeff);
		 gl_FragColor = vec4(lum, lum, lum, 1.0) * vertColor;


uniform float rt_w;
// render target width
uniform float rt_h;
// render target height
uniform float vx_offset;
float offset[3] = float[]( 0.0, 1.3846153846, 3.2307692308 );
float weight[3] = float[]( 0.2270270270, 0.3162162162, 0.0702702703 );

void main()
{
	vec3 tc = vec3(1.0, 0.0, 0.0);

	if (gl_TexCoord[0].x<(vx_offset-0.01))
	{
		vec2 uv = gl_TexCoord[0].xy;
	  tc = texture2D(sceneTex, uv).rgb * weight[0];

	  for (int i=1; i<3; i++)
	  {
		  tc += texture2D(sceneTex, uv + vec2(offset[i])/rt_w, 0.0).rgb \ * weight[i];
		  tc += texture2D(sceneTex, uv - vec2(offset[i])/rt_w, 0.0).rgb \ * weight[i];
		}
	}
	else if (gl_TexCoord[0].x>=(vx_offset+0.01))
	{
		tc = texture2D(sceneTex, gl_TexCoord[0].xy).rgb;
  }

  gl_FragColor = vec4(tc, 1.0);
}
*/

}
