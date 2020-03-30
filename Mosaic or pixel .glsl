#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D Girls;

const float mosaic = 10.0;

// https://gist.github.com/Volcanoscar/424c56f62c4abc167038b76b520e22ad

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;


vec4 color = vec4(0.0);

vec2 offset = vec2(mod(gl_FragCoord.x, mosaic),
	mod(gl_FragCoord.y, mosaic));


for (float x = 0.0; x < mosaic; x++){

for (float y = 0.0; y < mosaic; y++){

color += texture2D(Girls, uv - (offset + vec2(x, y)) / resolution);

}

}

gl_FragColor = color / pow(mosaic, 2.0);

}



