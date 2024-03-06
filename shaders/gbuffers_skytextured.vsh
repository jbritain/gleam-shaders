#include "/include/glsl_version.glsl"
#define vsh

out vec2 texCoord;
out vec4 glColor;

void main() {
	gl_Position = ftransform();
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	glColor = gl_Color;
}