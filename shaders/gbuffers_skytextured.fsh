#include "/include/glsl_version.glsl"
#define fsh

uniform sampler2D gtexture;

in vec2 texCoord;
in vec4 glColor;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
	color = texture(gtexture, texCoord) * glColor;
	if (color.a < 0.1) {
		discard;
	}
}