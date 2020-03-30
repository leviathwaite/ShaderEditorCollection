#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// tutorial
// http://kylehalladay.com/blog/tutorial/2017/02/21/Pencil-Sketch-Effect.html

// https://www.shadertoy.com/view/ldXfRj

// http://shaderslab.com/demo-99---pencil-effect-1.html

uniform vec2 resolution;
uniform sampler2D Girls;
uniform sampler2D noise;

#define PI2 6.28318530717959
#define STEP 2.0
#define RANGE 16.0
#define ANGLENUM 4.0
#define GRADTHRESH 0.01
#define SENSITIVITY 10.0

#define _ColorThreshold 0.5
// https://www.shadertoy.com/view/ldXfRj
// http://shaderslab.com/demo-99---pencil-effect-1.html

/*
_GradThresh("Gradiant threshold",range(0.000001,0.01))=0.01

    _ColorThreshold("Color Threshold",range(0.0,1))=0.5

*/

 vec4 getCol(vec2 pos)
 {
   return texture2D(Girls, pos);
 }

 float getVal(vec2 pos)
 {
   vec4 c = getCol(pos);
   return dot(c.xyz, vec3(0.2126,0.7152,0.0722));
 }

 vec2 getGrad(vec2 pos,float delta)
 {
   vec2 d = vec2(delta, 0.0);
   return vec2(getVal(pos+d.xy) - getVal(pos-d.xy),
     getVal(pos + d.yx) - getVal(pos - d.yx)) / delta / 2.0;
 }

 vec2 pR(vec2 p,float a)
 {
   return p = cos(a) * p + sin(a) * vec2(p.y, -p.x);
 }

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	// vec2 screenuv = resolution * uv;
  vec2 screenPos = resolution * uv;

  float weight = 0.5;

  for(float j = 0.0; j < ANGLENUM; j++)
  {
    vec2 dir = vec2(1.0, 0.0);

    pR(dir, j * PI2 / (2.0 * ANGLENUM));

    vec2 grad = vec2(-dir.y, dir.x);

    for(float i = -RANGE; i <= RANGE; i += STEP)
    {
      vec2 b = normalize(dir);
      vec2 pos2 = uv + vec2(b.x, b.y) * i;
      // vec2 pos2 = screenPos + vec2(b.x, b.y) * i;


       if(pos2.y<0.0||pos2.x<0.0||pos2.x>resolution.x||pos2.y>resolution.y);
         continue;

       vec2 g = getGrad(pos2,1.0);

       if(sqrt(dot(g, g)) < GRADTHRESH)
         continue;

       weight -= pow(abs(dot(normalize(grad),normalize(g))),SENSITIVITY) / floor((2.0 * RANGE + 1.0) / STEP) / ANGLENUM;

     }

   }

   vec4 col = getCol(uv);
   // vec4 col = getCol(screenPos);
   // vec4 background = lerp(col, vec4(1.0,1.0,1.0,1.0),_ColorThreshold);
   vec4 background = mix(col, vec4(1.0,1.0,1.0,1.0),_ColorThreshold);




   // gl_FragColor = mix(vec4(0.5,0.5,0.5,1.0),background,weight);


   gl_FragColor = col;







	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
