#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;

#define PI 3.14159265359

uniform vec2 u_mouse;
uniform float u_time;

float Circle(vec2 pos, float radius, float blur)
{
	return smoothstep(radius, radius + blur, length(pos));
	// return length(pos);
}

float plot(vec2 st, float pct)
{
  return  smoothstep( pct-0.01, pct, st.y) -
          smoothstep( pct, pct+0.01, st.y);
}

void main(void)
{
    vec2 st = gl_FragCoord.xy / resolution;
    st -= 0.5;
	  st.y *= resolution.y / resolution.x;

    float y = pow(st.x,2.0);

    y = mod(st.x, 0.1); // return x modulo of 0.5
    // y = fract(st.x * 5.0); // return only the fraction part of a number
    // y = ceil(st.x);  // nearest integer that is greater than or equal to x
    // y = floor(st.x); // nearest integer less than or equal to x
    // y = sign(st.x);  // extract the sign of x
    // y = abs(st.x);   // return the absolute value of x
    // y  = clamp(st.x, 0.0,1.0); // constrain x to lie between 0.0 and 1.0
    // y = min(0.0,st.x);   // return the lesser of x and 0.0
    // y = max(sin(st.x), y) * 2.0;   // return the greater of x and 0.0

    vec3 color = vec3(0.0);

    // float plotX = plot(sin(st) * 0.2, y);

    // float pct = plot(st,y);
    // color += pct * vec3(0.0, 1.0, 0.0);

    float pct1 = plot(st, y);
    color += pct1 * vec3(0.0, 1.0, 0.0);


    pct1 = plot(st, -y);
    color += pct1 * vec3(0.0, 1.0, 0.0);

    // color = (1.0-pct)*color+pct*vec3(0.0,1.0,0.0);

    // float l = Circle(st, 0.1, 0.01);
    // color = vec3(l);

    // float angleLine = plot(st, atan(st.y, st.x));
    // color = vec3(angleLine);

    gl_FragColor = vec4(color,1.0);
}

