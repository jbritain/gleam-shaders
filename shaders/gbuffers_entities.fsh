#include "/include/glsl_version.glsl"
#define fsh

uniform sampler2D lightmap;
uniform sampler2D gtexture;
uniform vec4 entityColor;

in vec2 lmCoord;
in vec2 texCoord;
in vec4 glColor;

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 color;

void main() {
	color = texture(gtexture, texCoord) * glColor;
	color.rgb = mix(color.rgb, entityColor.rgb, entityColor.a);
	color *= texture(lightmap, lmCoord);
	if (color.a < 0.1) {
		discard;
	}
}