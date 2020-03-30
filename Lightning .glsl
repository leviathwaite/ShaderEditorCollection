#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif



uniform float time;
uniform vec2 resolution;

const float count = 17.0; // 17.0
const float speed = 2.0; // 5.0

float Hash(vec2 p, in float s)
{
vec3 p2 = vec3(p.xy, 27.0 * abs(sin(s)));
    // return fract(sin(dot(p2, vec3(27.1, 61.7, 12.4))) * 273758.5453123);
    return fract(sin(dot(p2, vec3(27.1, 61.7, 12.4))) * 2.1);
}

float Noise(in vec2 p, in float s)
{
vec2 i = floor(p);
    vec2 f = fract(p);
    f *= f * (3.0 - 2.0 * f);
   
    return mix(mix(Hash(i + vec2(0.0, 0.0), s), Hash(i + vec2(1.0, 0.0), s), f.x),
               mix(Hash(i + vec2(0.0, 1.0), s), Hash(i + vec2(1.0, 1.0), s), f.x), f.y) * s;
}

float fbm(vec2 p)
{
    float v = 0.0;
    v += Noise(p * 1.0, 0.35);
    v += Noise(p * 2.0, 0.25);
    // v += noise(p * 4.0, 0.,125);
    v += Noise(p * 8.0, 0.0625);
    return v;
}

void main()
{
    float worktime = time * speed;
   
    vec2 uv = (gl_FragCoord.xy / resolution.xy) * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;
   
    // test
    // uv.x = -uv.x;;
   
   
    vec3 finalColor = vec3(0.0);
/*
    for(float i = 1.0; i <= count; ++i)
    {
    float t = abs(1.0 / ((uv.x + fbm(uv + worktime / i)) * (i * 55.0)));  
        finalColor += t * vec3(i * 0.075 + 0.1, 0.5, 2.0);
    }
*/
   
    // test
    uv.x -= -0.2;
    uv.x = -uv.x;
    float tempX = uv.x;
    uv.x = sin(uv.y + time * 2.0);
    uv.y = tempX;
   
/*
   
    // finalColor = vec3(0.0);
   
    for(float i = 1.0; i <= count; ++i)
    {
    float t = abs(1.0 / ((uv.x + fbm(uv + worktime / i)) * (i * 55.0)));  
        finalColor += t * vec3(i * 0.075 + 0.1, 0.5, 2.0);
    }
*/
   
    uv.x = -uv.x;
    uv.x += - uv.y;

    for(float i = 1.0; i <= count; ++i)
    {
    float t = abs(1.0 / ((uv.x + fbm(uv + worktime / i)) * (i * 55.0)));  
        finalColor += t * vec3(i * 0.075 + 0.1, 0.5, 2.0);
    }
   
    /*
    // mouse position
    float i = 1.0;
    float width = 5.0; // reversed - 500 thin, 50 normal, 5 thick
    float t = abs(1.0 / ((uv.x + fbm((uv) + worktime / i)) * (0.1 * 50.0)));  
    finalColor += t * vec3(i * 0.075 + 0.1, 0.5, 2.0);
    */
   
    gl_FragColor = vec4(finalColor, 1.0);
}


