#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

void main(void) {
	vec2 st = gl_FragCoord.xy/resolution.xy;


  float mx = max(resolution.x, resolution.y);
	vec2 uv = gl_FragCoord.xy / mx;
	uv -= 0.5;

	// uv.x -= 0.25;
	// uv.y -= 0.5;

	// uv = rotate2D(st , time * 0.5);

	uv = gl_FragCoord.xy / resolution.xy;
	uv -= 0.5;
	uv.y *= resolution.y / resolution.x;

	uv = rotate2D(uv -= 0.5, time * 0.5);


  float d = 0.02 / length(uv);
	// vec3 col = vec3(d);
	vec3 col = vec3(1.0 - abs(uv.x));


	gl_FragColor = vec4(col, 1.0);
}
