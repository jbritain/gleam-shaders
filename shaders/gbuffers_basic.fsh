#include "/include/glsl_version.glsl"
#define fsh

uniform sampler2D lightmap;

in vec2 lmCoord;
in vec4 glColor;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
	color = glColor * texture(lightmap, lmCoord);
}