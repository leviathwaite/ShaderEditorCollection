#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define PI 3.14159265358979323846

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

vec2 tile(vec2 _st, float _zoom){
    _st *= _zoom;
    return fract(_st);
}

float box(vec2 _st, vec2 _size, float _smoothEdges){
    _size = vec2(0.5)-_size*0.5;
    vec2 aa = vec2(_smoothEdges*0.5);
    vec2 uv = smoothstep(_size,_size+aa,_st);
    uv *= smoothstep(_size,_size+aa,vec2(1.0)-_st);
    return uv.x*uv.y;
}

void main(void){
    // vec2 st = gl_FragCoord.xy/resolution.xy;

    vec3 color = vec3(0.0);

	  float mx = max(resolution.x, resolution.y);
	  vec2 st = gl_FragCoord.xy / mx;
	  // st.x += 0.25;
	  st *= 2.0;

	  vec2 uv = st;

    // Divide the space in 4
    st = tile(st,4.0);

    uv.x += 0.125;
    uv.y += 0.125;
    uv = tile(uv, 4.);
    // cuts small square in half
    // uv *= 0.5;

    // Use a matrix to rotate the space 45 degrees
    uv = rotate2D(uv,PI*0.25);

    // Draw a square
    color = vec3(box(st,vec2(0.99),0.01));
    color = mix(color, vec3(0.6), box(uv, vec2(0.2), 0.01));
    // color = vec3(st,0.0);

    gl_FragColor = vec4(color,1.0);
}