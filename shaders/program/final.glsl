#include "/include/settings.glsl"

#ifdef vsh

out vec2 texCoord;

void main() {
	gl_Position = ftransform();
	texCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}

#endif

//==============================================================================================================================

#ifdef fsh

#define DRAW_TEXTURE colortex0 // [colortex0 colortex1 colortex2 colortex3 shadowtex0 shadowtex1 shadowcolor0 depthtex0 depthtex1 depthtex2]
#define DRAW_R
#define DRAW_G
#define DRAW_B
#define DRAW_A

uniform sampler2D DRAW_TEXTURE;

in vec2 texCoord;

#include "/lib/util.glsl"

/* DRAWBUFFERS:0 */
layout(location = 0) out vec4 outColor;

void main(){
	outColor.rgb = vec3(0.0);
	outColor.a = 1.0;

	#ifdef DRAW_R
  outColor.r = texture(DRAW_TEXTURE, texCoord).r;
	#endif

	#ifdef DRAW_G
  outColor.g = texture(DRAW_TEXTURE, texCoord).g;
	#endif

	#ifdef DRAW_B
  outColor.b = texture(DRAW_TEXTURE, texCoord).b;
	#endif

	#ifdef DRAW_A
  outColor.a = texture(DRAW_TEXTURE, texCoord).b;
	#endif
}

#endif