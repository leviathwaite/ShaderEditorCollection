#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec3 pointers[10];
uniform sampler2D noise;
uniform int pointerCount;

// ray marching
const int max_iterations = 512;
const float stop_threshold = 0.001;
const float grad_step = 0.02;
const float clip_far = 1000.0;

// math
const float PI = 3.14159265359;
const float DEG_TO_RAD = PI / 180.0;

float sdBox( vec3 p, vec3 b )
{
	vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

//get distance in the world
float dist_field( vec3 p ) {
//  p = sdRep( p, vec3( 4.0 ) );
//  p = sdTwist( p, 3.0 );

    float d0 = sdBox( p, vec3(0.5) );
    // float d1 = sdSphere( p, 0.6 );

    // float d = sdInter( d1, d0 );

    return d0; // d;
    //return d + sfDisp( p * 2.5 );
    //return sdUnion_s( d + sfDisp( p * 2.5 * sin( iTime * 1.01 ) ), d1, 0.1 );
}

// get gradient in the world
vec3 gradient( vec3 pos ) {
	const vec3 dx = vec3( grad_step, 0.0, 0.0 );
	const vec3 dy = vec3( 0.0, grad_step, 0.0 );
	const vec3 dz = vec3( 0.0, 0.0, grad_step );
	return normalize (
		vec3(
			dist_field( pos + dx ) - dist_field( pos - dx ),
			dist_field( pos + dy ) - dist_field( pos - dy ),
			dist_field( pos + dz ) - dist_field( pos - dz )
		)
	);
}

float sdInter( float d0, float d1 ) {
    return max( d0, d1 );
}




// get ray direction
vec3 ray_dir( float fov, vec2 size, vec2 pos )
{
	vec2 xy = pos - size * 0.5;

	float cot_half_fov = tan( ( 90.0 - fov * 0.5 ) * DEG_TO_RAD );
	float z = size.y * 0.5 * cot_half_fov;

	return normalize( vec3( xy, -z ) );
}


// ray marching
bool ray_marching( vec3 o, vec3 dir, inout float depth, inout vec3 n ) {
	float t = 0.0;
    float d = 10000.0;
    float dt = 0.0;
    for ( int i = 0; i < 128; i++ ) {
        vec3 v = o + dir * t;
        d = dist_field( v );
        if ( d < 0.001 ) {
            break;
        }
        dt = min( abs(d), 0.1 );
        t += dt;
        if ( t > depth ) {
            break;
        }
    }

    if ( d >= 0.001 ) {
        return false;
    }

    t -= dt;
    for ( int i = 0; i < 4; i++ ) {
        dt *= 0.5;

        vec3 v = o + dir * ( t + dt );
        if ( dist_field( v ) >= 0.001 ) {
            t += dt;
        }
    }

    depth = t;
    n = normalize( gradient( o + dir * t ) );
    return true;

    return true;
}

// camera rotation : pitch, yaw
mat3 rotationXY( vec2 angle ) {
	vec2 c = cos( angle );
	vec2 s = sin( angle );

	return mat3(
		c.y      ,  0.0, -s.y,
		s.y * s.x,  c.x,  c.y * s.x,
		s.y * c.x, -s.x,  c.y * c.x
	);
}

void main(void)
{


	vec2 uv = gl_FragCoord.xy / resolution.xy;

	// default ray dir
	vec3 dir = ray_dir( 45.0, resolution.xy, gl_FragCoord.xy );

	// default ray origin
	vec3 eye = vec3( 0.0, 0.0, 3.5 );

	// rotate camera
	mat3 rot = rotationXY( ( pointers[0].xy - resolution.xy * 0.5 ).yx * vec2( 0.01, -0.01 ) );
	dir = rot * dir;
	eye = rot * eye;

	// ray marching
    float depth = clip_far;
    vec3 n = vec3( 0.0 );
	if ( !ray_marching( eye, dir, depth, n ) ) {

		gl_FragColor = vec4(texture2D(noise, dir.xy, 1.0));


		// gl_FragColor = vec4(texture2D( noise, dir ));
        return;
	}

	// shading
	vec3 pos = eye + dir * depth;

    vec3 color = shading( pos, n, dir, eye );
	fragColor = vec4( pow( color, vec3(1.0/1.2) ), 1.0 );
}

	gl_FragColor = vec4(uv, 1.0, 1.0);


}
