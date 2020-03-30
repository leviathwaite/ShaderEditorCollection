#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

#define SC(a) vec2(sin(a),cos(a))

#define PI 3.1415926


uniform vec2 resolution;
uniform float time;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

    vec2 R = resolution.xy / 2.;

    float t = mod(time,360.),
        pix = 1./R.y; // line thickness            // pixel size
    // center on screen
    vec2 xy = gl_FragCoord.xy;
   	xy = ( xy - R*0.5 ) / R.y;    // normalized coordinates

    //static circle
    // create vec2 named "move" rotations per trip
    vec2 move = SC(t/18.*PI) / 3.;

    vec4 O = vec4(0.0);

    if (    abs(length(xy)     -1./6.) < 2.*pix // stationary circle line thickness
         || abs(length(xy-move)-1./6.) < 2.*pix // moving circle line thickness
       )
        O = vec4(cos(t)/2., 0., .5, 1); // circle colors


    //move circle
    //Cardioid
    for (float i=0.; i<t; i+=.1)
    {
        move =   SC(   i/18.*PI      ) / 3.
               + SC( 2.*i/18.*PI +PI ) / 6.;
        if ( length(xy-move)<3.*pix )  O =vec4(1,0,0,0); // plot line color
    }


	gl_FragColor = O;
}
