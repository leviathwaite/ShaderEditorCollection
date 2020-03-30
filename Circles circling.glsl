#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

 //Author @patriciogv ( patriciogonzalezvivo.com ) - 2015
	//#ifdef GL_ESprecision mediump float;
	//#endif uniform vec2 u_resolution;
	//uniform float u_time;
	#define PI 3.14159265359




uniform vec2 resolution;
uniform float time;

float concentricCircles(in vec2 st, in vec2 radius, in float resolution, in float scale)
	{
		float dist = distance(st,radius);
		float pct = floor(dist*resolution)/scale;
		return pct;
	}

	float circle(in vec2 _st, in float _radius)
	{
		vec2 dist = _st-vec2(0.5);
		return 1.-smoothstep(_radius-(_radius*0.001), _radius+(_radius*0.001), dot(dist,dist)*50.0);
	}


void main(void) {
	vec2 st = gl_FragCoord.xy/resolution.xy;
	vec2 st2 = gl_FragCoord.xy/resolution.xy;
	vec2 st3 = gl_FragCoord.xy/resolution.xy;
	vec2 st4 = gl_FragCoord.xy/resolution.xy;
	vec3 crossColor = vec3(0.0);
	vec3 circleColor = vec3(0.0);
	float radialColor = float(0.0);
	float blink = sqrt((abs(sin(time))))/50.0 + 0.01;
	radialColor += concentricCircles(st,vec2(0.5,0.5), 10.0, 30.0);
	// To move the cross we move the space
	vec2 translate = vec2(cos(time),sin(time));
	vec2 translate2 = vec2(cos(time-100.0),sin(time-100.0));
	vec2 translate3 = vec2(cos(time-200.0),sin(time-200.0));
	vec2 translate4 = vec2(cos(time-400.0),sin(time-400.0));
	st += translate*0.35;
	st2 += translate2*0.25;
	st3 += translate3*0.15;
	st4 += translate3*0.05;
	circleColor += vec3(circle(st,blink));
	circleColor += vec3(circle(st2,blink/2.0));
	circleColor += vec3(circle(st3,blink/4.0));
	circleColor += vec3(circle(st4,blink/8.0));
	// circleColor += concentricCircles(st,vec2(0.5,0.5), 6.0, 30.0);
	// Show the coordinates of the space on the background
	// color = vec3(st.x,st.y,0.0);
	// Add the shape on the foreground
	gl_FragColor = vec4(circleColor.x+crossColor.x,circleColor.x+radialColor,0.0,1.0);
	}