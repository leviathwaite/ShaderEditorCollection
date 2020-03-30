#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define PI 3.14159265359

const int numberOfSteps = 20;
const float scaleFactor = .85;
const float outlineThicknessFactor = 0.5;
const vec3 outlineColor1 = vec3(1.0, 1.0, 0.0);
const vec3 outlineColor2 = vec3(1.0, 0.0, 1.0);


mat2 Rotate2D(float _angle)
{
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}




mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}



float rect(vec2 p, vec2 size)
{
  vec2 d = abs(p) - size;
  return min(max(d.x, d.y), 0.0) + length(max(d,0.0));
}

float rectOutline(vec2 p, vec2 size)
{
	float squareOutline = rect(p, size);
  squareOutline = smoothstep(0.01, 0.02, squareOutline);

  vec2 outlineMaskSize = vec2(0.8 * outlineThicknessFactor,
  	0.4 * outlineThicknessFactor);
  float squareMask = rect(p, vec2(outlineMaskSize));
  squareMask = smoothstep(0.01, 0.02, squareOutline);
  squareOutline = squareOutline + (1.0 - squareMask);
  return squareOutline;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	// uv -= 0.5;
	//
	uv *= resolution.y / resolution.x;

  vec3 col = vec3(0.0);


  uv -= 1.0;

  // uv = rotate2D(uv, 45.0);

  uv = rotate2d( -(time * 0.1)*PI) * uv;
  // uv.x -= 0.5;

  vec2 size = vec2(1.1, 1.1);

  float sOutline = rectOutline(vec2(uv.x, uv.y), size);
  // float sOutline = rectOutline(vec2(uv.x, uv.y), size);

  float t = sin(time) * 0.5 + 0.5;
  vec3 outlineColor = mix(outlineColor1, outlineColor2, t);


  col = mix(outlineColor, col, sOutline);
  for(int i = 0; i < numberOfSteps; i++)
  {


    size *= scaleFactor;
    uv = rotate2d(1.75) * uv;

    float sOutline1 = rectOutline(vec2(uv.x, uv.y), size);
    // float sOutline1 = rectOutline(vec2(uv.x, uv.y), size);



  outlineColor = mix(outlineColor1, outlineColor2, float(i) * t);


    col = mix(outlineColor, col, sOutline1);
  }

	// transform.scale(0.8);
	// transform.rotate(framenumber / 200);
	// square();

	gl_FragColor = vec4(col, 1.0);
}
