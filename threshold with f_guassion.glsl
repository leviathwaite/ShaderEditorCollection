#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	/*Tresholding*/ // 0.0 to 1.0 range
		float threshold = sin(time) * 0.5 + 0.5; // 0.03;
   
    vec3 col =texture2D(Girls,uv).xyz;
   
    vec3 X = texture2D(Girls, uv + col.xy ).rgb;
    vec3 Y = texture2D(Girls, uv - col.xy ).rgb;
   
// Todo replace ifs with step
    if(col.z> threshold && col.z> X.z && col.z > Y.z){
    col = vec3(1.f);
    }
    else{
    col = vec3(0.f);
    }
   
    gl_FragColor = vec4(col, 1.f);
       

}
