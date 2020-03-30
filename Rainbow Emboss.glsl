#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform sampler2D Girls;
// uniform vec2 texOffset;
// varying vec4 vertColor;
// varying vec4 vertTexCoord;

// grid based, grey scale and add one diagonal while subtracting another

const vec4 lumcoeff = vec4(0.299, 0.587, 0.114, 0);

const vec4 vertColor = vec4(1.0);

uniform vec2 resolution;
uniform float time;

float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	// vec2 texOffset = (floor(uv * resolution) / gl_FragCoord.x) ;// mx;

  vec2 texOffset = vec2(0.003); // + sin(time) * 0.02);
  // texOffset = uv / gl_FragCoord.xy;
  // texOffset = uv / resolution;
  // pixel size based on texture size
  texOffset = uv / 256.0;
  texOffset *= 6.0 * cos(time);

  // texOffset = uv / textureSize(Girls, 0);


  uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

  // real pixel size

     // upper and lower maybe swapped

     // upper left
     vec2 tc0 = uv + vec2(-texOffset.s, -texOffset.t);
		 // upper
		 vec2 tc1 = uv + vec2( 0.0, -texOffset.t);
		 // left
		 vec2 tc2 = uv + vec2(-texOffset.s, 0.0);
		 // right
		 vec2 tc3 = uv + vec2(+texOffset.s, 0.0);
		 // lower
		 vec2 tc4 = uv + vec2( 0.0, +texOffset.t);
		 // upper right
		 vec2 tc5 = uv + vec2(+texOffset.s, +texOffset.t);

		 vec4 col0 = texture2D(Girls, tc0);
		 vec4 col1 = texture2D(Girls, tc1);
		 vec4 col2 = texture2D(Girls, tc2);
		 vec4 col3 = texture2D(Girls, tc3);
		 vec4 col4 = texture2D(Girls, tc4);
		 vec4 col5 = texture2D(Girls, tc5);

		 vec4 sum = vec4(0.5) + (col0 + col1 + col2) - (col3 + col4 + col5);
		 // sum = vec4(0.5) + col2 - col4;

		 float lum = dot(sum, lumcoeff);
		 gl_FragColor = vec4(vec3(sum.rgb), 1.0) * vertColor;

     vec4 color = vec4(1.0);
     color = mix(color, vec4(vec3(0.0), 1.0), Circle(uv, 0.2, 0.01));

    //  gl_FragColor = color;

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
