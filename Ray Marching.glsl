#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURF_DIST 0.01

struct Mat
{
    vec3 diffuse;
};

mat2 Rot(float a)
{
 	float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

float smin(float a, float b, float k)
{
 	float h = clamp(0.5 + 0.5*(b-a)/k, 0.0, 1.0);
    return mix(b, a, h) - k*h*(1.0-h);
}

float sdSphere(vec3 p, vec3 s, float r)
{
    return length(p-s.xyz) - r;
}

float sdPlane(vec3 p)
{
 	return p.y;
}

float sdCapsule(vec3 p, vec3 a, vec3 b, float r)
{
    vec3 ab = b-a;
    vec3 ap = p-a;

    float t = dot(ab, ap) / dot(ab, ab);
    t = clamp(t, 0.0, 1.0);

    vec3 c = a + t*ab;
    return length(p - c) - r;
}

float sdCylinder(vec3 p, vec3 a, vec3 b, float r)
{
    vec3 ab = b-a;
    vec3 ap = p-a;

    float t = dot(ab, ap) / dot(ab, ab);
    //t = clamp(t, 0.0, 1.0);

    vec3 c = a + t*ab;

    float x = length(p - c) - r;
    float y = (abs(t-0.5)-0.5)*length(ab);
    float e = length(max(vec2(x,y), 0.0));

    // Make interior distance for cylinder to prevent rippling texture
    float i = min(max(x,y), 0.0);
    return e+i;
}

float sdTorus(vec3 p, vec2 r)
{
 	float x = length(p.xz) - r.x;
    return length(vec2(x, p.y)) - r.y;
}

float sdBox(vec3 p, vec3 s)
{
    float d = length(max(abs(p)-s, 0.0));
    return d;
}

float sdCone(vec3 p, vec3 a, vec3 b, float ra, float rb)
{
    float rba  = rb-ra;
    float baba = dot(b-a,b-a);
    float papa = dot(p-a,p-a);
    float paba = dot(p-a,b-a)/baba;

    float x = sqrt( papa - paba*paba*baba );

    float cax = max(0.0,x-((paba<0.5)?ra:rb));
    float cay = abs(paba-0.5)-0.5;

    float k = rba*rba + baba;
    float f = clamp( (rba*(x-ra)+paba*baba)/k, 0.0, 1.0 );

    float cbx = x-ra - f*rba;
    float cby = paba - f;

    float s = (cbx < 0.0 && cay < 0.0) ? -1.0 : 1.0;

    return s*sqrt( min(cax*cax + cay*cay*baba,
                       cbx*cbx + cby*cby*baba) );
}

float GetDist(vec3 p) {
    float sphereD = sdSphere(p, vec3(3, cos(time)+2.0, 7), 0.5);
    float sphereD2 = sdSphere(p, vec3(-3, sin(time)+2.0, 7.0), 0.75);
    float sphereD3 = sdSphere(p, vec3(-3, cos(time*1.25)+1.25, 3.0), 0.25);
    float planeD = sdPlane(p);

    float capsuleD = sdCapsule(p, vec3(0.0, 1.0, 6.0), vec3(1.0, 2.0, 6.0), 0.2);

    vec3 torusPos = p-vec3(0.0, 1.25, 6.0);
    torusPos.yz *= Rot(time);
    float torusD = sdTorus(torusPos, vec2(1.0, 0.25));

    float sT = smin(capsuleD, torusD, 0.3);

    float torusD2 = sdTorus(p-vec3(-3.0, sin(time*1.25)+1.25, 3.0), vec2(0.3, 0.1));
    float cylD = sdCylinder(p, vec3(1.0, 0.3, 2.5), vec3(3.0, 0.3, 3.5), 0.2);
    float coneD = sdCone(p, vec3(-0.75,0.95,3.5), vec3(-1.75,1.95,3.5), 0.5, 0.01);

    float d = min(sphereD, planeD);
    d = min(d, sphereD2);
    d = min(d, sphereD3);
    d = min(d, capsuleD);
    d = min(d, torusD);
    d = min(d, torusD2);
    d = min(d, cylD);
    d = min(d, coneD);

    return d;
}

Mat matTest(Mat m, float s, Mat b)
{
    m.diffuse += b.diffuse * s;

    return m;
}

Mat GetMat(vec3 p) {

    float sphereD = sdSphere(p, vec3(3, cos(time)+2.0, 7), 0.5);
    float sphereD2 = sdSphere(p, vec3(-3, sin(time)+2.0, 7.0), 0.75);
    float sphereD3 = sdSphere(p, vec3(-3, cos(time*1.25)+1.25, 3.0), 0.25);
    float planeD = sdPlane(p - vec3(2.0, 2.0, 3.0));

    vec3 torusPos = p-vec3(0.0, 1.25, 6.0);
    torusPos.yz *= Rot(time);
    float torusD = sdTorus(torusPos, vec2(1.0, 0.25));

	float torusD2 = sdTorus(p-vec3(-3.0, sin(time*1.25)+1.25, 3.0), vec2(0.3, 0.1));

    Mat mat = Mat(vec3(0.0));
    Mat mSphere = Mat(vec3(0.3, 0.3, 0.6));
    Mat mSphere2 = Mat(vec3(0.6, 0.3, 0.3));
    Mat mSphere3 = Mat(vec3(0.6, 0.6, 0.3));
    Mat mTorus = Mat(vec3(0.2, 0.6, 0.2));
    Mat mTorus2 = Mat(vec3(0.2, 0.5, 0.8));

    mat = matTest(mat, step(sphereD, 0.01), mSphere);
    mat = matTest(mat, step(sphereD2, 0.01), mSphere2);
    mat = matTest(mat, step(sphereD3, 0.01), mSphere3);
    mat = matTest(mat, step(torusD, 0.01), mTorus);
    mat = matTest(mat, step(torusD2, 0.01), mTorus2);

    return mat;
}

float RayMarch (vec3 ro, vec3 rd) {
    float dO = 0.0;

    for ( int i = 0; i < MAX_STEPS; i++) {
        vec3 p = ro + rd * dO;
        float dS = GetDist(p);
        dO += dS;
        if(dO > MAX_DIST || dS < SURF_DIST) break;
    }
    return dO;
}

vec3 GetNormal(vec3 p) {
    float d = GetDist(p);
    vec2 e = vec2(0.01, 0);

    vec3 n = d - vec3(
        GetDist(p - e.xyy),
        GetDist(p - e.yxy),
        GetDist(p - e.yyx));

    return normalize(n);
}

float GetLight(vec3 p, vec3 v) {
	vec3 lightPos = vec3(0, 5, 6);
    //lightPos.xz += vec2(sin(iTime), cos(iTime));
    vec3 l = normalize(lightPos - p);
	vec3 n = GetNormal(p);

    float dif = clamp(dot(n, l), 0.0, 1.0);
    float d = RayMarch(p+n*SURF_DIST*2., l);
    if (d < length(lightPos - p)) {
     	dif *= 0.1;
    }
    vec3 b = reflect(l, n);
    return dif;
}

void calcCamera( out vec3 ro, out vec3 ta )
{
	float an = 0.1*time;
	ro = vec3( 1.5*cos(an), 2.0, 1.5*sin(an) );
    ta = vec3( 0.0, 1.0, 0.0 );

}


void main(void) {
	// vec2 uv = gl_FragCoord.xy / resolution.xy;

	// gl_FragColor = vec4(uv, 1.0, 1.0);

	vec2 uv = (gl_FragCoord.xy - 0.5 * resolution.xy)/resolution.y;

    vec3 col = vec3(0.0);

    //vec3 ro = vec3(0, 3., -2.5);

    // camera movement
	vec3 ro, ta;
	calcCamera( ro, ta );

    vec3 rd = normalize(vec3(uv.x, uv.y-0.25, 1));

    float d = RayMarch(ro, rd);

    vec3 p = ro + rd * d;
    Mat m = GetMat(p);

    float dif = GetLight(p, rd);
    vec3 nor = GetNormal(p);

    col = vec3(dif)* vec3(0.1, 0.3, 0.1);
    col += m.diffuse;

    gl_FragColor = vec4(col,1.0);
}