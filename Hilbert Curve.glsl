#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif



// https://www.shadertoy.com/view/MdXcWn



/* This shader is based on https://www.shadertoy.com/view/XljSW3,
 * but I have been refactoring the code in order to understand it
 * better.
 */

/* The following page provides a good reference, but be careful that the
 * diagram is upside-down relative to what is implemented here.
 *
 *  https://www.fractalus.com/kerry/tutorials/hilbert/hilbert-tutorial.html
 */


uniform vec2 resolution;



#define swap(a,b) tmp=a; a=b; b=tmp;

float plot(in vec2 U, in vec2 dir, in float s) {
    vec2 perpendicular = vec2(-dir.y,dir.x);
    float thickness    = .7*s/resolution.y;

    if( dot(U,dir) > 0. ) {
        return 1. - step(thickness, abs(dot(U,perpendicular)));
    } else {
return 0.;
    }
}
         
// symU and rotU apply to vectors that range from 0 to 1
void symU(inout vec2 u) {
    u.x = 1.-u.x;
}

void rotU(inout vec2 u) {
    u.xy = vec2(u.y,1.-u.x);
}


// symV and rotV apply to unit vectors that range from -1 to 1

void symV(inout vec2 v) {
    v.x= -v.x;
}

void rotV(inout vec2 v) {
    v.xy = vec2(v.y,-v.x);
}

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

    const bool  paintQuads = false;
    const float iter       = 4.;
   
    vec2 U = uv;
    // U /= resolution.y;
   
    // Horizontal offset to center the figure
    // U.x -= 0.3;
   
    vec2 P = vec2(.5);
    vec2 I = vec2(1,0);
    vec2 J = vec2(0,1);
   
   
    // l controls the entry into the Hilbert curve.
    // Set to J to enter from the top; -I to enter from
    // the left
    vec2 l = -I;
   
    // r initially has no value, but gets updated
    // inside the loop.
    vec2 r;
   
    vec2 qU;
vec2 tmp;
   
    for (float i = 0.; i < iter; i++) {
        qU      = step(.5,U);         // select quadrant
        bvec2 q = bvec2(qU);          // convert to boolean
       
        U       = 2.*U - qU;          // go to new quadrant
       
        // qU:               q:
        //      0,1  | 1,1      f,t | t,t
        //     ------|-----    -----------
        //      0,0  | 1,0      f,f | t,f
       
        // l and r are adjusted based on quadrant, but I
        // don't quite understand how they work.
        //
        // l:                r:
        //       l  | -J       -J |  I
        //     -----|-----    ----------
        //       J  | -I        I |  J
       
        l = q.x ? (q.y ? -J : -I)            // node left segment
                : (q.y ?  l :  J);
                   

        r = (q.x==q.y)?  I : (q.y ?-J:J);    // node right segment
       
        // the heart of Hilbert curve :
        if (q.x) { // sym
        symU(U);
            symV(l);
            symV(r);
            swap(l,r);
        }
        if (q.y) { // rot+sym
            rotU(U); symU(U);
            rotV(l); symV(l);
            rotV(r); symV(r);
        }
    }
   
    // s controls the line thickness, it must
    // increase with iter to keep it invariant
    // to scale.
    float s=pow(2., iter);

    vec4 o  = vec4(0.0);
    o += plot (U-P, l, s) * vec4(1.,0.25,0.25,1.);
    o += plot (U-P, r, s);
   
// Paint different quadrants:
    //
    //    blue   |  cyan
    //    ---------------
    //    black  |  green
   
    if(paintQuads) {
    o += vec4(0., qU.x, qU.y,1.) * 0.15;
    }

  gl_FragColor = vec4(o);

	// gl_FragColor = vec4(uv, 1.0, 1.0);
}
