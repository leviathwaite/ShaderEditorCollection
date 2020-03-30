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

vec2 movingTiles(vec2 _st, float _zoom, float _speed){
    _st *= _zoom;
    float t = sin(time*_speed);
    if( fract(t)>0.5 ){
        if (fract( _st.y * 0.5) > 0.5){
            _st.x += fract(t)*2.0;
        } else {
            _st.x -= fract(t)*2.0;
        }
    } else {
        if (fract( _st.x * 0.5) > 0.5){
            _st.y += fract(t)*2.0;
        } else {
            _st.y -= fract(t)*2.0;
        }
    }
    return fract(_st);
}

float circle(vec2 _st, float _radius){
    vec2 pos = vec2(0.5)-_st;
    return smoothstep(1.0-_radius,1.0-_radius+_radius*0.2,1.-dot(pos,pos)*3.14);
}

void main(void){
    // vec2 st = gl_FragCoord.xy/resolution.xy;

    vec3 color = vec3(0.0);

	  float mx = max(resolution.x, resolution.y);
	  vec2 st = gl_FragCoord.xy / mx;
	  // st.x += 0.25;
	  st *= 2.0;
	  // st.y = step(1.0,mod(st.y,2.0));

	  vec2 uv = st;

    // Divide the space in 4
    st = tile(st,4.0);

    uv.x += 0.125;
    uv.y += 0.125;
    uv = tile(uv, 4.);
    // cuts small square in half
    // uv *= 0.5;

    uv = movingTiles(uv, 1.0, 0.5);

    // Use a matrix to rotate the space 45 degrees
    uv = rotate2D(uv,PI*0.25);

    // Draw a square
    vec3 col = vec3(movingTiles(uv, 1.0, 0.5), sin(time));
    color = vec3(box(st,vec2(0.99),0.01));
    color = mix(color, col, box(uv, vec2(0.2), 0.01));
    // color = vec3(st,0.0);



    gl_FragColor = vec4(color,1.0);
}