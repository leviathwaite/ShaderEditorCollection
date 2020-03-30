#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define PI 3.14159265359

// colors
#define colorBackground vec3(253.0 / 255.0, 253.0 / 255.0, 93.0 / 255.0)
#define colorBlack vec3(0.0)
#define colorHair vec3(0.659, 0.894, 1.0)
#define colorSkin vec3(227.0 / 255.0, 211.0 / 255.0, 195.0 / 255.0)
#define colorShirt vec3(0.659, 0.94, 1.0)


uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D Rick;

mat2 Rotate2D(float _angle)
{
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float sdLineSegmentRounded(vec2 uv, vec2 a, vec2 b, float lineWidth)
{
	 uv *= 10.0;
	  vec2 pa = uv-a, ba = b-a;
    float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
    // return length( pa - ba*h ) - lineWidth*0.5;
    float line = length( pa - ba*h ) - lineWidth*0.5;
    line = smoothstep(line, line - lineWidth, 0.1);

    return line;
}

float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

float Band(float pos, float width)
{
	float halfWidth = width * 0.5;
	return step(-halfWidth, pos) - step(halfWidth, pos);
}

// uses 2 bands
float Rectangle(vec2 pos, float width, float height)
{
	return Band(pos.x, width) * Band(pos.y, height);
}

float RoundedSquare(vec2 uv, vec2 pos, vec2 size, float radius, float thickness)
{
 	float d = length(max(abs(uv - pos),size) - size) - radius;
 	return smoothstep(0.55, 0.45, abs(d / thickness) * 5.0);
}

float RoundedRectangle (vec2 uv, vec2 pos, vec2 size, float radius, float thickness)
{
  float d = length(max(abs(uv - pos),size) - size) - radius;
  return smoothstep(0.66, 0.33, d / thickness * 5.0);
}

float RotatedRectangle(vec2 st, vec2 size, float angle)
{
	st = Rotate2D(angle) * st;
	return Rectangle (st, size.x, size.y);

}

float Triangle(vec2 p)
{
	p.x *= 2.5; // Controls the width
	p.x = abs(p.x); // makes it simetrical
	p.y += 0.0; // moves y location/height
	float tri = max(3.0 * p.x + p.y, 1.0 - 1.5 * p.y);
	return (smoothstep(1.01, 1.0, tri));
}

float RotatedTriangle(vec2 uv, float angle)
{
	uv = Rotate2D(angle) * uv;
	return Triangle(uv);
}

// make 2d version
float DistanceToLineSegment(vec3 p, vec3 a, vec3 b)
{
	vec3 pa = p - a, ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return length( pa - ba*h );
}


float SpikeyCircle(vec2 p, float points)
{
	 vec2 st = vec2(atan(p.x, p.y + 0.1), length(p));

	// float t = mod(st.x, 0.05);
	// float t = st.x + st.y * 5.0;
	float t = 1.0 - st.y * 0.2;

	st = vec2(st.x / 6.2831 + 0.5 * t, st.y);

	float x = st.x * points;
	float m = min(fract(x), fract(1.0 - x));
	float spikeLength = 0.7 - st.y;
	float centerRadius = 0.25;
	float c = smoothstep(0.0, 0.02, m * spikeLength + centerRadius - st.y);


	return c;

}

float DrawHair(vec2 st, vec2 pos)
{
	// translate
	pos.x -= 0.5;
	pos.y -= 0.1;
	// scale
	pos *= 3.;
	// scale height
	pos.y *= 0.7;

	float r = length(pos) * 2.5 - 0.5;
	float a = atan(pos.y, pos.x);

	// best hair
	float f = (1.0 - sin(mod(a * 7.0, 4.14 * (0.85)) + a * 0.1) * 0.45) * st.y - 0.03;

	return 1.0 - smoothstep(f, f + 0.02, r);
}

float DrawShirt(vec2 st)
{
	st.x -= 0.04;
	st.y -= 0.168;
	st.x *= 2.0;
	return Circle(st, 0.09, 0.001);
}

float DrawNeck(vec2 st)
{
	st.x -= 0.037;
	st.y -= 0.281;
	return Circle(vec2(st.x * 2.0, st.y), 0.04, 0.001);
}

float DrawCoat(vec2 st)
{
	st.x -= 0.035;
	st.y -= 0.15;
	vec2 size = vec2(0.2, 0.1);
	float rect = RotatedRectangle(st, size, 45.0);
	rect += RotatedRectangle(st, size, -45.0);
	st.x += 0.0;
	size.x *= 0.97;
	size.y *= 1.15;
	rect += RotatedRectangle(st, size, 0.0);
	return rect;

  // vec2 b = vec2(0.2, 0.2);
  // float r = 0.0;

  // return length(max(abs(st)-b,0.0))-r;
}

float DrawLapels(vec2 uv)
{
	uv.y -= 0.05;
	  float lapels = RotatedTriangle(vec2(uv.x += 0.005, uv.y) * 4.0, -0.1);
    lapels += RotatedTriangle(vec2(-uv.x + 0.12, uv.y - 0.0) * 4.0, -0.25);
    return lapels;
}

float DrawFace(vec2 st)
{

	vec2 faceuv = Rotate2D( 9.7) * st; // * originuv;
  faceuv *= 1.15;
  float face = Circle(vec2(faceuv.x * 1.75 + 0.24, faceuv.y + 0.44), 0.15, 0.001);
  return face;

}

float DrawEyes(vec2 st, float radius)
{
	st.x += 0.032;
	st.y -= 0.43;
	float eyes = Circle(st, radius, 0.001);
	st.x -= 0.0625;
	st.y -= 0.02;
	eyes *= Circle(st, radius, 0.001);
	return eyes;
}

float DrawPupils(vec2 uv)
{
	uv.x += 0.03;
	uv.y -= 0.43;
	uv *= 40.0;

	return SpikeyCircle(uv, 10.0);
}

float DrawEyeLids(vec2 uv)
{
	return 0.0;
}

float DrawNose(vec2 st, vec2 size)
{
	// make nose wider at top

	st.x -= 0.015;
	st.y -= 0.395;
	size.x += st.y * 0.2;
	float nose = RotatedRectangle(st, size, 0.05);
	st.x -= 0.001;
	st.y += 0.015;
	nose = min(1.0 - nose,Circle(st, size.x * 0.5, 0.001));
	return nose;
}

float DrawMouth(vec2 uv)
{
	return 0.0;
}

float DrawVomit(vec2 uv)
{
	return 0.0;
}



float DrawWrinkles(vec2 uv)
{
	uv.x += 0.003;
	uv.y -= 0.537;
	  // sine wave dynamic with time
    float m = sin(0.90 + uv.x * -10.0) * 0.1;
    uv.y +=0.6 * m;
    uv.x+=0.01;

    float wrinkles = RotatedRectangle(uv, vec2(0.07, 0.0025), 0.0);
    uv.x -= 0.0;
    uv.y -= 0.01;
    wrinkles += RotatedRectangle(uv, vec2(0.037, 0.0025), 0.0);
    uv.x += 0.01 + sin(uv.x);
    uv.y += 0.10;
    wrinkles += RotatedRectangle(uv, vec2(0.037, 0.0025), 0.0);
    uv.x -= 0.07;
    uv.y += 0.005;
    wrinkles += RotatedRectangle(uv, vec2(0.037, 0.0025), 0.0);


    return wrinkles;
}


float DrawEyeBrow(vec2 uv)
{
	uv = Rotate2D(0.2) * uv;
	// position
	uv.x -= 0.09;
	uv.y -= 0.38;
	// curve
	uv.y -= uv.x * uv.x * 4.0;
	// end points
	vec2 a = vec2(0.4, 0.9);
  vec2 b = vec2(-0.4, 0.9);
  // line width
  float lWidth = 0.01;
  float rLine = sdLineSegmentRounded(uv, a, b, lWidth);
  return rLine;
}


void main(void) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 originuv = uv;

  uv -= 0.5;
	uv.y *= resolution.y / resolution.x;
  uv *= 0.5;
  uv.y += 0.25;


	vec2 p = (2.0 * gl_FragCoord.xy - resolution) / resolution.y;
  vec2 center = p;
  /*

  // float angle = mod(atan(p.y, p.x), 0.01);
  float angle = 0.0 / (2.0 * 3.14);
  // float radius = 0.25;
  // p += vec2(radius * cos(angle), radius * sin(angle));

  // move space from the center to the vec2(0.0)
  // p -= vec2(0.5);
  // rotate the space
  // st = rotate2d( sin(u_time)*PI ) * st;
  // p = rotate2d(45.0) * p;
  // p = center;
  p = rotate2d(angle) * center;
  // move it back to the original place
  // p += vec2(0.5);
 // p.x += 0.5;
 // p.y += 0.5;

  // float d = triangle(vec2(p.x * 2.5, p.y * 3.0));
  vec3 col = texture2D(Rick, uv).rgb;
  // col += vec3(smoothstep(1.01, 1.0, d));

  float sc = spikeycircle(p, 12.0);

  // hair
  vec4 hairColor = vec4(0.4, 0.6, 0.85, 1.0);
  vec4 color = mix(vec4(col, 1.0), hairColor, sc);


  //hair
 // uv.y+=0.08;
 // uv.x*=1.2-uv.y*0.5;
 vec2 huv = p;
 huv *= 2.0;
 huv.x *= 0.5;
 huv.y *= 0.5;
 float r = mod(cos(atan(huv.y, huv.x) * 40.0 + 0.1 * sin(time) * 100.0), floor((huv.x * huv.x + huv.y * huv.y) * 10.0) * 0.2);
 // float r = 0.035 + 0.1*cos( -atan(huv.y,huv.x)*10.0 + 20.0*huv.x + 13. +huv.y)*0.6 +huv.y*0.3;
 // if(length(p)-0.3 <r) col=vec3(.74,.96,1.);
 // if(length(p)-0.3 <r && length(p)-r>0.295) col=vec3(0.);
 // uv.y-=0.08;
  vec4 hColor; // = vec4(0.74, 0.96, 1.0, 1.0);
  // hColor = vec4(1.0);

  // color = mix(hColor, color, r);
  // color = hColor * r * 10.1;

  // better hair
  float rad = length(huv) * 2.0;
  float ang = atan(huv.y, huv.x);

  float h = (1.0 - sin(mod(ang * 3.0, 3.14)) * 0.5);

  hColor = vec4(vec3(1.0 - smoothstep(h, h + 0.02, rad)), 1.0);
  color = mix(hColor, color, h * 2.0);
  vec4 black = vec4(vec3(0.0), 1.0);

  // color = mix(black, hColor, h * 2.0);

  // face
  p.y += 0.1;
  float face = Circle(vec2(p.x, p.y * 0.65), 0.2, 0.01);
  vec4 faceColor = vec4(5.0, 3.0, 7.0, 1.0);
  // color = mix (faceColor, color, face);

  // eyes
  float eyeRadius = 0.06;
  vec2 eyePos = vec2(p.x + eyeRadius, p.y);

  vec4 eyeColor = vec4(vec3(0.0), 1.0);
  float eyeBall = Circle(eyePos, eyeRadius, 0.01);
  // color = mix(eyeColor, color, eyeBall);
  */
  // Background
  vec3 color = colorBackground;

  // Hair Outline
  color = mix(color, colorBlack, DrawHair(uv, vec2(0.5) - uv));
  // Hair
  color = mix(color, colorHair, DrawHair(uv * 0.95, vec2(0.5) -uv));


  // Coat Outline
  color = mix(color, colorBlack, DrawCoat(uv));
  // Coat
  color = mix(color, vec3(1.0), DrawCoat(uv * 1.01));

  // Inner Shirt
  color = mix(colorShirt, color, DrawShirt(uv));

  color = mix(color, vec3(0.0), DrawLapels(uv));
  color = mix(color, vec3(1.0), DrawLapels(uv * 1.01));

  // Neck
  color = mix(colorBlack, color, DrawNeck(uv));
  color = mix(colorSkin, color, DrawNeck(uv * 0.99));


  // Face Outline
  color = mix(colorBlack, color, DrawFace(uv));
  // Face
  color = mix(colorSkin, color, DrawFace(vec2(uv.x * 1.02, uv.y * 1.002 - 0.001)));

  // Eyes Outline
  color = mix(vec3(0.0), color, DrawEyes(uv, 0.03));
  color = mix(vec3(1.0), color, DrawEyes(uv, 0.0295));

  // nose
  color = mix(vec3(0.0), color, DrawNose(uv, vec2(0.02, 0.03)));
  color = mix(colorSkin, color, DrawNose(uv, vec2(0.018, 0.04)));

  // pupils
  color = mix(color, vec3(0.0), DrawPupils(uv));


  color = mix(color, vec3(0.0), DrawWrinkles(uv));
  // test uv position
  // color = mix(color, colorBlack, Circle(uv, 0.2, 0.01));

  color = mix(vec3(0.0), color, DrawEyeBrow(uv));


  gl_FragColor = vec4(color, 1.0);

}
