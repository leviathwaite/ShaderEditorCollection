#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

float sdfStar5( in vec2 p )

{
    // repeat domain 5x
    // const vec2 k1 = vec2(0.809016994375, -0.587785252292); // pi/5

    const vec2 k1 = vec2(3.14/4.0, -(3.14 / 5.5)); // pi/5

    const vec2 k2 = vec2(-k1.x,k1.y);
    p.x = abs(p.x);
    p -= 2.0*max(dot(k1,p),0.0)*k1;
    p -= 2.0*max(dot(k2,p),0.0)*k2;

    // draw triangle
    const vec2 k3 = vec2(0.951056516295,  0.309016994375); // pi/10
    return dot( vec2(abs(p.x)-0.3,p.y), k3);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

    // coords
    float px = 2.0/resolution.y;

    vec2 q = (2.0*gl_FragCoord.xy-resolution.xy)/resolution.y;

    // move in a circle
    // q.x += cos(time * 2.0) * 0.2;
    // q.y -= sin(time * 2.0) * 0.2;

    float t = time;

    // figure 8
    float scale = (2.0 / (3.0 - cos(2.0*t))) * 0.5;
    q.y += (scale * cos(t));
    q.x += (scale * sin(2.0*t) / 2.0);



    // rotate
    q = mat2(cos(time*0.2),sin(time*0.2),-sin(time*0.2),cos(time*0.2)) * q;
    q *= 40.0; // zoom out
	// star shape
	float d = sdfStar5( q );

    // colorize
    vec3 col = vec3(0.4,0.7,0.4) - sign(d)*vec3(0.2,0.1,0.0);
	col *= smoothstep(0.005,0.005+2.0*px,abs(d));
  //col *= smoothstep(0.04,0.04+2.0*px,abs(d+0.1));
	col *= 1.1-0.2*length(q);



	gl_FragColor = vec4(col, 1.0);
}
