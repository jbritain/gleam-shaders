#include "/include/settings.glsl"

#ifdef vsh
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

in vec3 mc_Entity;

out vec4 shadowPos;
out vec2 lmCoord;
out vec2 texCoord;
out vec4 glColor;
out vec3 normal;
out vec3 glNormal;

#include "/lib/shadows.glsl"


void main() {
	gl_Position = ftransform();
	
	shadowPos = getShadowPos();
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

// coloured shadows artifacting fix
const bool shadowcolor0Nearest = true;
const bool shadowtex0Nearest = true;
const bool shadowtex1Nearest = true;

in vec4 shadowPos;

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

	vec2 lm = lmCoord;

	color *= texture(lightmap, lmCoord);
	if (color.a < 0.1) {
		discard;
	}

	if (shadowPos.w > 0.0) {
		//surface is facing towards shadowLightPosition
		#if COLORED_SHADOWS == 0
			//for normal shadows, only consider the closest thing to the sun,
			//regardless of whether or not it's opaque.
			if (texture2D(shadowtex0, shadowPos.xy).r < shadowPos.z) {
		#else
			//for invisible and colored shadows, first check the closest OPAQUE thing to the sun.
			if (texture2D(shadowtex1, shadowPos.xy).r < shadowPos.z) {
		#endif
			//surface is in shadows. reduce light level.
			lm.y *= SHADOW_BRIGHTNESS;
		}
		else {
			//surface is in direct sunlight. increase light level.
			lm.y = mix(31.0 / 32.0 * SHADOW_BRIGHTNESS, 31.0 / 32.0, sqrt(shadowPos.w));
			#if COLORED_SHADOWS == 1
				//when colored shadows are enabled and there's nothing OPAQUE between us and the sun,
				//perform a 2nd check to see if there's anything translucent between us and the sun.
				if (texture2D(shadowtex0, shadowPos.xy).r < shadowPos.z) {
					//surface has translucent object between it and the sun. modify its color.
					//if the block light is high, modify the color less.
					vec4 shadowLightColor = texture2D(shadowcolor0, shadowPos.xy);
					//make colors more intense when the shadow light color is more opaque.
					shadowLightColor.rgb = mix(vec3(1.0), shadowLightColor.rgb, shadowLightColor.a);
					//also make colors less intense when the block light level is high.
					shadowLightColor.rgb = mix(shadowLightColor.rgb, vec3(1.0), lm.x);
					//apply the color.
					//color.rgb *= shadowLightColor.rgb;
				}
			#endif
		}
	}
	color *= texture2D(lightmap, lm);

	outColor = color;
	outNormal.xyz = encodeNormal(gl_NormalMatrix * glNormal); // encode the normal into an unsigned format
	vec2 normalizedLmCoord = (lmCoord * 33.05 / 32.0) - (1.05 / 32); // put in range [0,1]
	outLightmapCoords.rgb = vec3(normalizedLmCoord, 0.0);
}
#endif