#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

// https://gist.github.com/Volcanoscar/9c4cfd46b5091a7434ffac958f3a95ea

uniform vec2 resolution;
uniform sampler2D Girls;

const int mode = 2;
const float division = 0.5;

void main(void) {
	vec2 uv = gl_FragCoord.xy / resolution.xy;

	if(mode == 0) {

		// Bypass

			gl_FragColor = texture2D(Girls, uv);

	} else if(mode == 1) {

		// Horizontal Mirror, Favor Left

		if(uv.x > division) {

			highp vec2 samplePos = vec2((division * 2.0) - uv.x, uv.y);

			gl_FragColor = texture2D(Girls, samplePos);

		} else {

			gl_FragColor = texture2D(Girls, uv);

		}

	} else if(mode == 2) {

		// Horizontal Mirror, Favor Right

		if(uv.x < division) {

			highp vec2 samplePos = vec2((division * 2.0) - uv.x, uv.y);

			gl_FragColor = texture2D(Girls, samplePos);

		} else {

			gl_FragColor = texture2D(Girls, uv);

		}

	} else if(mode == 3) {

		// Vertical Mirror, Favor Bottom

		if(uv.y > division) {

			highp vec2 samplePos = vec2(uv.x, (division * 2.0) - uv.y);

			gl_FragColor = texture2D(Girls, samplePos);

		} else {

			gl_FragColor = texture2D(Girls, uv);

		}

	} else if(mode ==4) {

		// Vertical Mirror, Favor Top

		if(uv.y < division) {

			highp vec2 samplePos = vec2(uv.x, (division * 2.0) - uv.y);

			gl_FragColor = texture2D(Girls, samplePos);

		} else {

			gl_FragColor = texture2D(Girls, uv);

		}

	}


}



