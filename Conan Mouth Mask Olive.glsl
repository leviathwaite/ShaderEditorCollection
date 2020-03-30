#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 cameraAddent;
uniform mat2 cameraOrientation;
uniform samplerExternalOES cameraFront;
uniform float time;
uniform sampler2D Tonio;
uniform sampler2D Liliana;
uniform sampler2D Olive;


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
	uv *= 0.7;
	uv.x -= 0.07;
	uv.y += 0.5;
	vec2 ogUV = uv;

	vec2 st = cameraAddent + uv * cameraOrientation;
	st *= 0.7;
	st.y = 1.0 - st.y;
  st.y -= 0.4;
  st.x += 0.0;
	vec4 camTex = vec4(
		texture2D(cameraFront, st));


  uv *= 0.9;
  uv.x -= 0.5;
	vec4 faceTex = vec4(
		texture2D(Olive, uv));

  vec4 col = faceTex;

  uv = ogUV;
  uv.x += 0.025;
  uv.y *= 2.0;
  uv.y -= 0.5;

  // uv.y ,size 0.07
  float c = Circle(vec2(uv.x, uv.y + 0.12), 0.04, 0.25);
  col = mix(camTex, col, c);

	gl_FragColor = vec4(col);
}
