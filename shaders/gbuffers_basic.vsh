#include "/include/glsl_version.glsl"
#define vsh

out vec2 lmCoord;
out vec4 glColor;

void main() {
	gl_Position = ftransform();
	lmCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glColor = gl_Color;
}