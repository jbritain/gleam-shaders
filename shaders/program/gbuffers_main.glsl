#include "/include/settings.glsl"

#ifdef vsh
out vec2 lmCoord;
out vec2 texCoord;
out vec4 glColor;
out vec3 normal;
out vec3 glNormal;

void main() {
	gl_Position = ftransform();
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmCoord = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glColor = gl_Color;
	glNormal = gl_Normal;
}
#endif

//==============================================================================================================================

#ifdef fsh
uniform sampler2D lightmap;
uniform sampler2D gtexture;

#include "/lib/encoding.glsl"

in vec2 lmCoord;
in vec2 texCoord;
in vec4 glColor;
in vec3 glNormal;


/* DRAWBUFFERS:012 */
layout(location = 0) out vec4 outColor;
layout(location = 1) out vec4 outNormal;
layout(location = 2) out vec4 outLightmapCoords;

void main() {
	vec4 color = texture(gtexture, texCoord) * glColor;
	color *= texture(lightmap, lmCoord);
	if (color.a < 0.1) {
		discard;
	}

	outColor = color;
	outNormal.xyz = encodeNormal(gl_NormalMatrix * glNormal); // encode the normal into an unsigned format
	vec2 normalizedLmCoord = (lmCoord * 33.05 / 32.0) - (1.05 / 32); // put in range [0,1]
	outLightmapCoords.rgb = vec3(normalizedLmCoord, 0.0);
}
#endif