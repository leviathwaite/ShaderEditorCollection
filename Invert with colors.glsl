#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://www.shadertoy.com/view/XtfXWS

uniform vec2 resolution;
uniform sampler2D Girls;

vec3 ColourToYPbPr2(vec3 C)
{
  const mat3 Mat = mat3(
    0.299,0.587,0.114,
    -0.168736,-0.331264,0.5,
    0.5,-0.418688,-0.081312);
  return C * Mat;
}

vec3 YPbPrToColour(vec3 YPbPr)
{
  const mat3 Mat = mat3(
    1.0,0.0,1.402,
    1.0,-0.34413,-0.714136,
    1.0,1.772,0.0);
  return YPbPr * Mat;
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;
   
    //remove for video or webcam input    
    // uv = vec2(uv.x,1.0-uv.y);
   
vec3 ta = texture2D(Girls, uv).xyz;
   
    ta = ColourToYPbPr2(ta);
   
    ta.x = 1.0 - ta.x;
   
    ta = YPbPrToColour(ta);    
   
gl_FragColor = vec4(ta,1.0);

} 
