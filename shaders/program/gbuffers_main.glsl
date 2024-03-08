#include "/include/settings.glsl"

#ifdef vsh
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

in vec3 mc_Entity;

out vec4 shadowPosition;
out vec2 lmCoord;
out vec2 texCoord;
out vec4 glColor;
out vec3 normal;
out vec3 glNormal;
out vec3 viewPos;

#include "/lib/shadows.glsl"


void main() {
	gl_Position = ftransform();

	viewPos = (gl_ModelViewMatrix * gl_Vertex).xyz;
	
	shadowPosition = getShadowPos();
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
uniform sampler2D shadowcolor0;
uniform sampler2D shadowtex0;
uniform sampler2D shadowtex1;
uniform mat4 gbufferModelViewInverse;
uniform float far;

// coloured shadows artifacting fix
const bool shadowcolor0Nearest = true;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;

#include "/lib/encoding.glsl"

in vec2 lmCoord;
in vec2 texCoord;
in vec4 glColor;
in vec3 glNormal;
in vec3 viewPos;
in vec4 shadowPosition;

/* DRAWBUFFERS:0123 */
layout(location = 0) out vec4 outColor;
layout(location = 1) out vec4 outNormal;
layout(location = 2) out vec4 outLightmapCoords;
layout(location = 3) out vec4 outShadowPosition;

void main() {

	vec3 eyePlayerPos = mat3(gbufferModelViewInverse) * viewPos;

	if(length(eyePlayerPos) >= far){ // discard stuff out of render distance so that `far` is actually as far as anything will be
		discard;
	}

	vec4 color = texture(gtexture, texCoord) * glColor;

	if (color.a < 0.1) {
		discard;
	}


	outColor = color;
	outNormal.xyz = encodeNormal(gl_NormalMatrix * glNormal); // encode the normal into an unsigned format
	vec2 normalizedLmCoord = (lmCoord * 33.05 / 32.0) - (1.05 / 32); // put in range [0,1]
	outLightmapCoords.rgb = vec3(normalizedLmCoord, 0.0);
	outShadowPosition = shadowPosition;
}
#endif